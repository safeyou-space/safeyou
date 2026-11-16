const auth = require('basic-auth');

const getAuthorizer = () => (req, res, next) => {

    const user = auth(req);
    let status = false;

    for (const usrPas of cfg["APP.ROUTES_AUTH"]) {
        if (user && user.name === usrPas.username && user.pass === usrPas.password) {
            status = true;
        }
    }

    if (status === false) {
        res.status(401).send('Unauthorized');
    } else {
        next();
    }
}

module.exports = getAuthorizer();