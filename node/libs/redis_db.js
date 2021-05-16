const redis_client = require('redis').createClient(cfg["REDIS.PORT"], cfg["REDIS.HOST"]);

module.exports = {
    c: redis_client,

    set: function (key, expire, object) {
        for (const key in object) {
            if (object.hasOwnProperty(key)) {
                if (object[key] == null || object[key] === undefined) {
                    object[key] = 'NaN';
                }
            }
        }
        redis_client.hmset(key, object, function (err, res) {
            console.log('[Redis] set command: ', 'Key -', key, '/ Value -', object, '/ Error - ', err, '/ Result - ', res);
        });
        if (expire)
            redis_client.expire(key, expire);
    },

    get: function (pattern, callback) {
        redis_client.keys(pattern, function (err1, keys) {
            if (err1) callback(err1, null);
            for (const key of keys) {
                redis_client['hgetall'](key, function (err2, result) {
                    if (err2) callback(err2, null);
                    callback(err2, result);
                });
            }
        });
    },

    del: function (key) {
        redis_client.del(key);
    }
};