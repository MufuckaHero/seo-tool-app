class FilesStorage < AbstractStorage
  def self.allreports
  	@files = Dir.entries('./public/reports/').delete_if { |x| !(x =~ /html/) }

    if @files.any?
       _files = []
     @files.each do |file|
       #remove extenstion .html
       file = file.gsub(/.html/, '')
       #take timestamp of file
       _file_time = file[-10..-1]
       #fill array
       _files << {
         url: file.gsub(/_.+/, ''),
         time: Time.at(_file_time.to_i).strftime("%e %B %Y %k:%M"),
         path: "#{file}.html"
      }
      end
      _files.sort_by { |url| url[:url] }
    end
  end

  def self.addreport(report)
  	_body = Slim::Template.new("./views/report.slim").render(report)
    File.write(File.expand_path("#{report.ready_url}_#{Time.now.to_i}.html", "public/reports"),_body)
  end

  def self.findreport(value)
    File.open("./public/reports/#{value}", 'r')
  end
end
