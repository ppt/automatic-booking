casper = require("casper").create
  verbose: true
  logLevel: 'error'
  pageSettings:
    userAgent: 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'

util = require "utils"
moment = require 'moment'

# nosleep = true
maxloop = 60
loopcnt = 0
found_flag = false

# get param
user = casper.cli.get("user")
password_db =
  '20009324' : '0625'
password = password_db[user]
class_time = casper.cli.get("class-time")
class_name = casper.cli.get("class-name")
scan_time = "22:00:00"
casper.echo "#{scan_time} #{user}:#{password} #{class_time} #{class_name}", "INFO"

casper.Waiter = ->
  if not @.exists 'tr.virginRowStyle, tr.virginAltRowStyle'
    @.wait 3000, ->
      @.echo "#{loopcnt++}: Wait 3s", "INFO"
      @.click '#phContentTop_lbDate_8'
      @.waitForSelector '#phContentTop_lbDate_8.dateActive'
  else
    @.echo 'open', 'INFO'
    selector = 'tr.virginRowStyle, tr.virginAltRowStyle'
    rows = this.getElementsInfo(selector)
    @.echo "After getElement #{rows.length}", 'INFO'
    for row,i in rows
      # @.echo "#{i} ---------------", 'ERROR'
      # @.echo util.dump rows[i].html
      td = row.html.match /<td[^>]*>\s*([^<]*)/g
      t = []
      for r,index in td
        s = r.match(/<td[^>]*>\s*([^<]*)/)
        t.push s[1]
      # @.echo util.dump t
      # 0:time,3:class,5:instructor
      idtext = row.html.match /classdetail\.aspx\?id\=([^\"]*)/
      # @.echo "#{t[0]}, #{t[3]}, #{t[5]}, #{idtext[1]}"
      if t[0].toLowerCase() == class_time.toLowerCase() and t[3].toLowerCase() == class_name.toLowerCase()
        id = idtext[1]
        break
    @.echo "Click Booking", 'INFO'
    @.click "a[href='classdetail.aspx?id=#{id}']"
    @.waitForSelector 'a#btnNextStep.virginButtonGreen', ->
        @.click "a#btnNextStep"
        @.waitForSelector 'a#phContentBottom_btnBookAnother', ->
          @.exit()

  true

# sleep
now = moment()
end_time_str = "#{now.format('YYYY-MM-DD')} #{scan_time}"
end_time = moment(end_time_str,'YYYY-MM-DD HH:mm:ss')
sleep_time = parseInt end_time.diff(now,'milliseconds')
# casper.echo "sleep #{end_time.format('HH:mm:ss')} - #{now.format('HH:mm:ss')} = #{sleep_time/1000}s", "INFO"

casper.wait sleep_time if not nosleep?
casper.echo "#{moment().format('HH:mm:ss')} Start", "INFO"

# begin

casper.run()

