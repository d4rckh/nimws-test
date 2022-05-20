import net, os

var client: Socket = newSocket()

const port {.intdefine.}: int = 12345
const autoConnectTime {.intdefine.}: int = 5000
const ip {.strdefine.}: string = "127.0.0.1"

proc receiveCommands(client: Socket) =
  while true:
    let line = client.recvLine()

    if line.len == 0:
      client.close()
      break

while true:
  try:
    client.connect(ip, Port(port))
  except OSError:
    sleep(autoConnectTime)
    continue
  receiveCommands(client)
  client = newSocket()
  sleep(autoConnectTime)