var app, bodyParser, express, fs, listener;

fs = require("fs");

express = require("express");

app = express();

// Accept JSON as req.body
bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(bodyParser.json());

// CORS - Allow pages from any domain to make requests to our API
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  return next();
});

// Log all requests for diagnostics
app.use(function(req, res, next) {
  console.log(req.method, req.path, req.body);
  return next();
});


// Serve Static files from public/
app.use(express.static('public'));

(require('./torrent-store'))(app);

// Listen on App port
listener = app.listen(process.env.PORT || 3001, function() {
  return console.log('Your app is listening on port ' + listener.address().port);
});
