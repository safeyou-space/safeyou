const mysql = require('mysql');

const init = function () {
    const con = mysql.createConnection({
        host: cfg['DB.HOST'],
        port: cfg['DB.PORT'],
        user: cfg['DB.USERNAME'],
        password: cfg['DB.PASSWORD'],
        database: cfg['DB.DATABASE'],
        multipleStatements: true,
        charset: 'utf8mb4'
    });

    con.on('error', function (err) {
        console.error("(%s) [1MySQL] Connection error: ", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
        console.error("\t Host: %s:%s", cfg['DB.HOST'], cfg['DB.PORT']);
        console.error("\t %s", err.message);
        setTimeout(function () {
            init();
        }, 5000);
    });

    con.connect(function(err) {
        if (err) {
            console.error("(%s) [MySQL] Connection error: ", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
            console.error("\t Host: %s:%s", cfg['DB.HOST'], cfg['DB.PORT']);
            console.error("\t %s", err.message);
            setTimeout(function () {
                init();
            }, 5000);
            return;
        }

        con.config.queryFormat = function (query, values) {
            if (!values) return query;
            return query.replace(/:(\w+)/g, function (txt, key) {
                if (values.hasOwnProperty(key)) {
                    return this.escape(values[key]);
                }
                return txt;
            }.bind(this));
        };

        console.info("(%s) [MySQL] Successfully connected.", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
        global['mysql'] = con;
    });
};

module.exports.init = init;