const events = require('../events/forum_events');

module.exports = {
    SQL_GET_USER_BY_USER_ID: `
            SELECT 
                CASE WHEN users.nickname IS NOT NULL THEN users.nickname ELSE CONCAT(users.first_name, ' ', users.last_name) END AS name,
                CASE WHEN users.role = 0 THEN :STN_0 
                    WHEN users.role = 1 THEN :STN_1 
                    WHEN users.role = 2 THEN :STN_2 
                    WHEN users.role = 3 THEN (emergency_service_category_translations.translation)
                    WHEN users.role = 4 THEN (profession_consultant_service_category_translations.translation) 
                ELSE :STN_5 END AS user_type,
                images.url  AS image_path,
                users.location,
                users.email,
                users.phone,
                users.status, 
                users.role, 
                users.device_type, 
                users.birthday 
            FROM users
                LEFT JOIN images ON images.id = users.image_id
                LEFT JOIN emergency_services ON users.service_id = emergency_services.id
                LEFT JOIN emergency_service_category_translations ON emergency_services.emergency_service_category_id = emergency_service_category_translations.emergency_service_category_id AND emergency_service_category_translations.language_id = 1
                LEFT JOIN profession_consultant_service_category_translations ON users.consultant_category_id = profession_consultant_service_category_translations.profession_consultant_service_category_id AND profession_consultant_service_category_translations.language_id = 1
            WHERE users.id = :U_ID;`,

    SQL_GET_CONSULTANT_PROFESSION: `SELECT 
         profession_consultant_service_category_translations.profession_consultant_service_category_id as id,
         profession_consultant_service_category_translations.translation,
         profession_consultant_service_category_translations.language_id,
         languages.code,
         languages.title
     FROM profession_consultant_service_category_translations
         JOIN languages ON languages.id = profession_consultant_service_category_translations.language_id
         JOIN profession_consultant_service_categories ON profession_consultant_service_categories.id = profession_consultant_service_category_translations.profession_consultant_service_category_id
     WHERE languages.status=1 AND
     profession_consultant_service_categories.status = 1 AND 
     profession_consultant_service_category_translations.profession_consultant_service_category_id = :PROFESSION_ID;`,

    SQL_GET_CATEGORY: `SELECT 
         emergency_service_category_translations.emergency_service_category_id as id,
         emergency_service_category_translations.translation,
         emergency_service_category_translations.language_id,
         languages.code,
         languages.title
     FROM emergency_service_category_translations
         JOIN languages ON languages.id = emergency_service_category_translations.language_id
         JOIN emergency_service_categories ON emergency_service_categories.id = emergency_service_category_translations.emergency_service_category_id
     WHERE languages.status=1 AND
     emergency_service_categories.status = 1 AND 
     emergency_service_category_translations.emergency_service_category_id = :CATEGORY_ID;`,

    SQL_GET_ALL_DEVICE_TOKENS: `SELECT device_token FROM users where device_token is not Null AND status = 1`,

    SQL_GET_ALL_DEVICE_TOKENS_ONE: `SELECT device_token FROM users where device_token is not Null AND status = 1 AND language_id = 1 AND device_type != 1`,

    SQL_GET_ALL_DEVICE_TOKENS_TWO: `SELECT device_token FROM users where device_token is not Null AND status = 1 AND language_id = 2 AND device_type != 1`,

    refresh_forums: async function (app, req, res, io) {
        if (this.check_api_key(req, res)) {
            let forum_id = req.params.forum_id;
            let is_create = parseInt(req.params.is_create);
            if (forum_id) {
                forum_id = parseInt(forum_id);
                if (forum_id && forum_id > 0) {
                    let clients_in_forum = helper.getClientsInRooms(io, forum_id);
                    let clients_not_in_forum = helper.getClientsNotInRooms(io);

                    if (is_create === 0) {
                        for (const socket of clients_in_forum) {
                            events.more_info(io, socket, {
                                forum_id: forum_id,
                                comments_page: socket.comments_page,
                                comments_rows: socket.comments_rows
                            }, function (json) {
                                io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['more_info']['resultName'], json);
                            });
                        }
                    }

                    for (const socket of clients_not_in_forum) {
                        events.get_all_forums(io, socket, {
                            forums_rows: socket.forums_rows,
                            forums_page: socket.forums_page
                        }, function (json) {
                            io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['get_all_forums']['resultName'], json);
                        });
                    }

                    return res.status(200).send({
                        message: cfg['APP.MESSAGES_LABELS']['is_successfully_refreshed'].replace('{NAME}', 'Forum')
                    });
                }
            }

            res.status(422).send({
                message: cfg['APP.MESSAGES_LABELS']['field_is_not_valid'].replace('{FIELD_NAME}', 'forum_id')
            });
        }
    },

    send_forum_notification: async function (app, req, res, io) {
        let resp_one = await this.send_forum_notification_lng_one(app, req, res, io);
        let resp_two = await this.send_forum_notification_lng_two(app, req, res, io);
        let resp_android = await this.send_forum_notification_android(app, req, res, io);
    },

    send_forum_notification_lng_one: async function (app, req, res, io) {
        //SQL_GET_ALL_DEVICE_TOKENS
        if (this.check_api_key(req, res)) {
            mysql.query(this.SQL_GET_ALL_DEVICE_TOKENS_ONE, {}, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    if (result.length !== 0) {
                        let device_tokens = [];
                        for (let p in result) {
                            if (result.hasOwnProperty(p)) {
                                device_tokens.push(result[p]['device_token'])
                            }
                        }
                        let data = {};
                        data["notification_type"] = "forum";
                        data["text_arm"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_arm;
                        data["text_geo"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_geo;
                        data["text_en"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_en;
                        data["title_arm"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_arm
                        data["title_geo"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_geo
                        data["title_en"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_en

                        let sz = 400;
                        for (let i = 0; i < device_tokens.length; i = i + 400) {
                            let message = {
                                notification: {
                                    title: cfg['APP.MESSAGES_LABELS']['forum_push_notification']['title'][1],
                                    body: cfg['APP.MESSAGES_LABELS']['forum_push_notification']['body'][1]
                                },
                                data: data,
                                tokens: device_tokens.slice(i, i + sz)
                            };
                            admin.messaging().sendMulticast(message)
                                .then((response) => {
                                    if (i + sz >= device_tokens.length) {
                                        return "OK"
                                    }
                                    // Response is a message ID string.
                                    console.log('Successfully sent message:', response.responses['error']);
                                })
                                .catch((error) => {
                                    console.log('Error sending message:', error);
                                });
                        }
                    }
                }
            });
        } else {
            res.status(401).send({
                message: "Auth error"
            });
        }
    },
    send_forum_notification_lng_two: async function (app, req, res) {
        //SQL_GET_ALL_DEVICE_TOKENS

        if (this.check_api_key(req, res)) {
            mysql.query(this.SQL_GET_ALL_DEVICE_TOKENS_TWO, {}, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    if (result.length !== 0) {
                        let device_tokens = [];
                        for (let p in result) {
                            if (result.hasOwnProperty(p)) {
                                device_tokens.push(result[p]['device_token']);
                            }
                        }
                        let data = {};
                        data["notification_type"] = "forum";
                        data["text_arm"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_arm;
                        data["text_geo"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_geo;
                        data["text_en"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_en;
                        data["title_arm"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_arm
                        data["title_geo"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_geo
                        data["title_en"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_en

                        let sz = 400;
                        for (i = 0; i < device_tokens.length; i = i + 400) {
                            let message = {
                                notification: {
                                    title: cfg['APP.MESSAGES_LABELS']['forum_push_notification']['title'][2],
                                    body: cfg['APP.MESSAGES_LABELS']['forum_push_notification']['body'][2]
                                },
                                data: data,
                                tokens: device_tokens.slice(i, i + sz)
                            };
                            admin.messaging().sendMulticast(message)
                                .then((response) => {
                                    if (i + sz >= device_tokens.length) {
                                        return "OK"
                                    }
                                    // Response is a message ID string.
                                    console.log('Successfully sent message:', response.responses['error']);
                                })
                                .catch((error) => {
                                    console.log('Error sending message:', error);
                                });
                        }
                    }

                }
            });
        } else {
            res.status(401).send({
                message: "Auth error"
            });
        }
    },

    send_forum_notification_android: async function (app, req, res) {
        //SQL_GET_ALL_DEVICE_TOKENS
        if (this.check_api_key(req, res)) {
            mysql.query(this.SQL_GET_ALL_DEVICE_TOKENS, {}, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    let device_tokens = [];
                    if (result.length !== 0) {
                        for (let p in result) {
                            if (result.hasOwnProperty(p)) {
                                device_tokens.push(result[p]['device_token']);
                            }
                        }
                        let data = {};
                        data["notification_type"] = "forum";
                        data["text_arm"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_arm;
                        data["text_geo"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_geo;
                        data["text_en"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].text_en;
                        data["title_arm"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_arm
                        data["title_geo"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_geo
                        data["title_en"] = cfg['APP.MESSAGES_LABELS']['forum_notifications'].title_en

                        let sz = 400;
                        for (i = 0; i < device_tokens.length; i = i + 400) {
                            let message = {
                                data: data,
                                tokens: device_tokens.slice(i, i + sz)
                            };
                            admin.messaging().sendMulticast(message)
                                .then((response) => {
                                    if (i + sz >= device_tokens.length) {
                                        res.status(200).send({
                                            message: "OK"
                                        });
                                    }
                                    // Response is a message ID string.
                                    console.log('Successfully sent message:', response);
                                })
                                .catch((error) => {
                                    console.log('Error sending message:', error);
                                });
                        }
                    }
                    if (device_tokens.length === 0) {
                        res.status(200).send({
                            message: "OK"
                        });
                    }
                }
            });
        } else {
            res.status(401).send({
                message: "Auth error"
            });
        }
    },
    refresh_profile: async function (app, req, res, io) {
        if (this.check_api_key(req, res)) {
            let user_id = req.params.user_id;
            if (user_id) {
                user_id = parseInt(user_id);
                if (user_id && user_id > 0) {
                    let clients = helper.getClientByUserID(io, user_id);
                    let params = {
                        "STN_0": cfg['SQL_PARAMS.SERVICES_TYPES']['0']['name'],
                        "STN_1": cfg['SQL_PARAMS.SERVICES_TYPES']['1']['name'],
                        "STN_2": cfg['SQL_PARAMS.SERVICES_TYPES']['2']['name'],
                        "STN_3": cfg['SQL_PARAMS.SERVICES_TYPES']['3']['name'],
                        "STN_4": cfg['SQL_PARAMS.SERVICES_TYPES']['4']['name'],
                        "STN_5": cfg['SQL_PARAMS.SERVICES_TYPES']['5']['name'],
                        "U_ID": user_id
                    };
                    mysql.query(this.SQL_GET_USER_BY_USER_ID, params, (err, result) => {
                        if (err) {
                            return res.status(400).send({
                                message: err.message
                            });
                        }
                        try {
                            if (result.length) {
                                for (const socket of clients) {
                                    if (result[0]['status'] === 0) {
                                        io.sockets.connected[socket.id].disconnect();
                                    } else {
                                        helper.setUserInfoInSocket(socket, result[0]);
                                        io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['profile_info']['resultName'], {
                                            error: null,
                                            data: {
                                                name: socket['name'],
                                                user_type: socket['user_type'],
                                                user_id: socket['user_id'],
                                                image_path: socket['image_path'],
                                                location: socket['location'],
                                                email: socket['email'],
                                                phone: socket['phone'],
                                                birthday: socket['birthday'],
                                                role: socket['role'],
                                            }
                                        });

                                    }
                                }
                                return res.status(200).send({
                                    message: cfg['APP.MESSAGES_LABELS']['is_successfully_refreshed'].replace('{NAME}', 'Profile')
                                });
                            } else {
                                return res.status(404).send({
                                    message: cfg['APP.MESSAGES_LABELS']['user_is_not_found']
                                });
                            }
                        } catch (error) {
                            return res.status(400).send({
                                message: error.message
                            });
                        }
                    });
                }
            } else {
                res.status(422).send({
                    message: cfg['APP.MESSAGES_LABELS']['field_is_not_valid'].replace('{FIELD_NAME}', 'forum_id')
                });
            }
        }
    },

    refresh_profession: async function (app, req, res, io) {
        if (this.check_api_key(req, res)) {
            let profession_id = req.params.profession_id;
            if (profession_id) {
                profession_id = parseInt(profession_id);
                let params = {
                    "PROFESSION_ID": profession_id
                };
                mysql.query(this.SQL_GET_CONSULTANT_PROFESSION, params, (err, result) => {
                    if (err) {
                        return res.status(400).send({
                            message: err.message
                        });
                    }
                    try {
                        if (result.length) {
                            let clients = helper.getConnectedClients(io);
                            for (const socket of clients) {
                                io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['new_profession']['name'], {
                                    error: null,
                                    data: result
                                });
                            }
                            return res.status(200).send({
                                message: cfg['APP.MESSAGES_LABELS']['is_successfully_refreshed'].replace('{NAME}', 'Profession')
                            });
                        } else {
                            return res.status(404).send({
                                message: 'not_found'
                            });
                        }
                    } catch (error) {
                        return res.status(400).send({
                            message: error.message
                        });
                    }
                });
            } else {
                res.status(422).send({
                    message: cfg['APP.MESSAGES_LABELS']['field_is_not_valid'].replace('{FIELD_NAME}', 'profession_id')
                });
            }
        }
    },

    refresh_category: async function (app, req, res, io) {
        if (this.check_api_key(req, res)) {
            let category_id = req.params.category_id;
            if (category_id) {
                category_id = parseInt(category_id);
                let params = {
                    "CATEGORY_ID": category_id
                };
                mysql.query(this.SQL_GET_CATEGORY, params, (err, result) => {
                    if (err) {
                        return res.status(400).send({
                            message: err.message
                        });
                    }
                    try {
                        if (result.length) {
                            let clients = helper.getConnectedClients(io);
                            for (const socket of clients) {
                                io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['new_category']['name'], {
                                    error: null,
                                    data: result
                                });
                            }
                            return res.status(200).send({
                                message: cfg['APP.MESSAGES_LABELS']['is_successfully_refreshed'].replace('{NAME}', 'Category')
                            });
                        } else {
                            return res.status(404).send({
                                message: 'not_found'
                            });
                        }
                    } catch (error) {
                        return res.status(400).send({
                            message: error.message
                        });
                    }
                });
            } else {
                res.status(422).send({
                    message: cfg['APP.MESSAGES_LABELS']['field_is_not_valid'].replace('{FIELD_NAME}', 'forum_id')
                });
            }
        }
    },

    check_api_key: function (req, res) {
        if (req.params.secret_key && req.params.secret_key === cfg["APP.API_KEY"]) {
            return true;
        }
        res.status(403).send({
            message: cfg['APP.MESSAGES_LABELS']['you_dont_have_permissions']
        });
        return false;
    },

};
