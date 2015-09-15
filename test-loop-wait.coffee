casper = require("casper").create
  verbose: true
  logLevel: 'error'
  pageSettings:
    userAgent: 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'

util = require "utils"
moment = require 'moment'

nosleep = true
maxloop = 1000
loopcnt = 0
maxcnt = 2

casper.Waiter = ->
  @.echo "#{loopcnt}", 'INFO'
  @.wait 3000, ->
    @.echo "#{loopcnt++}: Wait 3s", "INFO"
    if loopcnt > 2
      found_flag = true
      @.echo "found"
      @.wait 4000
      @.then ->
        @.echo "after wait 4000"
        @.wait 4000
      @.then ->
        @.echo "end"
        @.exit()
  true

# get param
user = casper.cli.get("user")
password = casper.cli.get("password")
class_time = casper.cli.get("class-time")
class_name = casper.cli.get("class-name")
scan_time = "22:00:00"
casper.echo "#{scan_time} #{user}:#{password} #{class_time} #{class_name}", "INFO"

# sleep
now = moment()
end_time_str = "#{now.format('YYYY-MM-DD')} #{scan_time}"
end_time = moment(end_time_str,'YYYY-MM-DD HH:mm:ss')
sleep_time = parseInt end_time.diff(now,'milliseconds')
# casper.echo "sleep #{end_time.format('HH:mm:ss')} - #{now.format('HH:mm:ss')} = #{sleep_time/1000}s", "INFO"

casper.start "www.yahoo.com", ->
  @.wait sleep_time if not nosleep?
casper.then ->
  @.echo "#{moment().format('HH:mm:ss')} Start", "INFO"

# loop until booking
casper.then ->
  for i in [0..maxloop]
    @.waitFor ->
      @.Waiter(i)
  @.echo 'Olayy!', 'INFO'

casper.run()

