
import asyncdispatch, asyncnet, asyncfutures, strutils, ws

import types

proc processMessages(server: Server, tcpSocket: AsyncSocket, client: Client) {.async.} =
  # ......
  echo "'listening'"

proc createNewTcpListener*(server: Server, port = 12345, ip = "127.0.0.1") {.async.} =
  let tcpSocket = newAsyncSocket()
  
  try:
    tcpSocket.setSockOpt(OptReuseAddr, true)
    tcpSocket.bindAddr(Port port, ip)
    tcpSocket.listen()
  except OSError:
    echo getCurrentExceptionMsg()
    return
  
  echo "listening on " & ip & ":" & $port & " using a tcp socket"
  
  while true:
    let 
      (netAddr, clientSocket) = await tcpSocket.acceptAddr()
      client = Client(
        id: len server.clients,
        socket: clientSocket
      )

    server.clients.add(client)

    for wsConnection in server.wsConnections:
      await wsConnection.send($client.id & " connected to tcp serevr")

    asyncCheck processMessages(server, clientSocket, client)