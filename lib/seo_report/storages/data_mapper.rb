require 'data_mapper'

class DmStorage < Storage::AbstractStorage
  def initialize
    DataMapper.setup(:default, "postgres://seo:seo@localhost/seotool")
    require_relative 'dm_models'

    @reports = DmModels::Report
    @links =   DmModels::Link
    @headers = DmModels::Header
  end

	def allreports
    @reports.all
  end

  def addreport(report)
		_report = @reports.create(url: report.url.to_s, time: Time.now, ip: report.ip)
		_report.save

		report.links.each do |link|
		  _link = @links.create(name: link.text, 
		  	                    href: link[:href], 
		  	                    rel: link['rel'], 
		  	                    target: link['target'], 
		  	                    report_id: _report.id )
		  _link.save
    end

    report.headers.each do |k, v|
      _header = @headers.create(name: k, 
      	                        value: v, 
      	                        report_id: _report.id )
      _header.save
    end
  end

  def findreport(id)
    _report = @reports.get(id)
    @report = SeoReport.new(_report.url)
    @report.ip = _report.ip
    @report.time = _report.time
    _linkss = _report.links.all
    _links = []
    _linkss.each { |link| _links << [link.name, link.href, link.rel, link.target]}
    @report.links = _links
    _headerss = _report.headers.all
    _headers = {}
    _headerss.each {|header| _headers[header.name] = header.value}
    @report.headers = _headers

    Slim::Template.new("./views/report.slim").render(@report)
  end
end


