# Define third-party libraries
util = require("util")
cluster = require("cluster")
express = require("express")
app = express()
_ = require("underscore")
CONF = require("config")
less = require("less")
hbs = require("hbs")
pub_dir = CONF.app.pub_dir
pub_dir = "/" + pub_dir  unless pub_dir[0] is "/" # humans are forgetful
pub_dir = __dirname + pub_dir

###
All environments
###
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "handlebars"
  app.engine "handlebars", hbs.__express
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.query()
  app.use express.cookieParser(CONF.app.cookie_secret)
  app.use express.session()
  app.use app.router
  
  #app.use(express.responseTime());
  
  # This is not needed if you handle static files with, say, Nginx (recommended in production!)
  # Additionally you should probably precompile your LESS stylesheets in production
  # Last, but not least: Express' default error handler is very useful in dev, but probably not in prod.
  if (typeof process.env["NODE_SERVE_STATIC"] isnt "undefined") and process.env["NODE_SERVE_STATIC"] is 1
    app.use require("less-middleware")(src: pub_dir)
    app.use express.static(pub_dir)
    app.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
  
  # Catch-all error handler. Override as you see fit
  app.use (err, req, res, next) ->
    console.error err.stack
    res.send 500, "An unexpected error occurred! Please check logs."



#---- INTERNAL MODULES
app.use require("./lib/hello")
app.use require("./lib/routes")



# start app
app.listen CONF.app.port
util.log "Express server instance listening on port " + CONF.app.port