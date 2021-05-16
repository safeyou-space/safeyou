let utils = require('util');

module.exports = {
    SQL_GET_ALL_FROUMS: `
            SELECT
                forums.id,
                (
                    SELECT (SELECT COUNT(id) FROM forum_discussions WHERE ((forum_discussions.reply_user_id = forum_notifications.user_id OR forum_discussions.reply_user_id IS NULL) AND forum_discussions.forum_id = forum_notifications.forum_id) AND forum_discussions.created_at >= forum_notifications.datetime) AS 'COUNT' FROM forum_notifications WHERE forum_notifications.forum_id = forums.id AND user_id = :USER_ID
                ) AS NEW_MESSAGES_COUNT,
                forum_translations.title,
                forum_translations.sub_title,
                forum_translations.short_description,
                forum_translations.description,
                forums.created_at,
                languages.code,
                CASE WHEN images.url IS NULL THEN (SELECT url FROM images WHERE TYPE = :DEFAULT_FORUM_IMG_TYPE) ELSE images.url END AS image_path,
                (SELECT COUNT(id) FROM forum_discussions WHERE forum_discussions.forum_id = forums.id) AS comments_count
                FROM forums
                LEFT JOIN images ON images.id = forums.image_id
                LEFT JOIN forum_translations ON forum_translations.forum_id = forums.id
                LEFT JOIN languages ON languages.id = forum_translations.language_id
                WHERE languages.code = :LANG_CODE AND forums.status = 1 
                ORDER BY forums.id DESC LIMIT :F_ROWS OFFSET :F_PAGE;
                SELECT COUNT(id) AS total_count FROM forums WHERE forums.status = 1;`,

    SQL_GET_FROUM_BY_ID: `
            SELECT 
                forums.id, 
                forum_translations.title, 
                forum_translations.sub_title,
                forum_translations.short_description, 
                forum_translations.description,  
                forums.created_at, 
                languages.code, 
                CASE WHEN images.url IS NULL THEN (SELECT url FROM images WHERE TYPE = :DEFAULT_FORUM_IMG_TYPE) ELSE images.url END AS image_path,
                (SELECT COUNT(id) FROM forum_discussions WHERE forum_discussions.forum_id = forums.id) AS comments_count
            FROM forums 
                LEFT JOIN images ON images.id = forums.image_id
                LEFT JOIN forum_translations ON forum_translations.forum_id = forums.id
                LEFT JOIN languages ON languages.id = forum_translations.language_id WHERE languages.code = :LANG_CODE 
            AND forums.id = :F_ID AND forums.status = 1;`,

    SQL_GET_COMMENTS_COUNT_AND_TOP_USERS_BY_ID: `
        SELECT 
            (SELECT COUNT(id) FROM forum_discussions WHERE forum_discussions.forum_id = :F_ID) AS comments_count;`,

    SQL_GET_FORUM_COMMENTS_BY_FORUM_ID: `
        SELECT * from (SELECT 
            forum_discussions.user_id,
            forum_discussions.id,
            forum_discussions.reply_id,
            CASE 
                WHEN forum_discussions.group_id IS NULL THEN forum_discussions.id
                else forum_discussions.group_id 
            END as group_id,
            forum_discussions.level,
            users.role AS user_type_id,
            users.consultant_category_id AS consultant_id,
            users.service_id AS service_id,
            reply_cnt.reply_count,
            CASE WHEN users.role = 0 THEN :STN_0 
                WHEN users.role = 1 THEN :STN_1 
                WHEN users.role = 2 THEN :STN_2 
                WHEN users.role = 3 THEN (emergency_service_category_translations.translation)
                WHEN users.role = 4 THEN (profession_consultant_service_category_translations.translation) 
            ELSE :STN_5 END AS user_type,
            CASE WHEN (users.nickname IS NOT NULL AND users.role != 3) THEN users.nickname 
            WHEN (users.role = 3) THEN emergency_services.title
            ELSE CONCAT(users.first_name, ' ', users.last_name) END AS name,
            images.url AS image_path,
            forum_discussions.message,
            forum_discussions.created_at
        FROM forum_discussions 
            LEFT JOIN users ON users.id = forum_discussions.user_id
            LEFT JOIN emergency_services ON users.service_id = emergency_services.id
            LEFT JOIN emergency_service_category_translations ON emergency_services.emergency_service_category_id = emergency_service_category_translations.emergency_service_category_id AND emergency_service_category_translations.language_id = 1
            LEFT JOIN profession_consultant_service_category_translations ON users.consultant_category_id = profession_consultant_service_category_translations.profession_consultant_service_category_id AND profession_consultant_service_category_translations.language_id = :LANG_ID
            LEFT JOIN images ON images.id = users.image_id
            Left Join (SELECT group_id, COUNT(forum_discussions.group_id) AS reply_count FROM forum_discussions WHERE forum_discussions.forum_id = :F_ID AND reply_id IS NOT NULL GROUP BY group_id) reply_cnt ON reply_cnt.group_id = forum_discussions.group_id and forum_discussions.group_id is not null
            WHERE forum_discussions.forum_id = :F_ID AND forum_discussions.group_id %s) as ssss ORDER BY ssss.created_at DESC`,

    SQL_GET_FORUM_COMMENTS_ID_LISTS_BY_FORUM_ID: ` IN (SELECT * from (SELECT forum_discussions.id FROM forum_discussions 
        WHERE forum_discussions.forum_id = :F_ID AND forum_discussions.reply_id IS NULL LIMIT :C_ROWS OFFSET :C_PAGE) as tmp1) `,

    SQL_INSERT_NEW_COMMENT: `INSERT INTO forum_discussions (forum_id, user_id, reply_id, message, group_id, level, reply_user_id, created_at) VALUES (:F_ID, :USER_ID, :REPLY_ID, :MSG, :GRP_ID, :LVL, :REPLY_UID, :CREATED_AT);`,

    SQL_IS_EXISTS_FORUM_BY_ID: `SELECT id FROM forums WHERE id = :F_ID;`,

    SQL_GET_DEVICE_TOKEN_BY_ID: `SELECT device_token, language_id,device_type FROM users WHERE id = :U_ID AND status = 1 limit 1;`,

    get_all_forums: function (io, socket, params, sendToClient) {
        let language_code_1 = params.language_code;
        try {
            if (language_code_1 === undefined) {
                language_code_1 = 'en';
            }

            if (params.forums_rows === undefined) {
                return sendToClient({
                    error: cfg['APP.MESSAGES_LABELS']['field_is_not_found'].replace('{FIELD_NAME}', 'forums_rows'),
                    data: []
                });
            }

            if (params.forums_page === undefined) {
                return sendToClient({
                    error: cfg['APP.MESSAGES_LABELS']['field_is_not_found'].replace('{FIELD_NAME}', 'forums_page'),
                    data: []
                });
            }
            let datetime = params.datetime;
            let forums_rows = parseInt(params.forums_rows);
            if (forums_rows < 0) forums_rows = 10;
            let forums_page = parseInt(params.forums_page);
            if (forums_page < 0) forums_page = 0;
            forums_page = forums_page * forums_rows;
            let lng_id = cfg['APP_LANGUAGES.LANG_ID'][language_code_1]
            socket['forums_rows'] = forums_rows;
            socket['forums_page'] = forums_page;
            socket['comments_rows'] = 10;
            socket['comments_page'] = 0;
            socket['current_room'] = false;

            mysql.query(this.SQL_GET_ALL_FROUMS, {
                "DEFAULT_FORUM_IMG_TYPE": cfg['SQL_PARAMS.DEFAULT_FORUM_IMG_TYPE'],
                "LANG_CODE": language_code_1,
                "LANG_ID": lng_id,
                "USER_ID": socket.user_id,
                "F_ROWS": forums_rows,
                "F_PAGE": forums_page
            }, (err, result, fields) => {
                if (err) {
                    return sendToClient({
                        error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                        data: []
                    });
                } else {
                    for (let i = 0; i < result[0].length; i++) {
                        result[0][i]['created_at'] = moment(result[0][i]['created_at']);
                        if (result[0][i]['NEW_MESSAGES_COUNT'] == null) result[0][i]['NEW_MESSAGES_COUNT'] = 0;
                        if (datetime) {
                            mysql.query(this.SQL_INSERT_OR_UPDATE_NOTIFY_DATE, {
                                "DATE": datetime,
                                "FORUM_ID": result[0][i]['id'],
                                "USER_ID": socket.user_id
                            }, (err, result, fields) => {
                                if (err) {
                                    return sendToClient({
                                        error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                                        data: []
                                    });
                                }
                            });
                        }
                    }
                    let total_data_count = result[1] && result[1][0] && result[1][0]['total_count'] ? result[1][0]['total_count'] : 0;
                    delete result[1];
                    result = result[0];

                    sendToClient({
                        error: null,
                        data: result,
                        total_data_count: total_data_count
                    });
                }
            });
        } catch (error) {
            return sendToClient({
                error: cfg['APP.DEBUG'] === true ? error.message : cfg['APP.MESSAGES_LABELS']['server_error'],
                data: []
            });
        }
    },

    more_info: function (io, socket, params, sendToClient) {
        let language_code_1 = params.language_code;
        try {
            if (language_code_1 === undefined) {
                language_code_1 = 'en';
            }

            if (params.forum_id === undefined) {
                return sendToClient({
                    error: cfg['APP.MESSAGES_LABELS']['field_is_not_found'].replace('{FIELD_NAME}', 'forum_id'),
                    data: {}
                });
            }

            if (params.comments_rows === undefined) {
                return sendToClient({
                    error: cfg['APP.MESSAGES_LABELS']['field_is_not_found'].replace('{FIELD_NAME}', 'comments_rows'),
                    data: {}
                });
            }

            if (params.comments_page === undefined) {
                return sendToClient({
                    error: cfg['APP.MESSAGES_LABELS']['field_is_not_found'].replace('{FIELD_NAME}', 'comments_page'),
                    data: {}
                });
            }

            let forum_id = parseInt(params.forum_id);
            let comments_rows = parseInt(params.comments_rows);
            if (comments_rows < 0) comments_rows = 10;
            let comments_page = parseInt(params.comments_page);
            if (comments_page < 0) comments_page = 0;
            comments_page = comments_page * comments_rows;
            let lng_id = cfg['APP_LANGUAGES.LANG_ID'][language_code_1]

            socket['forums_rows'] = 10;
            socket['forums_page'] = 0;
            socket['comments_rows'] = comments_rows;
            socket['comments_page'] = comments_page;

            mysql.query(this.SQL_GET_FROUM_BY_ID +
                utils.format(this.SQL_GET_FORUM_COMMENTS_BY_FORUM_ID + ' LIMIT :C_ROWS OFFSET :C_PAGE ;', ' IS NULL ') +
                utils.format(this.SQL_GET_FORUM_COMMENTS_BY_FORUM_ID, this.SQL_GET_FORUM_COMMENTS_ID_LISTS_BY_FORUM_ID)
                , {
                    "DEFAULT_FORUM_IMG_TYPE": cfg['SQL_PARAMS.DEFAULT_FORUM_IMG_TYPE'],
                    "LANG_CODE": language_code_1,
                    "LANG_ID": lng_id,
                    "F_ID": forum_id,
                    "C_ROWS": comments_rows,
                    "C_PAGE": comments_page,

                    "STN_0": cfg['SQL_PARAMS.SERVICES_TYPES']['0']['name'],
                    "STN_1": cfg['SQL_PARAMS.SERVICES_TYPES']['1']['name'],
                    "STN_2": cfg['SQL_PARAMS.SERVICES_TYPES']['2']['name'],
                    "STN_3": cfg['SQL_PARAMS.SERVICES_TYPES']['3']['name'],
                    "STN_4": cfg['SQL_PARAMS.SERVICES_TYPES']['4']['name'],
                    "STN_5": cfg['SQL_PARAMS.SERVICES_TYPES']['5']['name'],
                }, (err, result) => {
                    if (err) {
                        return sendToClient({
                            error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                            data: {}
                        });
                    } else {
                        let forum = result[0];
                        if (forum.length !== 0) {
                            let comments = result[1];
                            let comments_reply = result[2];
                            for (let i = 0; i < comments.length; i++) {
                                comments[i]['my'] = socket.user_id === comments[i]['user_id'];
                                comments[i]['created_at'] = moment(comments[i]['created_at']);
                            }
                            for (let i = 0; i < comments_reply.length; i++) {
                                comments_reply[i]['my'] = socket.user_id === comments_reply[i]['user_id'];
                                comments_reply[i]['created_at'] = moment(comments_reply[i]['created_at']);
                            }
                            for (let i = 0; i < forum.length; i++) {
                                forum[i]['created_at'] = forum[i]['created_at'];
                                forum[i]['comments'] = comments;
                                forum[i]['reply_list'] = comments_reply;
                            }

                            socket.join('FORUM#' + forum_id);
                            socket['current_room'] = 'FORUM#' + forum_id;
                        }

                        sendToClient({
                            error: forum.length === 0 ? cfg['APP.MESSAGES_LABELS']['forum_is_not_found'] : null,
                            data: forum.length === 0 ? {} : forum[0]
                        });
                    }
                });
        } catch (error) {
            return sendToClient({
                error: cfg['APP.DEBUG'] === true ? error.message : cfg['APP.MESSAGES_LABELS']['server_error'],
                data: {}
            });
        }
    },

    add_new_comment: function (io, socket, params, sendToClient) {
        try {
            if (params.forum_id && params.messages) {
                if (socket['current_room'] !== ("FORUM#" + params.forum_id)) {
                    return sendToClient({
                        error: cfg['APP.MESSAGES_LABELS']['you_are_not_logged_on_to_the_forum'],
                        data: {}
                    });
                }
                let forum_id = parseInt(params.forum_id);

                mysql.query(this.SQL_IS_EXISTS_FORUM_BY_ID, {"F_ID": forum_id}, (err, result) => {
                    if (err) {
                        return sendToClient({
                            error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                            data: {}
                        });
                    } else {
                        if (result.length === 0) {
                            sendToClient({
                                error: cfg['APP.MESSAGES_LABELS']['forum_is_not_found'],
                                data: {}
                            });
                        } else {
                            let now = new Date();
                            now.setHours(now.getHours() + 4);

                            let user_id = socket.user_id;
                            let created_at = now;
                            let messages = params.messages;
                            let reply_id = params.reply_id;
                            let reply_user_id = params.reply_user_id;
                            if (!reply_user_id) reply_user_id = null;
                            let group_id = params.group_id;
                            if (!group_id) group_id = null;
                            let level = params.level;
                            if (!level) level = 0;
                            if (!reply_id) reply_id = null;

                            let name = socket.name;
                            let user_type = socket['user_type'];
                            let image_path = socket.image_path;

                            mysql.query(this.SQL_INSERT_NEW_COMMENT, {
                                "F_ID": forum_id,
                                "USER_ID": user_id,
                                "REPLY_UID": reply_user_id,
                                "REPLY_ID": reply_id,
                                "MSG": messages,
                                "GRP_ID": group_id,
                                "LVL": level,
                                "CREATED_AT": created_at
                            }, (err, result) => {
                                console.log(result);
                                if (err) {
                                    return sendToClient({
                                        error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                                        data: {}
                                    });
                                } else {
                                    mysql.query(this.SQL_GET_COMMENTS_COUNT_AND_TOP_USERS_BY_ID, {"F_ID": forum_id}, (err3, result3) => {
                                        if (err3) {
                                            return sendToClient({
                                                error: cfg['APP.DEBUG'] === true ? err3 : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                                                data: {}
                                            });
                                        } else {
                                            if (result3.length === 1) {
                                                if (reply_user_id != null) {
                                                    let redis_data = {
                                                        "id": result.insertId,
                                                        "forum_id": forum_id,
                                                        "reply_id": reply_id,
                                                        "user_id": user_id,
                                                        "user_type": user_type,
                                                        "level": level,
                                                        "name": name,
                                                        "image_path": image_path,
                                                        "isReaded": 0,
                                                        "key": `user_${reply_user_id}_${user_id}_${result.insertId}`,
                                                        "created_at": now.toISOString()
                                                    };
                                                    redis_db.set(`user_${reply_user_id}_${user_id}_${result.insertId}`, cfg['REDIS.EXPIRE'], redis_data);
                                                    this.sendNotifications(io, reply_user_id, redis_data);
                                                    this.sendFireBaseNotifications(reply_user_id, redis_data);

                                                    let clients1 = helper.getClientByUserID(io, reply_user_id);
                                                    for (const socket1 of clients1) {
                                                        this.get_total_new_comments_countEx(io, socket1, null);
                                                    }
                                                }

                                                let resultObj = {
                                                    "comments_count": result3[0]['comments_count'],
                                                    "id": result.insertId,
                                                    "group_id": group_id == null ? parseInt(result.insertId) : parseInt(group_id),
                                                    "level": parseInt(level),
                                                    "reply_id": parseInt(reply_id),
                                                    "user_id": user_id,
                                                    "name": name,
                                                    "user_type": user_type,
                                                    "consultant_id": socket['consultant_id'],
                                                    "user_type_id": socket['user_type_id'],
                                                    "image_path": image_path,
                                                    "message": messages,
                                                    "my": false,
                                                    "created_at": now.toISOString()
                                                };
                                                this.sendMessageMeAndAll(io, socket, params, resultObj, sendToClient);

                                                let clients_not_in_forum = helper.getClientsNotInRooms(io);
                                                for (const socket of clients_not_in_forum) {
                                                    this.get_all_forums(io, socket, {
                                                        forums_rows: socket.forums_rows,
                                                        forums_page: socket.forums_page,
                                                    }, function (json) {
                                                        io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['get_all_forums']['resultName'], json);
                                                    });
                                                }
                                            }
                                        }
                                    });
                                }
                            });
                        }
                    }
                });
            } else {
                sendToClient({
                    error: cfg['APP.MESSAGES_LABELS']['field_is_not_found'].replace('{FIELD_NAME}',
                        params.forum_id ? (params.messages ? '' : 'messages') : 'forum_id'),
                    data: {}
                });
            }
        } catch (error) {
            return sendToClient({
                error: cfg['APP.DEBUG'] === true ? error.message : cfg['APP.MESSAGES_LABELS']['server_error'],
                data: {}
            });
        }
    },

    profile_info: function (io, socket, params, sendToClient) {
        try {
            sendToClient({
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
                    consultant_id: socket['consultant_id'],
                    user_type_id: socket['user_type_id'],
                }
            });
        } catch (error) {
            return sendToClient({
                error: cfg['APP.DEBUG'] === true ? error.message : cfg['APP.MESSAGES_LABELS']['server_error'],
                data: {}
            });
        }
    },

    new_profession: function (io, socket, sendToClient) {
    },

    new_category: function (io, socket, sendToClient) {
    },

    sendMessageMeAndAll: function (io, socket, params, resultObj, sendToClient) {
        socket.to(socket['current_room']).emit(params['event_name_result'], {
            error: null,
            data: resultObj
        });
        for (const cSocket of helper.getConnectedClients(io)) {
            this.emit_new_comments_count_result(false, cSocket);
        }
        resultObj['my'] = true;
        sendToClient({
            error: null,
            data: resultObj
        });
    },

    /**
     * NOTIFY
     */

    SQL_INSERT_OR_UPDATE_NOTIFY_DATE: `INSERT forum_notifications(datetime,forum_id, user_id) VALUES (FROM_UNIXTIME(:DATE),:FORUM_ID,:USER_ID) ON DUPLICATE KEY UPDATE datetime=FROM_UNIXTIME(:DATE)`,

    SQL_GET_COMMENTS_COUNT_ALL2: `SELECT forum_id, (SELECT COUNT(id) FROM forum_discussions WHERE ((forum_discussions.reply_user_id = :USER_ID OR forum_discussions.reply_user_id IS NULL) AND forum_discussions.forum_id = forum_notifications.forum_id) AND forum_discussions.created_at >= forum_notifications.datetime) AS count FROM forum_notifications WHERE forum_notifications.forum_id != 0 AND user_id = :USER_ID ORDER BY COUNT DESC;`,

    SQL_GET_COMMENTS_COUNT_BY2: `SELECT forum_id, (SELECT COUNT(id) FROM forum_discussions WHERE ((forum_discussions.reply_user_id = :USER_ID OR forum_discussions.reply_user_id IS NULL) AND forum_discussions.forum_id = :FORUM_ID) AND forum_discussions.created_at >= forum_notifications.datetime) AS count FROM forum_notifications WHERE forum_notifications.forum_id = :FORUM_ID AND user_id = :USER_ID ORDER BY COUNT DESC;`,

    SQL_INSERT_OR_UPDATE_COMMENTS_TOTAL_COUNT_DATE: `INSERT forum_total_notifications(datetime, user_id) VALUES (FROM_UNIXTIME(:DATE), :USER_ID) ON DUPLICATE KEY UPDATE datetime=FROM_UNIXTIME(:DATE)`,

    SQL_GET_COMMENTS_COUNT_TOTAL: `SELECT COUNT(created_at) as count FROM forum_discussions WHERE reply_user_id = :USER_ID AND created_at >= (SELECT DATETIME FROM forum_total_notifications WHERE user_id = :USER_ID);`,

    get_new_comments_count: function (io, socket, params, sendToClient) {
        try {
            let forum_id = params.forum_id;
            if (forum_id) {
                let datetime = params.datetime;
                if (datetime) {
                    let user_id = socket['user_id'];
                    return mysql.query(this.SQL_INSERT_OR_UPDATE_NOTIFY_DATE, {
                        "DATE": datetime,
                        "FORUM_ID": forum_id,
                        "USER_ID": user_id
                    }, (err, result, fields) => {
                        if (err) return sendToClient({
                            error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                            data: []
                        });
                        this.emit_new_comments_count_result(forum_id, socket);
                    });
                } else {
                    this.emit_new_comments_count_result(forum_id, socket);
                }
            }
            this.emit_new_comments_count_result(forum_id, socket);
        } catch (error) {
            return sendToClient({
                error: cfg['APP.DEBUG'] === true ? error.message : cfg['APP.MESSAGES_LABELS']['server_error'],
                data: {}
            });
        }
    },

    emit_new_comments_count_result: function (forum_id, socket) {
        let event_name = cfg['APP.NAME'] + '#' + cfg["APP.EVENTS"]["get_new_comments_count"]["resultName"];
        this.emit_new_comments_count_result_ex(forum_id, socket, function (err, result) {
            socket.emit(event_name, {
                error: err,
                data: result
            });
        });
    },

    emit_new_comments_count_result_ex: function (forum_id, socket, callback) {
        try {
            let user_id = socket['user_id'];
            let sql = forum_id ? this.SQL_GET_COMMENTS_COUNT_BY2 : this.SQL_GET_COMMENTS_COUNT_ALL2;
            let sql_params = forum_id ? {"FORUM_ID": forum_id, "USER_ID": user_id} : {"USER_ID": user_id};

            mysql.query(sql, sql_params, (err, result, fields) => {
                if (err) {
                    callback(cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'], []);
                } else {
                    callback(null, result);
                }
            });
        } catch (error) {
            console.log(error);
        }
    },

    notification: function (io, socket, params, sendToClient) {
        this.sendNotifications(io, socket.user_id, false);
    },

    read_notification: function (io, socket, params, sendToClient) {
        let key = params.key;
        if (key !== undefined) {
            redis_db.get(key, function (err, result) {
                result['isReaded'] = 1;
                redis_db.set(key, null, result);
                sendToClient({
                    error: err == null ? null : 'error',
                    data: err == null ? result : null,
                });
            });
        }
    },

    sendNotifications: function (io, reply_user_id, redis_data) {
        let clients = helper.getClientByUserID(io, reply_user_id);
        for (const socket of clients) {
            if (redis_data) {
                io.to(socket.id).emit(`${cfg['APP.NAME']}#${cfg['APP.EVENTS']['notification']['resultName']}`, {
                    error: null,
                    data: redis_data,
                });
            } else {
                redis_db.get(`user_${reply_user_id}_*_*`, function (err, result) {
                    io.to(socket.id).emit(`${cfg['APP.NAME']}#${cfg['APP.EVENTS']['notification']['resultName']}`, {
                        error: err == null ? null : 'error',
                        data: err == null ? result : null,
                    });
                });
            }
        }
    },

    sendFireBaseNotifications: function (reply_user_id, redis_data) {
        mysql.query(this.SQL_GET_DEVICE_TOKEN_BY_ID, {"U_ID": reply_user_id}, (err, result) => {
            if (err) {
                console.log(err)
            } else {
                if (result.length !== 0) {
                    for (let p in redis_data) {
                        if (redis_data.hasOwnProperty(p)) {
                            redis_data[p] = redis_data[p].toString();
                        }
                    }

                    let message;
                    if (result[0].device_type === 1) { // ANDROID
                        redis_data["notification_type"] = "message";
                        redis_data["text_arm"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].text_arm
                        redis_data["text_geo"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].text_geo
                        redis_data["text_en"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].text_en
                        redis_data["title_arm"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].title_arm
                        redis_data["title_geo"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].title_geo
                        redis_data["title_en"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].title_en
                        message = {
                            data: redis_data,
                            token: result[0]['device_token']
                        };
                    } else { // IOS
                        redis_data["notification_type"] = "message";
                        redis_data["text_arm"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].text_arm
                        redis_data["text_geo"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].text_geo
                        redis_data["text_en"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].text_en
                        redis_data["title_arm"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].title_arm
                        redis_data["title_geo"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].title_geo
                        redis_data["title_en"] = cfg['APP.MESSAGES_LABELS']['message_notifications'].title_en
                        message = {
                            notification: {
                                title: cfg['APP.MESSAGES_LABELS']['forum_push_notification']['title'][result[0]['language_id']],
                                body: cfg['APP.MESSAGES_LABELS']['forum_push_notification']['body'][result[0]['language_id']]
                            },
                            data: redis_data,
                            token: result[0]['device_token']
                        };
                    }

                    admin.messaging().send(message)
                        .then((response) => {
                            console.log('Successfully sent message:', response);
                        })
                        .catch((error) => {
                            console.log('Error sending message:', error);
                        });
                }
            }
        });
    },

    get_total_new_comments_count: function (io, socket, params, sendToClient) {
        let datetime = params.datetime;
        this.get_total_new_comments_countEx(io, socket, datetime);
    },

    get_total_new_comments_countEx: function (io, socket, datetime) {
        mysql.query(this.SQL_GET_COMMENTS_COUNT_TOTAL, {
            "FORUM_ID": 0,
            "USER_ID": socket.user_id
        }, (err0, result0, fields0) => {
            if (err0) return io.to(socket.id).emit(`${cfg['APP.NAME']}#${cfg['APP.EVENTS']['get_total_new_comments_count']['resultName']}`, {
                error: cfg['APP.DEBUG'] === true ? err0 : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                count: -1
            });

            if (datetime) {
                mysql.query(this.SQL_INSERT_OR_UPDATE_COMMENTS_TOTAL_COUNT_DATE, {
                    "DATE": datetime,
                    "FORUM_ID": 0,
                    "USER_ID": socket.user_id
                }, (err, result, fields) => {
                    if (err) return io.to(socket.id).emit(`${cfg['APP.NAME']}#${cfg['APP.EVENTS']['get_total_new_comments_count']['resultName']}`, {
                        error: cfg['APP.DEBUG'] === true ? err : cfg['APP.MESSAGES_LABELS']['database_query_error'],
                        count: -1
                    });
                    io.to(socket.id).emit(`${cfg['APP.NAME']}#${cfg['APP.EVENTS']['get_total_new_comments_count']['resultName']}`, {
                        error: null,
                        count: result0.length === 0 ? 0 : result0[0]['count']
                    });
                });
            } else {
                io.to(socket.id).emit(`${cfg['APP.NAME']}#${cfg['APP.EVENTS']['get_total_new_comments_count']['resultName']}`, {
                    error: null,
                    count: result0.length === 0 ? 0 : result0[0]['count']
                });
            }
        });
    },

    delete_comment: function (io, socket, params, sendToClient) {
        try {
            if (cfg['ROLES.COMMENTS_DELETING'].includes(socket['role'])) {
                let group_id = params.group_id === undefined ? 0 : params.group_id;
                let id = params.id === undefined ? 0 : params.id;
                mysql.query('SELECT id, reply_id, forum_id, message FROM forum_discussions WHERE id = :ID or group_id = :ID', {"ID": group_id}, (err, result) => {
                    let idList = [parseInt(id)];
                    this.recCommentsIdList(result, parseInt(id), idList);
                    mysql.query('DELETE FROM forum_discussions WHERE id in (:IDs)', {"IDs": idList}, (err, _result) => {
                        let forum_id = result[0]['forum_id'];
                        if (forum_id && forum_id > 0) {
                            let clients_in_forum = helper.getClientsInRooms(io, forum_id);
                            for (const socket of clients_in_forum) {
                                this.more_info(io, socket, {
                                    forum_id: forum_id,
                                    comments_page: socket.comments_page,
                                    comments_rows: socket.comments_rows
                                }, function (json) {
                                    io.to(socket.id).emit(cfg['APP.NAME'] + "#" + cfg['APP.EVENTS']['more_info']['resultName'], json);
                                });
                            }
                            sendToClient(idList);
                        }
                    });
                });
            } else {
                return sendToClient({
                    error: 'access_denied',
                    data: {}
                });
            }
        } catch (error) {
            return sendToClient({
                error: cfg['APP.DEBUG'] === true ? error.message : cfg['APP.MESSAGES_LABELS']['server_error'],
                data: {}
            });
        }
    },

    recCommentsIdList: function (data, parentId, idList) {
        const reply = data.filter(each => each.reply_id === parentId);
        reply.forEach(child => {
            idList.push(child.id);
            child.subcategories = this.recCommentsIdList(data, child.id, idList);
        });
        return reply;
    }
};
