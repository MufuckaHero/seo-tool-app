require 'sinatra'
require_relative 'seo_report/seo_report.rb'
require_relative 'seo_report/abstract_storage.rb'
require_relative 'seo_report/files_storage.rb'
require_relative 'seo_report/data_storage.rb'
require_relative 'seo_report/data_mapper.rb'
require_relative 'seo.rb'

module Seo
  class App < ::Sinatra::Application
    # Middleware
    use Rack::Reloader

    set :public_folder, -> { Seo.root_path.join('public').to_s }
    set :views, -> { Seo.root_path.join('views').to_s }

    get '/' do
      @reports = DataStorage.new.allreports

      slim :index
    end

    get '/reports/:id' do
      @storage = DataStorage.new.findreport(params[:id])
    end

    post '/report' do
      @report = SeoReport.new(params[:url])
      @report.generate
      @storage = DataStorage.new.addreport(@report)

      redirect '/'
    end

    not_found do
      status 404
      "Something wrong! Try to type URL correctly or call to UFO."
    end

  
  end
end