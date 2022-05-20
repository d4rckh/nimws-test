import asyncdispatch, asyncfutures

import types

import wsServer
import tcpServer

let server = Server()

asyncCheck createNewTcpListener(server)

asyncCheck startHttpAPI(server)
