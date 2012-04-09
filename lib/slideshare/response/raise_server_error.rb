require 'faraday'

module Slideshare
  module Response
    class RaiseServerError < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 500
          raise Slideshare::InternalServerError, error_message(env, "Internal Server Error")
        when 502
          raise Slideshare::BadGateway, error_message(env, "Bad Gateway")
        when 503
          raise Slideshare::ServiceUnavailable, error_message(env, "Service Unavailable")
        end
      end

      private

      def error_message(env, message)
        "#{env[:method].to_s.upcase} #{env[:status]}: #{message}"
      end
    end
  end
end
