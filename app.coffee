fs = require "fs"

wav = require "wav"

Speaker = require "speaker"
speaker = new Speaker

# file = './music/JR-SH1-1.wav'
# file = './music/shinjuku12.mp3'

fs.readdir './music', (err, files)->
  throw err if err

  fileList = []
  files
    .filter (file)->
      return /.*\.(wav|wave)$/.test file
    .forEach (file)->
      fileList.push file
  console.log fileList

return


fileDecode = file.split(".")
fileLength = fileDecode.length
if fileLength == 0
  console.error "file type do not understand"
  return
fileType = fileDecode[fileDecode.length-1]

stream = fs.createReadStream './music/JR-SH1-1.wav'

switch (fileType)
  when "wav", "wave"
    stream = stream
      .pipe new wav.Reader
      .pipe speaker
  when "mp3"
    console.error "mp3 is not surpported"
    return
    # stream
    #   .pipe new lame.Decoder
    #   .pipe new Speaker
  else
    console.error "undefined file type:", fileType

setTimeout ->
  console.log "close"
  stream.close()
, 1000
