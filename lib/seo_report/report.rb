class ReportsHandler
  def initialize(path)
    if path
      @files = Dir.entries(path).delete_if { |x| !(x =~ /html/) }
    else
      raise StandardError, 'there is no path'
    end
  end

  def create()
    if @files.any?
      _files = []

      @files.each do |file|
        _files << {
          # Site url
          url: file.gsub(/_.+/, ''),
          # Creation time
          time: Time.at(file.gsub(/.+_/, '').to_i).strftime("%e %B %Y"),
          # File path
          path: file
        }
      end
      return _files.sort_by { |hsh| hsh[:url] }
    end
  end
end