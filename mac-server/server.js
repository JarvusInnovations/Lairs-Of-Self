var util = require('util'),
    http = require('http'),
    path = require('path'),
    os = require('os'),
    fs = require('fs'),
    moment = require('moment'),
    tmp = require('tmp'),
    Busboy = require('busboy'),
    restler = require('restler');

var app = require('http').createServer(function (req, res) {
    console.log('\n' + moment().format('YYYY-MM-DD HH:mm:ss') + '\t' + req.method + ' ' + req.url);

    // Handle submit request
    if (req.url == '/submit' && req.method == 'POST') {
        console.log('\treceiving photo submission');

        // create temporary file to recieve photo into
        tmp.tmpName(function(err, tempPath) {
            console.log('\tobtained temporary file path: ' + tempPath);

            // use busyboy to parse incoming form and populate formData
            var busboy = new Busboy({ headers: req.headers }),
                photoFilename, photoPath, mask;

            // setup busyboy events
            busboy.on('file', function(fieldName, file, filename, encoding, mimetype) {
                if (fieldName == 'photo') {
                    file.pipe(fs.createWriteStream(tempPath));
                    console.log('\tsaved file ' + filename + ' to ' + tempPath);

                    photoFilename = filename;
                    photoPath = tempPath;
                }
            });

            busboy.on('field', function(fieldName, fieldValue) {
                if (fieldName == 'mask') {
                    mask = fieldValue;
                    console.log('\tattached field ' + fieldName + '=' + fieldValue);
                }
            });

            busboy.on('finish', function() {
                // TODO: post station+mask signal to MIDI
                console.log('\tsent submission signal over MIDI');

                // upload submission to web server
                console.log('\tbeginning upload to web server');

                fs.stat(photoPath, function(err, photoStats) {

                    restler.post('http://lairs-of-self.sandbox01.jarv.us/submissions?include=Password,validationErrors', {
                        headers: {
                            'Accept': 'application/json'
                        },
                        multipart: true,
                        data: {
                            mask: mask,
                            photo: restler.file(photoPath, photoFilename, photoStats.size, null, 'image/jpeg')
                        }
                    }).on('complete', function(webResponseData, webResponse) {
                        console.log('\tfinished uploading submission to emergence-server, status=' + webResponse.statusCode);

                        if (webResponse.statusCode != 200 || typeof webResponseData != 'object') {
                            console.log('\tsubmission failed:\n' + util.inspect(webResponseData)+'\n\n');
                            res.writeHead(500);
                            res.end(JSON.stringify({
                                success: false
                            }));
                            return;
                        }

                        console.log('\twebResponseData: ' + util.inspect(webResponseData));

                        res.writeHead(200, {
                            'Connection': 'close',
                            'Content-Type': 'application/json'
                        });

                        res.end(JSON.stringify({
                            success: webResponseData.success,
                            password: webResponseData.data && webResponseData.data.Password && webResponseData.data.Password.Password
                        }));
                    });

                });
            });

            // pipe request into busyboy
            req.pipe(busboy);
        });

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