fs = require "fs"

path = require 'path'

express = require "express"
app = express()
bodyParser = require "body-parser"
app.use bodyParser()

Bell = new (require "./Bell")
Bell.getFileList (files)->
  # console.log files

Announce = new (require "./Announce")
Announce.getFileList (file)->
  console.log file

static_base_path = path.join __dirname, 'www'
app.use express.static static_base_path

app.get "/status", (req, res)->
  res.json
    bell_id: Bell.nowBellId
    departure_id: Announce.nowDID
    is_departure_auto_play: Announce.autoPlay

app.get "/start", (req, res)->
  Announce.stop()
  Bell.play Bell.getFile Bell.nowBellId
  res.json
    status: 1

app.get "/stop", (req, res)->
  if Bell.stop() and Announce.autoPlay
    if /^arm/.test process.arch
      Announce.playDuration Announce.getDepartureFile Announce.nowDID
    else
      Announce.play Announce.getDepartureFile Announce.nowDID
  res.json
    status: 1

app.get "/list", (req, res)->
  Bell.getFileList (fileList)->
    res.json fileList

app.post "/setbellid", (req, res)->
  Bell.nowBellId = req.body.id
  res.json
    status: 1
    result: "success"
    bell_id: Bell.nowBellId

app.get "/departurelist", (req, res)->
  Announce.getFileList (fileList)->
    res.json Announce.departureFileList

app.post "/setdepartureid", (req, res)->
  Announce.nowDID = req.body.id
  res.json
    status: 1
    result: "success"
    bell_id: Announce.nowDID

app.post "/toggledepartureautoplay", (req, res)->
  Announce.autoPlay = req.body.id
  res.json
    status: 1
    result: "success"
    bell_id: Announce.autoPlay

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
    nowValue = value
  setInterval ->
    if nowValue is lastValue
      return
    lastValue = nowValue
    switch nowValue
      when 0
        if Bell.stop() and Announce.autoPlay
          Announce.playDuration Announce.getDepartureFile Announce.nowDID
        console.log "stop the music by gpio"
      when 1
        Bell.play Bell.getFile Bell.nowBellId
        console.log "start the music by gpio"
      else
        console.log "input the GPIO pin#{pin} parameter is out range[0,1]"
  , 200
else
  console.log "This computer is not Raspberry pi"
