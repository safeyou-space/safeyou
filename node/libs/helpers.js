module.exports = {
    getClientByUserID: function (io, user_id) {
        let sockets = [];
        for (const socketId in io.sockets.connected) {
            if (io.sockets.connected.hasOwnProperty(socketId)) {
                if (io.sockets.connected[socketId]['user_id'] === user_id) {
                    sockets.push(io.sockets.connected[socketId]);
                }
            }
        }
        return sockets;
    },

    getClientsInRooms: function (io, forum_id) {
        let sockets = [];
        for (const socketId in io.sockets.connected) {
            if (io.sockets.connected.hasOwnProperty(socketId)) {
                if (io.sockets.connected[socketId]['current_room'] === ('FORUM#' + forum_id)) {
                    sockets.push(io.sockets.connected[socketId]);
                }
            }
        }
        return sockets;
    },

    getClientsNotInRooms: function (io) {
        let sockets = [];
        for (const socketId in io.sockets.connected) {
            if (io.sockets.connected.hasOwnProperty(socketId)) {
                if (io.sockets.connected[socketId]['current_room'] === false) {
                    sockets.push(io.sockets.connected[socketId]);
                }
            }
        }
        return sockets;
    },

    getConnectedClients: function (io) {
        let sockets = [];
        for (const socketId in io.sockets.connected) {
            if (io.sockets.connected.hasOwnProperty(socketId)) {
                sockets.push(io.sockets.connected[socketId]);
            }
        }
        return sockets;
    },

    setUserInfoInSocket: function (socket, data) {
        if (data['device_type'])
            socket['device_type'] = data['device_type'];
        if (data['name'])
            socket['name'] = data['name'];
        if (data['user_type'])
            socket['user_type'] = data['user_type'];
        if (data['image_path'])
            socket['image_path'] = data['image_path'];
        if (data['location'])
            socket['location'] = data['location'];
        if (data['email'])
            socket['email'] = data['email'];
        if (data['phone'])
            socket['phone'] = data['phone'];
        if (data['birthday'])
            socket['birthday'] = dateFormat(data['birthday'], 'yyyy-mm-dd');
        if (data['role'])
            socket['role'] = Number(data['role']);
        if (data['user_id'])
            socket['user_id'] = data['user_id'];
        if (data['user_type_id'])
            socket['user_type_id'] = data['user_type_id'];
        if (data['consultant_id'])
            socket['consultant_id'] = data['consultant_id'];
    },

    getArgs: function (argv) {
        let temp = {};
        for (const arg of argv) {
            if (arg.startsWith("-")) {
                const key = arg.replace('-', '').split('=')[0];
                temp[key] = arg.split('=')[1];
            }
        }
        return temp;
    }
};
