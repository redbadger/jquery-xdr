
root = this
((jQuery) ->
  if root.XDomainRequest
    jQuery.ajaxTransport (s) ->
      if s.crossDomain and s.async
        if s.timeout
          s.xdrTimeout = s.timeout
          delete s.timeout

        send: (_, complete) ->
          xdr = new XDomainRequest()
          xdr.onprogress = ->

          callback = (status, statusText, responses, responseHeaders) ->
            xdr.onload = xdr.onerror = xdr.ontimeout = jQuery.noop
            complete status, statusText, responses, responseHeaders

          if s.dataType
            headerThroughUriParameters = "header_Accept=" + encodeURIComponent(s.dataType)
            s.url = s.url + ((if s.url.indexOf("?") is -1 then "?" else "&")) + headerThroughUriParameters

          xdr.open s.type, s.url
          xdr.onload = (e1, e2) ->
            callback 200, "OK",
              text: xdr.responseText
            , "Content-Type: " + xdr.contentType

          xdr.onerror = (e) ->
            callback 404, "Not Found"

          if s.xdrTimeout
            xdr.ontimeout = ->
              callback 0, "timeout"
            xdr.timeout = s.xdrTimeout

          s.contentType = "text/plain"
          xdr.send (s.hasContent and s.data) or null

        abort: ->
          if xdr
            xdr.onerror = jQuery.noop()
            xdr.abort()

) jQuery
