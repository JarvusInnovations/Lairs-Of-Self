var util = require('util'),
    http = require('http'),
    path = require('path'),
    os = require('os'),
    fs = require('fs'),
    moment = require('moment'),
    Busboy = require('busboy'),
    restler = require('restler'),
    static = require('node-static'),
    gm = require('gm');

var submissions = [],
    staticServer = new static.Server('./public'),
    kioskId = process.argv[2],
    midiIp = process.argv[3];

// check command line args
if (!kioskId) {
    throw "kioskId required";
}

if (!midiIp) {
    throw "midiIp required";
}

var app = require('http').createServer(function (req, res) {
    var timestamp = moment().format('YYYY-MM-DD HH.mm.ss');

    console.log('\n' + timestamp + '\t' + req.method + ' ' + req.url);

    // Handle submit request
    if (req.url == '/submit' && req.method == 'POST') {
        console.log('\treceiving photo submission');

        // use busyboy to parse incoming form and populate formData
        var busboy = new Busboy({ headers: req.headers }),
            submission = {
                filenameOrig: timestamp + '.orig.jpg',
                filenameRotated: timestamp + '.rotated.jpg',
                kioskId: kioskId
            },
            pathOrig = './public/photos/' + submission.filenameOrig,
            pathRotated = './public/photos/' + submission.filenameRotated,
            photoBytes;

        // setup busyboy events
        busboy.on('file', function(fieldName, file, filename, encoding, mimetype) {
            if (fieldName == 'photo') {
                file.pipe(fs.createWriteStream(pathOrig));
                console.log('\tsaved file ' + filename + ' to ' + pathOrig);
            }
        });

        busboy.on('field', function(fieldName, fieldValue) {
            if (fieldName == 'mask') {
                submission.mask = parseInt(fieldValue);
                console.log('\tattached field ' + fieldName + '=' + fieldValue);
            }
        });

        busboy.on('finish', function() {

            _postMidi((kioskId - 1) * 11 + submission.mask);

            // upload submission to web server
            console.log('\tbeginning upload to web server');

            setTimeout(function() { // i don't know what this timeout is needed for but without it the post seems to be incomplete occasionally -- probably because the .pipe() call above isn't finished

                gm(pathOrig).autoOrient().write(pathRotated, function(err) {
                    fs.stat(pathRotated, function(err, photoStats) {
                        photoBytes = photoStats.size;
                        console.log('\tfile size: ' + photoBytes);

                        restler.post('http://lairs-of-self.sandbox01.jarv.us/submissions?include=Password,validationErrors', {
                            headers: {
                                'Accept': 'application/json'
                            },
                            multipart: true,
                            data: {
                                kioskId: kioskId,
                                mask: submission.mask,
                                photo: restler.file(pathRotated, submission.filenameRotated, photoBytes, null, 'image/jpeg')
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

                            req.resume();

                            // TODO: save to submissions array
                            io.emit('submission', submission);

                            submissions.unshift(submission);
                        }); // end of restler.complete handler

                    }); // end of fs.stat callback

                }); // end of autoOrient

            }, 500); // end of timeout

        }); // end of busboy finish handler

        // pipe request into busyboy
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

        _postMidi(kioskId * 11);

        req.resume();

    // Handle unrecognized request
    } else {
        console.log('\trequest not recognized, passing to static server');

        req.addListener('end', function() {
            staticServer.serve(req, res);
        }).resume();
/*
        res.writeHead(404, {
            'Connection': 'close',
            'Content-Type': 'application/json'
        });

        res.end(JSON.stringify({
            success: false,
            message: 'request not recognized'
        }));
*/
    }
});


var io = require('socket.io')(app);

io.on('connection', function (socket) {
    if (submissions.length) {
        socket.emit('submission', submissions[0]);
    }
});

app.listen(8080);
console.log('\nLairs of Self mac-server is now listening on port 8080, kioskId='+kioskId+'\n');


function _postMidi(signal) {
    restler.post('http://'+midiIp+'/midi/'+signal);
    console.log('POSTed signal '+signal+' to MIDI server');
}
