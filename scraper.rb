require 'httparty'
require 'nokogiri'
require 'sendgrid-ruby'

class Scraper
  def call
    site = HTTParty.get("https://www.uvic.ca/BAN1P/bwckschd.p_disp_detail_sched?term_in=201909&crn_in=12859")
    
    puts site.code

    available_seats = Nokogiri::HTML(site).css("table .datadisplaytable").css('.dddefault').children.map { |seats| seats.text }.compact[2].to_i

    if available_seats != 0
      puts 'something is wrong, or a seat is open'
    end

    if available_seats > 0
      send_email
    end
  end

  def send_email
    my_email = File.open("email.txt").read.chop
    some_api_key = File.open("api_key.txt").read.chop

    from = SendGrid::Email.new(email: my_email)
    to = SendGrid::Email.new(email: my_email)
    subject = "register for that course bro"
    content = SendGrid::Content.new(type: 'text/plain', value: 'do it')
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: some_api_key)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
