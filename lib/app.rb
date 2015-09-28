require 'sinatra'
require_relative 'seo_report/seo_report.rb'
require_relative 'seo_report/abstract_storage.rb'
require_relative 'seo_report/files_storage.rb'
require_relative 'seo_report/data_storage.rb'

module Seo
  class App < ::Sinatra::Application
    # Middleware
    use Rack::Reloader

    get '/' do
      @reports = Storage.new.allreports

      slim :index
    end

    get '/reports/:id' do
      @storage = Storage.new.findreport(params[:id])
    end

    post '/report' do
      @report = SeoReport.new(params[:url])
      @report.generate
      @storage = Storage.new.addreport(@report)

      redirect '/'
    end

    not_found do
      status 404
      "Something wrong! Try to type URL correctly or call to UFO."
    end

  
  end
end