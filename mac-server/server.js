var util = require('util'),
    http = require('http'),
    path = require('path'),
    os = require('os'),
    fs = require('fs'),
    moment = require('moment'),
    tmp = require('tmp'),
    Busboy = require('busboy'),
    FormData = require('form-data');

var app = require('http').createServer(function (req, res) {
    console.log('\n' + moment().format('YYYY-MM-DD HH:mm:ss') + '\t' + req.method + ' ' + req.url);

    // Handle submit request
    if (req.url == '/submit' && req.method == 'POST') {
        var busboy = new Busboy({ headers: req.headers });
            postForm = new FormData();

        busboy.on('file', function(fieldName, file, filename, encoding, mimetype) {
            tmp.tmpName(function(err, tempPath) {
                file.pipe(fs.createWriteStream(tempPath));
                console.log('\tsaved file ' + filename + ' to ' + tempPath);

                postForm.append(fieldName, fs.createReadStream(tempPath));
                console.log('\tattached file ' + fieldName + '=' + filename);
            });
        });

        busboy.on('field', function(fieldName, fieldValue) {
            postForm.append(fieldName, fieldValue);
            console.log('\tattached field ' + fieldName + '=' + fieldValue);
        });

        busboy.on('finish', function() {

            // TODO: post station+mask signal to MIDI
            console.log('\tsent submission signal over MIDI');

            // TODO: post submission to emergence-server
            postForm.submit({
                host: 'lairs-of-self.sandbox01.jarv.us',
                path: '/submissions?include=Password',
                headers: {
                    'Accept': 'application/json'
                }
            }, function(postError, postResponse) {
                if (postError) {
                    console.log('\tfailed to post submission to emergence-server: ' + util.inspect(postError));
                    return;
                }

                var body = '';
                postResponse.on('data', function(chunk) {
                    body += chunk;
                });

                postResponse.on('end', function() {
                    console.log('\tposted submission to emergence-server and got status code ' + postResponse.statusCode);

                    body = JSON.parse(body);

                    res.writeHead(200, {
                        'Connection': 'close',
                        'Content-Type': 'application/json'
                    });

                    res.end(JSON.stringify({
                        success: true,
                        password: body.data.Password.Password
                    }));
                });
            });
        });

        req.pipe(busboy);

    // Handle omit request
    } else if (req.url == '/omit' && req.method == 'POST') {
        res.writeHead(200, {
            'Connection': 'close',
            'Content-Type': 'application/json'
        });

        res.end(JSON.stringify({
            success: true
        }));

        // TODO: post omit signal to MIDI
        console.log('\tsent omission signal over MIDI');

    // Handle unrecognized request
    } else {
        console.log('\trequest not recognized');

        res.writeHead(404, {
            'Connection': 'close',
            'Content-Type': 'application/json'
        });

        res.end(JSON.stringify({
            success: false,
            message: 'request not recognized'
        }));
    }
});

app.listen(8080);
console.log('\nLairs of Self mac-server is now listening on port 8080\n');