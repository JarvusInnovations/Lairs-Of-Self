var http = require('http'),
    path = require('path'),
    os = require('os'),
    fs = require('fs'),
    moment = require('moment'),
    Busboy = require('busboy');

var app = require('http').createServer(function (req, res) {
    var userData;

    console.log(moment().format('YYYY-MM-DD HH:mm:ss') + '\t' + req.method + ' ' + req.url);

    // Handle mask ID request
    if (req.url == '/maskID' && req.method == 'POST') {
        var body = '';

        req.on('data', function(data) {
          body += data;
        });

        req.on('end', function() {
            userData = JSON.parse(body);
            console.log(userData);

            // Send word to display back to user
            res.writeHead(200, { 'Content-Type': 'text/plain'});
            res.write('Spill');
            res.end();
        });

    // Handle OMIT request
    } else if (req.url == '/omitUser' && req.method == 'POST') {
        console.log('User has just omitted...');

        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end();

    // Handle file upload request
    } else if (req.method == 'POST') {
        var busboy = new Busboy({ headers: req.headers });

        busboy.on('file', function(fieldname, file, filename, encoding, mimetype) {      
            var saveTo = path.join(os.tmpDir(), path.basename(fieldname));
            file.pipe(fs.createWriteStream(saveTo));
            console.log('Image Uploaded Here: ' + saveTo);
        });

        busboy.on('finish', function() {
            res.writeHead(200, { 'Connection': 'close' });
            res.end("That's all folks!");
        });
        return req.pipe(busboy);

        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end();

    // Handle unrecognized request
    } else {
        res.writeHead(404, {'Content-Type': 'text/plain'});
        res.end("Request not recognized");
    }
});

app.listen(8080);
console.log('Lairs of Self mac-server is now listening on port 8080');