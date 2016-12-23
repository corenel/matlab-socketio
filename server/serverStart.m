host='localhost';
port=5000;
s = server(host, port);
s.receive();
s.send('This is MatLab');
s.send('This is MatLab');
