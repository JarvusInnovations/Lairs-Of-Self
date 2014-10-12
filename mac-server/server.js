var http = require('http'),
    path = require('path'),
    os = require('os'),
    fs = require('fs'),
    Busboy = require('busboy'),
    userData;

var app = require('http').createServer(function (req, res) {
    console.log('received '+req.method+' request:');
    
    // Handle Mask ID Request
    if (req.url == '/maskID') {
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
        
    } else if (req.url == '/omitUser') {
        console.log('User has just omitted...');
    
         res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end();

    // Process File Upload
    } else if (req.method == 'POST') {
        var busboy = new Busboy({ headers: req.headers });
        
        busboy.on('file', function(fieldname, file, filename, encoding, mimetype) {      
            var localPath = path.join('/var/Users/Tyler/Development/imgs/', path.basename(fieldname));
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
    }
});

app.listen(8080);
console.log('Hello node :)');