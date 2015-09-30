require 'sinatra'
require_relative 'seo_report/seo_report.rb'
require_relative 'seo_report/storages/abstract_storage.rb'
require_relative 'seo_report/storages/files_storage.rb'
require_relative 'seo_report/storages/data_storage.rb'
require_relative 'seo_report/storages/data_mapper.rb'
require_relative 'seo_report/storages/module_storage.rb'
require_relative 'seo.rb'
require 'pg'

module Seo
  class App < ::Sinatra::Application
    # Middleware
    use Rack::Reloader

    set :public_folder, -> { Seo.root_path.join('public').to_s }
    set :views, -> { Seo.root_path.join('views').to_s }

    get '/' do
      @reports = DmStorage.new.allreports

      slim :index
    end

    get '/reports/:id' do
      @storage = DmStorage.new.findreport(params[:id])
    end

    post '/report' do
      @report = SeoReport.new(params[:url])
      @report.generate
      @storage = DmStorage.new.addreport(@report)

      redirect '/'
    end

    not_found do
      status 404
      "Something wrong! Try to type URL correctly or call to UFO."
    end
  end
end