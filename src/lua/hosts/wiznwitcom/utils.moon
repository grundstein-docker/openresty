module "u", package.seeall

http = require("socket.http")
ltn12 = require("ltn12")

deep_print = (tbl) ->
  for i, v in *tbl
    if type v == "table"
      deep_print v
    else
      print i, v

http_request = (args) ->
  --http.request(url [, body])
  --http.request{
  --  url = string,
  --  [sink = LTN12 sink,]
  --  [method = string,]
  --  [headers = header-table,]
  --  [source = LTN12 source],
  --  [step = LTN12 pump step,]
  --  [proxy = string,]
  --  [redirect = boolean,]
  --  [create = function]
  --}
  --

  resp = {}
  r = {}
  if args.endpoint
    params = ""
    if args.method == nil or args.method == "GET"
      if args.params
        for i, v in *args.params
          params = "#{params}#{i}=#{v}&"

    params = string.sub(params, 1, -2)

    url = if params
            "#{args.endpoint}?#{params}"
          else
            "#{args.endpoint}"

    client, code, headers, status = http.request
      :url,
      sink: ltn12.sink.table(resp),
      method: args.method or "GET",
      headers: args.headers,
      source: args.source,
      step: args.step,
      proxy: args.proxy,
      redirect: args.redirect,
      create: args.create

    r['code'], r['headers'], r['status'], r['response'] = code, headers, status, resp
  else
    error "endpoint is missing"

  print "r ${r}"
  r

cdn_host = (file) ->
  host_id = math.floor math.random! * 9 + 1

  "http://s#{host_id}.localhost:8080/#{file}"
