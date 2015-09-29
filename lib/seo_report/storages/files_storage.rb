class FilesStorage < Storage::AbstractStorage
  def initialize
  	FileUtils.mkdir_p("./public/reports/")
  end

  def allreports
  	@files = Dir.entries('./public/reports/').delete_if { |x| !(x =~ /html/) }

    if @files.any?
      _files = []
      @files.each do |file|
        #remove extenstion .html
        file = file.gsub(/.html/, '')
        #take timestamp of file
        _file_time = file[-10..-1]

        _files << {
          url: file.gsub(/_.+/, ''),
          time: Time.at(_file_time.to_i).strftime("%e %B %Y %k:%M"),
          path: "#{file}.html"
        }
      end
      _files.sort_by { |url| url[:url] }
    end
  end

  def addreport(report)
  	_links = []
  	for link in report.links do
      _links << [link.text, link[:href], link["rel"], link["target"]]
    end
    report.links = _links

    _body = Slim::Template.new("./views/report.slim").render(report)
    File.write(File.expand_path("#{report.ready_url}_#{Time.now.to_i}.html", "public/reports"),_body)
  end

  def findreport(filename)
    File.open("./public/reports/#{filename}", 'r')
  end
end
