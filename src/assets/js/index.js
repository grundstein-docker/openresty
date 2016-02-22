'use strict';

function convertParams(params) {

  var paramArray = [];
  for (var key in params) {
    if (params.hasOwnProperty(key)) {
      paramArray.push(key + '=' + params[key]);
    }
  }

  return paramArray.join('&');
}

function httpPOST(url, params, cb) {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
      cb(JSON.parse(request.responseText).status);
    }
  }

  request.open( 'POST', url, true );

  request.send( convertParams(params) );
  return false;
}

function catchForm() {
  var form = document.getElementById('signup-form');
  if (!form || !form.action) { return; }

  form.addEventListener('submit', function(evt) {
    evt = evt || event;

    var formParams = {
      js: 1,
      email: form.elements.email.value,
      csrf_token: form.elements.csrf_token.value
    };

    httpPOST(form.action, formParams, function(status) {
      if (status === 'OK') {
        console.log(status);
      } else {
        console.log("errored", status);
      }
    });

    evt.preventDefault();
    return false;
  });
}

catchForm();
