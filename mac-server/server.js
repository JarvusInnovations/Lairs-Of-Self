var http = require('http'),
    path = require('path'),
    os = require('os'),
    fs = require('fs'),
    moment = require('moment'),
    Busboy = require('busboy');

var app = require('http').createServer(function (req, res) {
    console.log('\n' + moment().format('YYYY-MM-DD HH:mm:ss') + '\t' + req.method + ' ' + req.url);

    // Handle submit request
    if (req.url == '/submit' && req.method == 'POST') {
        var busboy = new Busboy({ headers: req.headers });

        busboy.on('file', function(fieldname, file, filename, encoding, mimetype) {      
            var saveTo = path.join(os.tmpDir(), path.basename(fieldname));
            file.pipe(fs.createWriteStream(saveTo));
            console.log('\tsaved photo: ' + saveTo);
        });

        busboy.on('finish', function() {
            res.writeHead(200, {
                'Connection': 'close',
                'Content-Type': 'application/json'
            });

            res.end(JSON.stringify({
                success: true,
                password: 'Spill'
            }));

            // TODO: post station+mask signal to MIDI
            console.log('\tsent submission signal over MIDI');

            // TODO: post submission to emergence-server
            console.log('\tposted submission to emergence-server');
        });

        req.pipe(busboy);

    // Handle omit request
    } else if (req.url == '/omit' && req.method == 'POST') {
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end();

        // TODO: post omit signal to MIDI
        console.log('\tsent omission signal over MIDI');

    // Handle unrecognized request
    } else {
        console.log('\trequest not recognized');

        res.writeHead(404, {'Content-Type': 'text/plain'});
        res.end("request not recognized");
    }
});

app.listen(8080);
console.log('\nLairs of Self mac-server is now listening on port 8080\n');