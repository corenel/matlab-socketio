let socket = require('socket.io-client')('http://localhost:1234/matlab');
let Client = require('./server/Client')

socket.on('connect', function () {
    console.log('Connected to socket.io server')
    Client.prototype.receive = function () {
        var that = this
        this.socket.on('data', function (data) {
            data = data.toString('utf8')
            that.queue.push(data)
            console.log('[Matlab] ' + data)
            if (data !== '') {
                that.message = data
            }
            socket.emit('fromMatlab', data)
        })
    }
    let c = new Client('localhost', 5000)
    c.receive()

    socket.on('toMatlab', function (data) {
        console.log('[Web Server] ' + data)
        c.send(data)
    });
})
