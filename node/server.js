global['dateFormat'] = require('dateformat');
global['helper'] = require('./libs/helpers');
const args = helper.getArgs(process.argv.slice(2));
const fs = require('fs');

if (!args['config']) {
    return console.error("(%s) [PARAMETER_ERROR] Use: -config=./configs/configuration.json -ssl_key=/etc/ssl/private/file_name.key -ssl_crt=/etc/ssl/file_name.crt", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
}

if (!fs.existsSync(args['config'])) {
    return console.error("(%s) [PARAMETER_ERROR] -config file is not found.", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
}

if (args['ssl_key'] && !fs.existsSync(args['ssl_key'])) {
    return console.error("(%s) [PARAMETER_ERROR] -ssl_key file is not found.", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
}

if (args['ssl_crt'] && !fs.existsSync(args['ssl_crt'])) {
    return console.error("(%s) [PARAMETER_ERROR] -ssl_crt file is not found.", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
}

global['cfg'] = require(args['config']);
global['__root'] = __dirname;
global['join'] = require('path').join;
global['moment'] = require("moment");
const express = require('express');
const {urlencoded, json} = require('body-parser');
const methodOverride = require('method-override');
const hDatabase = require('./libs/databaseHandler');
const hRoutes = require('./libs/routesHandler');
const hEvents = require('./libs/eventsHandler');
const hAuthorization = require('./libs/authorizationHandler');
const app = express();
const morgan = require('morgan');
global['admin'] = require('firebase-admin');
global['redis_db'] = require('./libs/redis_db');
let http;
if (args['ssl_key'] && args['ssl_crt']) {
    http = require('https').createServer( {
        key: fs.readFileSync(args['ssl_key']),
        cert: fs.readFileSync(args['ssl_crt'])
    }, app);
} else {
    http = require('http').createServer(app);
}
const serviceAccount = require("./configs/serviceAccountKey.json");
redis_db.c.on('error', function (error) {
    return console.error("(%s) [Redis] Connection error: ",
        dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'), error['message'] ? error['message'] : error);
});
redis_db.c.on('connect', function (err) {
    if (err) {
        return console.error("(%s) [Redis] Connection error: ",
            dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'), err.message);
    }
    console.info("(%s) [Redis] Successfully connected.", dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'));
    const io = require('socket.io')(http);
    morgan.token('port', function getId(req) {
        return req.socket['_peername'].port;
    });
    app.use(morgan(':method - (UIP: :remote-addr\::port) - ":url" (Status: :status / Content-Length: :res[content-length] bytes / Response-Time: :response-time ms)'));
    app.use(json());
    app.use(urlencoded({'extended': 'true'}));
    app.use(methodOverride('X-HTTP-Method-Override'));
    app.use(express.static('./public'));
    app.use(json({type: 'application/vnd.api+json'}));
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        databaseURL: cfg['cfg.APP_FIREBASE.DB_URL']
    })
    hDatabase.init();

    hRoutes(app, io);

    io['use'](function (socket, next) {
        let auth = new hAuthorization(socket);
        if (socket.handshake.query.key) {
            auth.login(socket.handshake.query.key, next);
        } else {
            auth.disconnect({error: 'key is not defined'});
        }
    }).on('connection', function (socket) {
        console.log('(%s) [Info] User "%s@%s" connected.', dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
            socket.request.connection.remoteAddress, socket.name);
        hEvents(io, socket);
        socket.on('disconnect', function () {
            console.log('(%s) [Info] User "%s@%s" disconnected.', dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                socket.request.connection.remoteAddress, socket.name);
        });
    });

    http.listen(cfg['APP.PORT'], cfg['APP.HOST'], function () {
        console.log('(%s) [Info] The server is running at - http://%s:%s or ws://%s:%s',
            dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
            cfg['APP.HOST'], cfg['APP.PORT'], cfg['APP.HOST'], cfg['APP.PORT']);
    });
});
