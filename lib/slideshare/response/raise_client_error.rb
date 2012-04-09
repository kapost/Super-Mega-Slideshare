require 'faraday'

module Slideshare
  module Response
    class RaiseClientError < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 400
          raise Slideshare::BadRequest, error_message(env)
        when 401
          raise Slideshare::Unauthorized, error_message(env)
        when 403
          raise Slideshare::Forbidden, error_message(env)
        when 404
          raise Slideshare::NotFound, error_message(env)
        when 406
          raise Slideshare::NotAcceptable, error_message(env)
        when 420
          raise Slideshare::EnhanceYourCalm.new error_message(env), env[:response_headers]
        end
      end

      private

      def error_message(env)
        "#{env[:method].to_s.upcase} #{env[:status]}: #{error_body(env[:body])}"
      end

      def error_body(body)
        if body.nil?
          nil
        elsif body['error']
          ": #{body['error']}"
        elsif body['errors']
          first = body['errors'].to_a.first
          if first.kind_of? Hash
            ": #{first['message'].chomp}"
          else
            ": #{first.chomp}"
          end
        end
      end
    end
  end
end
