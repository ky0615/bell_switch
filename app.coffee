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

Buzzer = new (require "./Buzzer")

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

app.get "/buzzer/:param", (req, res)->
  switch req.param("param")
    when "start"
      console.log "start buzzer. caused by API"
      Buzzer.play()
    when "stop"
      Buzzer.stop()
      console.log "stop buzzer. caused by API"

  res.json
    status: 1
    result: "success"

app.get /^\/(js|css|min)\/(.*)/, (req, res)->
  res.send "404 Not found", 404

app.get "*", (req, res)->
  res.sendfile path.join static_base_path, "index.html"
  return
server = app.listen 1451, ->
  console.log server.address()

bell =
  lastValue : 0
  nowValue  : 0
buzzer =
  lastValue : 0
  nowValue  : 0


if /^arm/.test process.arch
  bell_pin = 21
  buzzer_pin = 20

  console.log "enable the raspberry pi's gpio"
  console.log "read pin is #{bell_pin}, #{buzzer_pin}"
  gpio = require("onoff").Gpio

  bell_button = new gpio bell_pin, 'in', 'both'
  bell_button.watch (err, value)->
    console.log err if err
    bell.nowValue = value

  buzzer_button = new gpio buzzer_pin, 'in', 'both'
  buzzer_button.watch (err, value)->
    console.log err if err
    buzzer.nowValue = value

  setInterval ->
    if bell.nowValue is bell.lastValue
      return
    bell.lastValue = bell.nowValue
    switch bell.nowValue
      when 0
        if Bell.stop() and Announce.autoPlay
          Announce.playDuration Announce.getDepartureFile Announce.nowDID
        console.log "stop the music by gpio"
      when 1
        Bell.play Bell.getFile Bell.nowBellId
        console.log "start the music by gpio"
      else
        console.log "input the GPIO pin: #{bell_pin} parameter is out range[0,1]"
  , 30

  setInterval ->
    if buzzer.nowValue is buzzer.lastValue
      return
    buzzer.lastValue = buzzer.nowValue
    switch buzzer.nowValue
      when 0
        Buzzer.stop()
        console.log "stop the buzzer by gpio"
      when 1
        Buzzer.play()
        console.log "start the buzzer by gpio"
      else
        console.log "input the GPIO pin: #{buzzer_pin} parameter is out range[0,1]"
  , 10
else
  console.log "This computer is not Raspberry pi"
