// Generated by CoffeeScript 1.3.3
(function() {
  var CONF, app, cluster, express, hbs, less, pub_dir, util, _;

  util = require("util");

  cluster = require("cluster");

  express = require("express");

  app = express();

  _ = require("underscore");

  CONF = require("config");

  less = require("less");

  hbs = require("hbs");

  pub_dir = CONF.app.pub_dir;

  if (pub_dir[0] !== "/") {
    pub_dir = "/" + pub_dir;
  }

  pub_dir = __dirname + pub_dir;

  /*
  All environments
  */


  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "handlebars");
    app.engine("handlebars", hbs.__express);
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.query());
    app.use(express.cookieParser(CONF.app.cookie_secret));
    app.use(express.session());
    app.use(app.router);
    if ((typeof process.env["NODE_SERVE_STATIC"] !== "undefined") && process.env["NODE_SERVE_STATIC"] === 1) {
      app.use(require("less-middleware")({
        src: pub_dir
      }));
      app.use(express["static"](pub_dir));
      app.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
      }));
    }
    return app.use(function(err, req, res, next) {
      console.error(err.stack);
      return res.send(500, "An unexpected error occurred! Please check logs.");
    });
  });

  app.use(require("./lib/hello"));

  app.use(require("./lib/routes"));

  app.listen(CONF.app.port);

  util.log("Express server instance listening on port " + CONF.app.port);

}).call(this);
