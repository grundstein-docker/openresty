lapis = require "lapis"

require "../utils"

import validate_functions, assert_valid from require "lapis.validate"

validate_functions.is_emailish = (input) ->
  strfind input "@" != nil

import capture_errors from require "lapis.application"
csrf = require "lapis.csrf"

class extends lapis.Application
  "/user/signup": =>
    csrf.assert_token @

    assert_valid @params, {
      { "email", exists: true, is_emailish: true }
      { "js", exists: true, min: 0, max: 1 }
    }

    if @params.js == "0"
      return redirect_to: "/"

    --print u.http_request {endpoint: "http://crack.plumbing"}

    status: 200, json: {status: "OK"}
