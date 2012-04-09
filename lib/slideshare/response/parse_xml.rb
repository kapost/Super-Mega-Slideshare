require 'faraday'
require 'nokogiri'
require 'multi_xml'

module Slideshare
  module Response
    class ParseXml < Faraday::Response::Middleware
      def on_complete(env)
        body = env[:body] or ''
        doc = Nokogiri::XML(body)
        doc.search('Message').each do |node|
          raise Slideshare::SlideshareError, error_message(env, node['ID'].to_s + " " + node.text)
        end
        env[:body] = ::MultiXml.parse(body)
      end

      private

      def error_message(env, message)
        "#{env[:method].to_s.upcase} #{env[:status]}: #{message}"
      end
    end
  end
end
