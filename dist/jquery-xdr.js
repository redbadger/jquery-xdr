
/*!
 * jquery-xdr - jQuery XDR shim, mainly for IE.
 * v0.1.0
 * 
 * copyright Jon Sharratt 2013
 * MIT License
*/
(function() {
  var root;

  root = this;

  (function(jQuery) {
    if (root.XDomainRequest) {
      return jQuery.ajaxTransport(function(s) {
        if (s.crossDomain && s.async) {
          if (s.timeout) {
            s.xdrTimeout = s.timeout;
            delete s.timeout;
          }
          return {
            send: function(_, complete) {
              var callback, headerThroughUriParameters, xdr;
              xdr = new XDomainRequest();
              xdr.onprogress = function() {};
              callback = function(status, statusText, responses, responseHeaders) {
                xdr.onload = xdr.onerror = xdr.ontimeout = jQuery.noop;
                return complete(status, statusText, responses, responseHeaders);
              };
              if (s.dataType) {
                headerThroughUriParameters = "header_Accept=" + encodeURIComponent(s.dataType);
                s.url = s.url + (s.url.indexOf("?") === -1 ? "?" : "&") + headerThroughUriParameters;
              }
              xdr.open(s.type, s.url);
              xdr.onload = function(e1, e2) {
                return callback(200, "OK", {
                  text: xdr.responseText
                }, "Content-Type: " + xdr.contentType);
              };
              xdr.onerror = function(e) {
                return callback(404, "Not Found");
              };
              if (s.xdrTimeout) {
                xdr.ontimeout = function() {
                  return callback(0, "timeout");
                };
                xdr.timeout = s.xdrTimeout;
              }
              s.contentType = "text/plain";
              return xdr.send((s.hasContent && s.data) || null);
            },
            abort: function() {
              if (xdr) {
                xdr.onerror = jQuery.noop();
                return xdr.abort();
              }
            }
          };
        }
      });
    }
  })(jQuery);

}).call(this);
