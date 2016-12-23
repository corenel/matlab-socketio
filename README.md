# Matlab-socket.io

A tiny bridge between Matlab and Socket.io server.

## Usage

```bash
$ npm install
$ ./server/matlabStart.sh
# Open another window
$ npm run test
```

### Matlab side

Use `localhost:5000`

```matlab
% Run server
host='localhost';
port=5000;
s = server(host, port);
% Receive messages
s.receive();
% Send messages
s.send('This is MatLab');
```

### NodeJS side

Use `localhost:1234` and `matlab` namespace 

* Receive messages from Matlab: `fromMatlab` socket event
* Send messages to Matlab: `toMatlab` socket event

