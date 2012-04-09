require 'hashie'
require 'faraday'
require 'slideshare/request/multipart_with_file'
require 'slideshare/response/parse_xml'
require 'slideshare/response/raise_client_error'
require 'slideshare/response/raise_server_error'

module Slideshare
  # @private
  module Connection
    private
    
    def connection(raw=false)
      
      options = {
        :headers => {'Accept' => "application/#{format}", 'User-Agent' => user_agent},
        :ssl => {:verify => false},
        :url => api_endpoint,
      }

      Faraday::Connection.new(options) do |builder|
        builder.use Slideshare::Request::MultipartWithFile
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Slideshare::Response::RaiseClientError
        builder.use Slideshare::Response::ParseXml
        builder.use Slideshare::Response::RaiseServerError
        builder.adapter(adapter)
      end
    end
  end
end
