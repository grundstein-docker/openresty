import Widget from require "lapis.html"

csrf = require "lapis.csrf"

class Index extends Widget
  content: =>
    csrf_token = csrf.generate_token @

    section id: "test", ->
      h1 "Welcome to magic"

      p "Don't panic and error on"
