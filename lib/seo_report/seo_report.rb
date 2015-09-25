require 'socket'
require 'nokogiri'
require 'open-uri'

class SeoReport
  attr_reader :ready_url

  def initialize(url)
    @url = url
  end

  def generate
    @ready_url = prepare(@url)
    
    _response = HTTParty.get(@url)
    @headers = _response.headers

    _doc = Nokogiri::HTML(_response.body)
    @links = _doc.css('a')
    @links.each do |link|
      link[:href] = "http://" + @ready_url.to_s + link[:href].to_s unless
      (link[:href] =~ /http(s*):\/\/(www\.)*/) ||
      (link[:href] =~ /^mailto:/)
    end

    @ip = IPSocket::getaddress(prepare(@url))
    
    @time = Time.at(Time.now.to_i).strftime("%e %B %Y %k:%M")
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