require 'pg'

class DataStorage < AbstractStorage
  def initialize
  	_db_params = {
      host:     'localhost',
      dbname:   'seotool',
      user:     'seo',
      password: 'seo'
    }
    @conn = PG::Connection.new(_db_params)

    @conn.exec "CREATE TABLE IF NOT EXISTS Reports(id SERIAl, url TEXT, time TEXT, ip TEXT)"
    @conn.exec "CREATE TABLE IF NOT EXISTS Links(id SERIAL, name TEXT, href TEXT, rel TEXT, target VARCHAR(15), report_id INT)"
    @conn.exec "CREATE TABLE IF NOT EXISTS Headers(id SERIAL, key TEXT, value TEXT, report_id INT)"
  end
  
  def allreports
    @files = []
    _files = @conn.exec "SELECT * FROM Reports"
    _files.each do |file|
      @files << {
        url:  file['url'],
        time: file['time'],
        path: file['id'].to_i
      }
    end
    @files.sort_by { |url| url[:url] }
  end

  def addreport(report)
  	_url = report.url.to_s
  	_time = Time.at(Time.now.to_i).strftime("%e %B %Y %k:%M").to_s
  	_ip = report.ip 

    _id = @conn.exec "INSERT INTO Reports (url, time, ip)
                VALUES ('#{_url}','#{_time}','#{_ip}')RETURNING id"
    _id = _id[0]["id"].to_i

    report.links.each do |link|
  	  @conn.exec "INSERT INTO Links (name, href, rel, target, report_id) 
  	              VALUES ('#{escape_apostrophe(link.text)}','#{link[:href]}','#{link["rel"]}','#{link["target"]}','#{_id}');"
    end
     
    report.headers.each do |k,v|
      @conn.exec "INSERT INTO Headers (key, value, report_id)
                  VALUES ('#{k}','#{escape_apostrophe(v)}','#{_id}');"
    end
  end

  def findreport(id)
  	_report = @conn.exec "SELECT * FROM Reports WHERE id = #{id}" 
  	_url, _ip, _time  = _report[0]['url'], _report[0]['ip'], _report[0]['time']

    _headerss = @conn.exec "SELECT * FROM Headers WHERE report_id = #{id}"
    _headers = {}
    _headerss.each {|header| _headers[header['key']] = header['value']}

    _linkss = @conn.exec "SELECT * FROM Links WHERE report_id = #{id}"
    _links = []
    _linkss.each { |link| _links << [link['name'], link['href'], link['rel'], link['target']]}

    @report         = SeoReport.new(_url)
    @report.ip      = _ip 
    @report.time    = _time
    @report.links   = _links
    @report.headers = _headers

    Slim::Template.new("./views/report.slim").render(@report)
  end

  def escape_apostrophe(string)
    old_string = string
    string = " " if string.nil?
    if string.include? '\''
      string.gsub!('\'','\'\'')
    else
      old_string
    end
  end
end
