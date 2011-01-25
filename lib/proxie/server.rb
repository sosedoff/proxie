module Proxie
  class Server
    attr_reader :port
    attr_reader :options
    attr_reader :logger
    
    # Initialize server instance
    # Options:
    #   :default  => true   Skip static filess like images, stylesheets, swf, etc
    #   :html     => true   Skip if html in body
    #   :js       => true   Skip javascripts
    def initialize(port=8080, args={})
      @options = {
        :default => args[:default]  || true,
        :js      => args[:js]       || true,
        :images  => args[:images]   || true
      }
      
      @server = WEBrick::HTTPProxyServer.new(
        :Port => port,
        :AccessLog => [],
        :ProxyContentHandler => Proc.new { |req, resp| process(req, resp) }
      )
    end
    
    # Setup traffic logger
    def logger=(obj)
      raise ArgumentError, 'Logger required!' if obj.nil?
      raise ArgumentError, 'Logger method [packet] is not defined!' unless obj.respond_to?(:packet)
      @logger = obj
    end
    
    # Start proxy server
    def start
      raise RuntimeError, 'Logger is not defined!' if @logger.nil?
      @server.start
    end
    
    # Stop proxy server
    def stop
      @server.shutdown
    end
    
    private
    
    # Log traffic request-response sequence
    def process(req, resp)
      return if @options[:default] && req.request_line.match(REGEX_DEFAULT)
      return if @options[:js] && req.request_line.match(REGEX_JS)
      return if @options[:html] && resp.body.match(REGEX_HTML)
      @logger.packet(req, resp)
    end
  end
end