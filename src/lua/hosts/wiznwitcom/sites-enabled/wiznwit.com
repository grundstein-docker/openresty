server {
  listen 8080;
  server_name wiznwit.com wiznwit;
  lua_code_cache on;

  location /favicon.ico {
    alias assets/favicon.ico;
  }

  location ~^/(img|css|js)/ {
    root assets/;
  }

  location / {
    default_type text/html;

    content_by_lua '
      require("lapis").serve("app")
    ';
  }
}
