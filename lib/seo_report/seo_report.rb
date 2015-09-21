require 'socket'
require 'nokogiri'
require 'open-uri'

class SeoReport
  def initialize(url)
    @url = url
  end

  def generate
    _response = HTTParty.get(@url)
    @headers = _response.headers

    _doc = Nokogiri::HTML(_response.body)
    @links = _doc.css('a')
    @links.each do |link|
      unless link[:href] =~ /http(s*):\/\/(www\.)*/ 
        link[:href] = "http://" + prepare(@url) + link[:href]
      end
    end

    @ip = IPSocket::getaddress(prepare(@url))
    
    @time = Time.at(Time.now.to_i).strftime("%e %B %Y %k:%M")

    _body = Slim::Template.new("./views/report.slim").render(self)
    _ready_url = prepare(@url)
    File.write(File.expand_path("#{_ready_url}_#{Time.now.to_i}.html", "public/reports"),_body)
  end

  def prepare(url)
    url.chop! if url[-1] == "/"
    if url.include?("https")
      url = url[8..url.length-1]
    else
      url = url[7..url.length-1]
    end
  end
end