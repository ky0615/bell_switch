fs = require "fs"
path = require 'path'

wav = require "wav"
Speaker = require "speaker"

class Bell

  stream: null
  fileList: []
  wavDecoder: new wav.Reader
  speaker: new Speaker

  start: ->
    console.log "start"

  play: (file)->
    @stop() if @stream

    @wavDecoder = new wav.Reader
    @speaker = new Speaker

    @stream = fs
      .createReadStream file
      .pipe @wavDecoder
      .pipe @speaker
    return @stream

  stop: ()->
    unless @stream
      return
    # @stream.pause()
    # @stream.stop()
    @stream.close()
    # @stream.end()
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
