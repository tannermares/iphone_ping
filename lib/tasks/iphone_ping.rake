require 'net/http'
require 'sendgrid-ruby'
include SendGrid

desc 'Ping iStockNow to check iPhone stock'
task :iphone_ping do
  url      = 'http://www.istocknow.com/live/live.php'
  type     = '7Plus'
  operator = 'att'
  color    = 'allblack'
  model    = '256GB'
  nocache  = Time.now.to_i
  uri      = URI.parse("#{url}?type=#{type}&operator=#{operator}&color=#{color}&model=#{model}&ajax=1&nocache=#{nocache}&nobb=false&notarget=false&noradioshack=false&nostock=true")
  response = Net::HTTP.get(uri)

  if JSON.parse(response)['count'] != 0
    from    = Email.new(email: 'tannermares+iPhonePing@gmail.com')
    subject = 'Check iStockNow!'
    to      = Email.new(email: 'tannermares@gmail.com')
    content = Content.new(type: 'text/plain', value: "Dude go check iStockNow! http://www.istocknow.com/live")
    mail    = Mail.new(from, subject, to, content)

    sg       = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  else
    puts 'Still nothing'
  end
end
