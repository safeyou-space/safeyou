const fs = require('fs');

module.exports = function (io, socket) {
    if (socket['authorized'] === true) {
        for (const key in cfg['APP.EVENTS']) {
            if (cfg['APP.EVENTS'].hasOwnProperty(key)) {
                let event = cfg['APP.EVENTS'][key];

                const eventFullPath = __root + '/app/events/' + event['eventFileName'] + '.js';
                if (fs.existsSync(eventFullPath)) {
                    const eventFile = require('../app/events/' + event['eventFileName']);
                    if (event.type === 'recvfrom') {
                        socket.on(cfg['APP.NAME'] + '#' + event.name, function (params) {
                            if (typeof params !== 'object') {
                                params = {};
                            }
                            params['event_name_result'] = cfg['APP.NAME'] + '#' + event['resultName'];
                            eventFile[event['eventMethodName']](io, socket, params, function (json) {
                                socket.emit(cfg['APP.NAME'] + '#' + event['resultName'], json);
                                try {
                                    console.log('(%s) [Info] Event is sent "%s" / "%s" for user "%s@%s" (ContentLength: %s).',
                                        dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                                        cfg['APP.NAME'] + '#' + event.name, cfg['APP.NAME'] + '#' +
                                        event['resultName'], socket.request.connection.remoteAddress, socket.name, JSON.stringify(json).length);
                                } catch (error) {
                                }
                            });
                        });
                        console.log('(%s) [Info] Created event "%s" / "%s" for user "%s@%s".',
                            dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                            cfg['APP.NAME'] + '#' + event.name, cfg['APP.NAME'] + '#' +
                            event['resultName'], socket.request.connection.remoteAddress, socket.name);
                    } else if (event.type === 'sendto') {
                        eventFile[event['eventMethodName']](io, socket, function (json) {
                            socket.emit(cfg['APP.NAME'] + '#' + event.name, json);
                        });
                        console.log('(%s) [Info] Event "%s" sent to user "%s@%s".',
                            dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
                            cfg['APP.NAME'] + '#' + event.name, socket.request.connection.remoteAddress, socket.name);
                    }
                } else {
                    console.error('(%s) [Error] Event file (%s) not found.', dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'), eventFullPath);
                }
            }
        }
    } else {
        socket.disconnect({error: 'authorization error'});
        return console.log('(%s) [Info] Unauthorized user "%s@%s" disconnected.', dateFormat(new Date(), 'yyyy-mm-dd HH:MM:ss'),
            socket.request.connection.remoteAddress, socket.name);
    }
};