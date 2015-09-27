fs = require "fs"

express = require "express"
app = express()
bodyParser = require "body-parser"
app.use bodyParser()
gulp = require "./gulpfile"
sequence = require "run-sequence"
path = require 'path'

Bell = new (require "./Bell")
Bell.getFileList (files)->
  console.log files

static_base_path = path.join __dirname, 'www'
app.use express.static static_base_path

sequence "build", ->
  console.log "gulp build was successful"
  sequence "watch:assets", ->

app.get "/start", (req, res)->
  Bell.play Bell.getFile Bell.nowBellId
  res.json
    status: 1

app.get "/stop", (req, res)->
  Bell.stop()
  res.json
    status: 1

app.get "/list", (req, res)->
  Bell.getFileList (fileList)->
    res.json fileList

app.get "/status", (req, res)->
  res.json
    bell_id: Bell.nowBellId

app.post "/setbellid", (req, res)->
  unless req.body?.id
    res.json
      status: -1
      bell_id: Bell.nowBellId
    return
  Bell.nowBellId = req.body.id
  res.json
    status: 1
    result: "success"
    bell_id: Bell.nowBellId

app.get "*", (req, res)->
  res.sendfile path.join static_base_path, "index.html"
  return
server = app.listen 1451, ->
  console.log server.address()
