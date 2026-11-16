module.exports = function (socket) {
    socket['authorized'] = false;

    return {
        SQL_GET_USER_BY_JTI_ID: `
        \n    SELECT            
        \n    users.role AS user_type_id,
        \n    users.consultant_category_id AS consultant_id,
        \n    CASE WHEN (users.nickname IS NOT NULL AND users.role != 3) THEN users.nickname 
        \n      WHEN (users.role = 3) THEN emergency_services.title
        \n    ELSE CONCAT(users.first_name, ' ', users.last_name) END AS name, 
        \n    CASE WHEN users.role = 0 THEN :STN_0 
        \n        WHEN users.role = 1 THEN :STN_1 
        \n        WHEN users.role = 2 THEN :STN_2 
        \n        WHEN users.role = 3 THEN (emergency_service_category_translations.translation)
        \n        WHEN users.role = 4 THEN (profession_consultant_service_category_translations.translation) 
        \n    ELSE :STN_5 END AS user_type,
        \n        oauth_access_tokens.user_id,
        \n        images.url AS image_path,
        \n        users.location,
        \n        users.email,
        \n        users.phone,
        \n        users.role, 
        \n        users.birthday 
        \n    FROM oauth_access_tokens
        \n        JOIN users ON users.id = oauth_access_tokens.user_id            
        \n        LEFT JOIN emergency_services ON users.service_id = emergency_services.id
        \n        LEFT JOIN emergency_service_category_translations ON emergency_services.emergency_service_category_id = emergency_service_category_translations.emergency_service_category_id AND emergency_service_category_translations.language_id = 1
        \n        LEFT JOIN profession_consultant_service_category_translations ON users.consultant_category_id = profession_consultant_service_category_translations.profession_consultant_service_category_id AND profession_consultant_service_category_translations.language_id = 1
        \n        JOIN images ON images.id = users.image_id
        \n        JOIN oauth_clients ON oauth_clients.id = oauth_access_tokens.client_id
        \n    WHERE oauth_access_tokens.id = :JTI AND oauth_clients.revoked = 0 AND users.status = 1;`,

        SQL_GET_USER_BY_USER_ID: `
        \n    SELECT            
        \n    users.role AS user_type_id,
        \n    users.consultant_category_id AS consultant_id,
        \n    CASE WHEN (users.nickname IS NOT NULL AND users.role != 3) THEN users.nickname 
        \n      WHEN (users.role = 3) THEN emergency_services.title
        \n    ELSE CONCAT(users.first_name, ' ', users.last_name) END AS name, 
        \n    CASE WHEN users.role = 0 THEN :STN_0 
        \n        WHEN users.role = 1 THEN :STN_1 
        \n        WHEN users.role = 2 THEN :STN_2 
        \n        WHEN users.role = 3 THEN (emergency_service_category_translations.translation)
        \n        WHEN users.role = 4 THEN (profession_consultant_service_category_translations.translation) 
        \n    ELSE :STN_5 END AS user_type,
        \n    users.id as user_id,
        \n        images.url AS image_path,
        \n        users.location,
        \n        users.email,
        \n        users.phone,
        \n        users.role, 
        \n        users.birthday 
        \n    FROM users
        \n        LEFT JOIN emergency_services ON users.service_id = emergency_services.id
        \n        LEFT JOIN emergency_service_category_translations ON emergency_services.emergency_service_category_id = emergency_service_category_translations.emergency_service_category_id AND emergency_service_category_translations.language_id = 1
        \n        LEFT JOIN profession_consultant_service_category_translations ON users.consultant_category_id = profession_consultant_service_category_translations.profession_consultant_service_category_id AND profession_consultant_service_category_translations.language_id = 1
        \n        JOIN images ON images.id = users.image_id
        \n    WHERE users.id = :JTI AND users.status = 1;`,

        getJTI: function (access_token) {
            try {
                let access_token_split = access_token.split('.');
                if (access_token_split[0] && access_token_split[1]) {
                    let obj1 = JSON.parse(Buffer.from(access_token_split[0], 'base64').toString('ascii')); // jti
                    let obj2 = JSON.parse(Buffer.from(access_token_split[1], 'base64').toString('ascii')); // jti
                    if (typeof obj1['jti'] === 'string' && typeof obj2['jti'] == 'string') {
                        if (obj1['jti'] === obj2['jti']) {
                            return obj1['jti'];
                        }
                    }
                }
            } catch (error) {
            }
            return false;
        },

        disconnect: function (data = {}) {
            try {
                socket.disconnect();
                return console.log('(%s) [Info] Unauthorized user "%s@%s" disconnected. (%s)',
                    dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                    socket.request.connection.remoteAddress, socket.name ? socket.name : 'Anonymous', data);
            } catch (error) {
            }
        },

        login: function (key, next) {
            let jti = this.getJTI(key);
            console.log(jti);
            if (jti !== false) {
                let params = {
                    "STN_0": cfg['SQL_PARAMS.SERVICES_TYPES']['0']['name'],
                    "STN_1": cfg['SQL_PARAMS.SERVICES_TYPES']['1']['name'],
                    "STN_2": cfg['SQL_PARAMS.SERVICES_TYPES']['2']['name'],
                    "STN_3": cfg['SQL_PARAMS.SERVICES_TYPES']['3']['name'],
                    "STN_4": cfg['SQL_PARAMS.SERVICES_TYPES']['4']['name'],
                    "STN_5": cfg['SQL_PARAMS.SERVICES_TYPES']['5']['name'],
                    "JTI": jti
                };
                mysql.query(this.SQL_GET_USER_BY_JTI_ID, params, (err, result, fields) => {
                    if (err) {
                        return this.disconnect({error: err});
                    } else {
                        try {
                            if (result.length) {
                                helper.setUserInfoInSocket(socket, result[0]);

                                socket['authorized'] = true;
                                socket['current_room'] = false;
                                socket['comments_rows'] = 10;
                                socket['comments_page'] = 0;
                                socket['forums_rows'] = 10;
                                socket['forums_page'] = 0;

                                return next();
                            }
                            return this.disconnect({error: 'user error'});
                        } catch (error) {
                            return this.disconnect({error: error});
                        }
                    }
                });
            } else {
                return this.disconnect({error: 'access_token error'});
            }
        }
    };
};
