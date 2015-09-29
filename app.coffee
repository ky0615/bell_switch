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

lastValue = 0
nowValue = 0

if /^arm/.test process.arch
  pin = 21
  console.log "enable the raspberry pi's gpio"
  console.log "read pin is " + pin
  gpio = require("onoff").Gpio
  button = new gpio pin, 'in', 'both'
  button.watch (err, value)->
    console.log err if err
    console.log "input value: " + value
    nowValue = value
    setInterval ->
      switch nowValue
        when 0
          Bell.stop()
          console.log "stop the music by gpio"
        when 1
          Bell.play Bell.getFile Bell.nowBellId
          console.log "start the music by gpio"
        else
          console.log "input the GPIO pin#{pin} parameter is out range[0,1]"
    , 200
else
  console.log "This computer is not Raspberry pi"
