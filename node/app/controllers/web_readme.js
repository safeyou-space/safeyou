const fs = require('fs');
const Markdown = require('markdown-to-html').Markdown;
const fileName = __root + '/readme.md';

module.exports = {
    index: async function (app, req, res, io) {
        let md = new Markdown();
        md.bufmax = 2048;
        md.render(fileName, {}, function (err) {
            if (err) {
                console.log(err);
                return res.status(500).send('Error');
            }
            md['pipe'](res);
        });
        io.sockets['emit']('SafeYOU_V4##ADD_NEW_COMMENT#RESULT', { 'message': 'Hello!' });
    },

    test: async function (app, req, res) {
        let data = fs.readFileSync(__root + '/public/index2.html').toString();
        if(data) {
            res.send(data.replace('{SOCKET_HOST}', cfg['SOCKET_HOST_FOR_TEST']));
        }
    },
}; 