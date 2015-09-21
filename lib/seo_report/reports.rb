class Reports
  def initialize(path)
    if path
      @files = Dir.entries(path).delete_if { |x| !(x =~ /html/) }
    else
      raise StandardError, 'there is no path'
    end
  end

  def list
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
      return _files.sort_by { |hsh| hsh[:url] }
    end
  end
end