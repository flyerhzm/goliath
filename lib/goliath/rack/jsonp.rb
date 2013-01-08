module Goliath
  module Rack
    # A middleware to wrap the response into a JSONP callback.
    #
    # @example
    #  use Goliath::Rack::JSONP
    #
    class JSONP
      include Goliath::Rack::AsyncMiddleware

      def post_process(env, status, headers, body)
        return [status, headers, body] unless env.params['callback']

        response = ""
        if body.respond_to?(:each)
          body.each { |s| response << s }
        else
          response = body
        end

        body = "#{env.params['callback']}(#{response})"
        headers['Content-Type'] = 'application/javascript'
        headers['Content-Length'] = body.bytesize.to_s
        [status, headers, [body]]
      end
    end
  end
end

