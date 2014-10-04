var app = require('http').createServer(function (req, res) {
    console.log('received '+req.method+' request:');
    //console.log('Request:');
    //console.log(req);
    //console.log('Res: ' . res);
    
    if (req.method == 'POST') {
        var body = '';
            req.on('data', function(data) {
                console.log(data);
                body += data;
            });
            
            req.on('end', function() {
        	    console.log( "Current Time " + Date.now() );
        	    bidData = JSON.parse(body);
        	    console.log(bidData);
            });
    }
    
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end();
});

app.listen(8080);
console.log('Hello node :)');