const fs = require('fs');
const auth = require('./routesAuth')

module.exports = function (app, io) {
    cfg['APP.ROUTES'].forEach(route => {
        const controllerFullPath = __root + '/app/controllers/' + route['controllerFileName'] + '.js';
        if (fs.existsSync(controllerFullPath)) {
            const controller = require('../app/controllers/' + route['controllerFileName']);
            let c = async function (req, res) {
                try {
                    await controller[route['controllerMethodName']](app, req, res, io);
                } catch (error) {
                    console.error('(%s) [Error in controller] - %s (Stack: %s)', dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                        error.message, error.stack);
                    if (cfg['APP.DEBUG'] === true) {
                        res.setHeader("Content-Type", "text/txt; charset=utf-8");
                        res.status(500).send(`Debug: true\n\nError stack: ${error.stack}`);
                    } else {
                        res.status(500).send({Message: cfg['APP.MESSAGES_LABELS']['server_error']});
                    }
                }
            };
            if (route.auth === true) {
                app[route.method](route.uri, auth, c);
            } else {
                app[route.method](route.uri, c);
            }
            console.log('(%s) [Info] Created route: %s - http://%s:%s%s',
                dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                route.method.toUpperCase(), cfg['APP.HOST'], cfg['APP.PORT'], route.uri);
        } else {
            console.error('(%s) [Error] Controller file (%s) not found.',
                dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'), controllerFullPath);
        }
    });
    return app;
};
