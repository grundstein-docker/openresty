import Widget from require "lapis.html"

csrf = require "lapis.csrf"

class Index extends Widget
  content: =>
    csrf_token = csrf.generate_token @

    section id: "test", ->
      h1 "Welcome to magic"

      form id: "signup-form", method: "post", action: "/user/signup", ->
        fieldset ->
          ul ->
            li ->
              input type: "email", name: "email", value: "", placeholder: "Your Email here"
            li ->
              input type: "hidden", name: "csrf_token", value: csrf_token
              input type: "hidden", name: "js", value: 0, id: "signup-form-js-input"
              input type: "submit", value: "Sign up for Newsletter"
