fs = require "fs"

express = require "express"
app = express()
gulp = require "./gulpfile"
sequence = require "run-sequence"
path = require 'path'

Bell = new (require "./Bell")
Bell.getFileList()

console.log Bell.fileList

static_base_path = path.join __dirname, 'www'
app.use express.static static_base_path

sequence "build", ->

app.get "/start", (req, res)->
  console.log Bell.getFile(0)
  Bell.play Bell.getFile(0)
  res.json
    status: 1
    result: "success"

app.get "/stop", (req, res)->
  Bell.stop()
  res.json
    status: 1
    result: "success"

app.get "/list", (req, res)->
  Bell.getFileList (fileList)->
    res.json fileList

app.get "*", (req, res)->
  res.sendfile path.join static_base_path, "index.html"
  return
server = app.listen 1451, ->
  console.log server.address()
