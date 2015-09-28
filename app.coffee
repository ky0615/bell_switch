fs = require "fs"

path = require 'path'

express = require "express"
app = express()
bodyParser = require "body-parser"
app.use bodyParser()

Bell = new (require "./Bell")
Bell.getFileList (files)->
  # console.log files

static_base_path = path.join __dirname, 'www'
app.use express.static static_base_path


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

if /^arm/.test process.arch
  pin = 7
  console.log "enable the raspberry pi's gpio"
  console.log "read pin is " + pin
  gpio = require "rpi-gpio"
  gpio.setup pin, gpio.DIR_IN, ->
    gpio.read pin, (err, value)->
      console.log "value is " + value
else
  console.log "This compuer is not Raspberry pi"
