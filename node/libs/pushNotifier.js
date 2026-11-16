const path = require('path');

const disabledNotifier = {
    sendMulticast: function (message) {
        const tokens = (message && message.tokens) || [];
        return Promise.resolve({successCount: 0, failureCount: 0, responses: [], skippedCount: tokens.length});
    }
};

let notifier = null;

function load() {
    const modulePath = global.cfg && global.cfg['APP.PUSH_NOTIFIER'];
    if (!modulePath) {
        return disabledNotifier;
    }
    const loaded = require(path.resolve(global.__root || process.cwd(), modulePath));
    if (!loaded || typeof loaded.sendMulticast !== 'function') {
        throw new Error('APP.PUSH_NOTIFIER must export a sendMulticast(message) function.');
    }
    return loaded;
}

module.exports = {
    sendMulticast: function (message) {
        try {
            if (!notifier) {
                notifier = load();
            }
            return Promise.resolve(notifier.sendMulticast(message));
        } catch (error) {
            return Promise.reject(error);
        }
    }
};
