var express = require('express');
var path = require('path');
var hbs = require('hbs');
var fs = require('fs');
var favicon = require('serve-favicon');
var bunyan = require('bunyan');
var log = bunyan.createLogger({ 
                name: '64sts',
                streams: [
                    {
                        level: 'info',
                        path: './64sts.log'
                    }
                ]
            });

var app = module.exports = express();

app.set('view engine', 'html');
app.engine('html', require('hbs').__express);

hbs.registerPartial('ga', fs.readFileSync(__dirname + '/views/ga.html', 'utf8'));

app.use(favicon(__dirname + '/public/img/favicon.ico'));
app.use(express.static(path.join(__dirname + '/public')));


app.get('/', function (req, res) {
  res.render(__dirname + '/views/index.html');
});

app.get('/save', function(req, res){
  log.info(req.query);
  res.send(200)
})

app.get('/pattern', function (req, res) {
  res.render(__dirname + '/views/pattern.html');
});


app.use(notfound);
app.listen(process.env.PORT || 5050);
console.log('listening on port 5050');


function notfound (req, res, next){
  res.status(404);
  // respond with html page
  if (req.accepts('html')) return res.render('404');

  // respond with json
  if (req.accepts('json')) return res.send({ error: 'Not found' });

  // default to plain-text. send()
  return res.type('txt').send('Page Not found');
}