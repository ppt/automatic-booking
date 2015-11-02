casper = require("casper").create
  verbose: true
  logLevel: 'error'
  waitTimeout: 120000
  pageSettings:
    userAgent: 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'

util = require "utils"
moment = require 'moment'
execFile = require("child_process").execFile
exitFlag = false
casper.echo "#{moment().format('HH:mm:ss')} Start",'INFO'
casper.echo "retryTimeout: #{casper.defaults.retryTimeout}"
casper.start "http://www.yahoo.com"

casper.then ->
  @.echo "#{moment().format('HH:mm:ss')} Start LS",'INFO'
casper.then ->
  exitFlag = false
  retryTimeout = casper.defaults.retryTimeout
  casper.defaults.retryTimeout = 1000
  execFile "sleep", ["2"], null, (err, stdout, stderr) ->
    casper.echo "sleep: #{stdout}",'INFO'
    casper.echo "sleep error: #{stderr}",'ERROR'
    exitFlag = true
  @.waitFor ->
    casper.echo "#{moment().format('HH:mm:ss')} wait",'INFO'
    exitFlag
casper.then ->
  @.echo "#{moment().format('HH:mm:ss')} End",'INFO'
casper.run()