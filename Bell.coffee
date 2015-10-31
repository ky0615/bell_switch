fs = require "fs"
path = require 'path'

exec = require('child_process').exec
spawn = require('child_process').spawn

platform = process.platform

class Bell

  fileList: []
  stream: null

  nowBellId: 0

  play: (file)->
    @stop() if @stream
    if /^darwin/.test platform
      @stream = spawn "afplay", [file]
    else
      @stream = spawn "aplay", [0..10].map -> file

  stop: ()->
    unless @stream
      return false
    if /^darwin/.test platform
      exec "kill " + @stream.pid
    else
      @stream.kill "SIGTERM"
      @stream.emit "stop"
    @stream = null
    return true

  getFileList: (cb)=>
    fs.readdir './music', (err, files)=>
      throw err if err

      fileList = []
      files
        .filter (file)=>
          return /.*\.(wav|wave|mp3)$/.test file
        .forEach (file)=>
          fileList.push file
      @fileList = fileList
      if cb
        cb fileList

  getFile: (id)=>
    return "./music/" + @fileList[id]

  getFIleId: (file)=>
    for k, v of @fileList
      if v is file
        return k
    return -1

  getFileType: (fileName)->
    fileDecode = file.split(".")
    fileLength = fileDecode.length
    if fileLength == 0
      return null
    return fileDecode[fileDecode.length-1]


module.exports = Bell
