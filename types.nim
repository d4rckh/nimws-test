import ws, asyncnet

type 
    Server* = ref object
        wsConnections*: seq[WebSocket]
        clients*: seq[Client]

    Client* = ref object
        id*: int
        socket*: AsyncSocket
        server*: Server
