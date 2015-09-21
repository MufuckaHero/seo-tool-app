require 'sinatra'
require_relative 'seo_report/seo_report.rb'
require_relative 'seo_report/report.rb'

module Seo
  class App < ::Sinatra::Application
    before do
    FileUtils.mkdir_p("./public/reports/") unless File
      .directory?("./public/reports/")
    end

    # Middleware
    use Rack::Reloader

    get '/' do
      @reports = Reports.new('./public/reports/').list
      slim :index
    end

    post '/report' do
      @report = SeoReport.new(params[:url])
      @report.generate

      redirect '/'
    end

    not_found do
      status 404
      "Something wrong! Try to type URL correctly or call to UFO."
    end
  end
end
