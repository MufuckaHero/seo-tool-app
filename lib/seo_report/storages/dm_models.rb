module DmModels
  class Header
    include DataMapper::Resource
    belongs_to :report

    property :id,         Serial
    property :name,       String
    property :value,      String
    property :report_id,  Integer
  end

  class Link
    include DataMapper::Resource
    belongs_to :report

    property :id,         Serial
    property :name,       String
    property :href,       String
    property :rel,        String
    property :target,     String
    property :report_id,  Integer
  end

  class Report
    include DataMapper::Resource
    has n, :links
    has n, :headers

    property :id,           Serial
    property :url,          String
    property :time,         String
    property :ip,           IPAddress
  end
  DataMapper.finalize
  DataMapper.auto_upgrade!
end

