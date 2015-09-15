utils = require('utils');

scan = ['7:30am','Pilates Reformer','Keng']

casper = require('casper').create
  verbose: true
  logLevel: 'error'
  pageSettings:
    userAgent: 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'

console.log 'Begin'

casper.start "http://mylocker.virginactive.co.th/www/login.aspx", ->
  @.sendKeys('input#phContentBottom_txtMemberID', '20009324');
  @.sendKeys('input#phContentBottom_txtPassword', '0625');
  @.click '#phContentBottom_btnLogin'
  @.waitForSelector '#phNavBar_MainNavigation1_hlClass'

casper.then ->
  @.click '#phNavBar_MainNavigation1_hlClass'
  @.waitForSelector '#bookingSheet'

casper.then ->
  @.click '#phContentTop_lbDate_8'
  @.waitForSelector '#phContentTop_lbDate_8.dateActive'

casper.then ->
  selector = 'tr.virginRowStyle, tr.virginAltRowStyle'
  rows = this.getElementsInfo(selector)
  console.log "After getElement #{rows.length}"
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
    if t[0].toLowerCase() == scan[0].toLowerCase() and t[3].toLowerCase() == scan[1].toLowerCase()
      id = idtext[1]
      break
  @.click "a[href='classdetail.aspx?id=#{id}']"
  @.waitForSelector 'a#btnNextStep.virginButtonGreen'

casper.then ->
  @.click "a#btnNextStep"
  @.waitForSelector 'a#phContentBottom_btnBookAnother'

casper.then ->
  casper.capture 's1.png'

casper.run()

