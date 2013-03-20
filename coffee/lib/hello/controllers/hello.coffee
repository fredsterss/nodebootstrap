exports = module.exports
greeter = require("../models/greeter")

exports.sayHello = (req, res) ->
  name = req.param("name", "")
  context =
    site_title: "Node.js Bootstrap Demo Page"
    welcome_message: greeter.welcomeMessage(name)

  template = "../lib/hello/views/hello"
  res.render template, context

# More elaborate res.render() format:
#res.render(template, context, function(err, html) {
#  console.dir(err);
#  res.send(html);
#});

# Just responding with a string, without any template:
#res.send('Hello World');