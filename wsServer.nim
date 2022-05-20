import asyncdispatch, jester, strutils, ws, ws/jester_extra, asyncnet

import types

var server: Server

proc notifyClientConnection*(client: Client) {.async.} =
  for con in client.server.wsConnections:
    if con.readyState == Open:
      echo con.readyState
      asyncCheck con.send("HE CONNECTED POG")

template json_response*(code, message: untyped): untyped =
  mixin resp
  resp code, @{"Content-Type": "application/json", "Access-Control-Allow-Origin": "*"}, message

router myrouter:
  get "/ws":
    var ws = await newWebSocket(request)
    {.cast(gcsafe).}:
      server.wsConnections.add ws
    while ws.readyState == Open:
      let packet = await ws.receiveStrPacket()
      echo packet

proc startHttpAPI*(s: Server) {.async.} =
  server = s

  let settings = newSettings(port=Port(8080))
  var jester = initJester(myrouter, settings=settings)
  jester.serve()
