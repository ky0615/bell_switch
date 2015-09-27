gulp = require "./gulpfile"
sequence = require "run-sequence"

sequence "build", ->
  console.log "gulp build was successful"
  sequence "watch:assets", ->
