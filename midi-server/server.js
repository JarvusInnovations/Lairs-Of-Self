var sys = require("sys"),
	my_http = require("http"),
	url = require("url"),
	midi = require('midi'),
	midiOut = new midi.output();

try {
	midiOut.openPort(0);
} catch (error) {
	sys.puts("Error on open MIDI port!");
}

my_http.createServer(function(req, response) {
	var pathname = url.parse(req.url).pathname,
		pathParts,
		value;

	sys.puts("Request Path: " + pathname);
	sys.puts("Request Method: " + req.method);

	if (pathname.indexOf('midi') >= 0 && req.method == 'POST') {
		sys.puts("I got a midi request");

		pathParts = pathname.split('/');

		if (pathParts.length > 0) {
			value = pathParts[pathParts.length - 1];
			sys.puts('Value: ' + value);
			midiOut.sendMessage([144, value, 100]);
		}

		response.writeHeader(200, {
			"Content-Type": "text/plain"
		});
		response.end();
	} else {
		sys.puts("I got kicked");
		response.writeHeader(200, {
			"Content-Type": "text/plain"
		});
		response.write("Hello World");
		response.end();
	}
}).listen(8080);

process.on("SIGTERM", function() {
	midiOut.closePort();
});

sys.puts("Server Running on 8080");