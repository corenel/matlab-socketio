var net = require('net')

function Client (host, port) {
    this.queue = []
    this.socket = new net.Socket()
    this.socket.connect(port, host, function () {
        console.log('Connected')
    })
    this.queue = []
    this.message = ''
}

Client.prototype.send = function (data) {
    this.socket.write(data + '\n')
}

Client.prototype.receive = function () {
    var that = this
    this.socket.on('data', function (data) {
        data = data.toString('utf8')
        that.queue.push(data)
        console.log('[Matlab] ' + data)
        if (data !== '') {
            that.message = data
        }
    })
}

Client.prototype.disconnect = function () {
    this.socket.on('close', function () {
        console.log('Connection closed')
        this.socket.destroy()
    })
}

module.exports = Client
