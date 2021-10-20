# README file

This is the README file for the test branch. This branch is not up to date with the main branch.

Merge request will not be sent as this is just a test branch.

- [X] Checkbox 100
- [X] Checkbox 99
- [X] Checkbox 2
- [ ] Checkbox 1

		Some comment here

<img src="https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.newdesignfile.com%2Fpostpic%2F2014%2F09%2Fcomputer-programming-code-icon_334977.png&f=1&nofb=1" width="150">

```js

// some javascript Server side code

const net = require("net");

const port = 3000;			// a registered port not in use

console.clear();

const server = net.createServer();

server.on("connection", ()=>{
	console.log(`New client connected`);
});

server.listen(port, ()=>{
	console.log(`Listening on port ${port}`);
});


// Client side

const net = require(`net`);
const port = 3000;
const host = "localhost";		// local host 127.0.0.1

const socket = net.createConnection({host, port});

socket.on("connect", ()=>{
	console.log("Connertion with server established");
});


```