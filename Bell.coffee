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
      @stream = exec "afplay " + file
    else
      @stream = exec "aplay -l0 " + file

  stop: ()->
    unless @stream
      return
    exec "kill " + @stream.pid
    @stream = null

  getFileList: (cb)=>
    fs.readdir './music', (err, files)=>
      throw err if err

      fileList = []
      files
        .filter (file)=>
          return /.*\.(wav|wave)$/.test file
        .forEach (file)=>
          fileList.push file
      @fileList = fileList
      if cb
        cb fileList

  getFile: (id)=>
    return "./music/" + @fileList[id]

  getFileType: (fileName)->
    fileDecode = file.split(".")
    fileLength = fileDecode.length
    if fileLength == 0
      return null
    return fileDecode[fileDecode.length-1]


module.exports = Bell
