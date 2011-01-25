module Proxie
  class Logger
    def packet(req, resp)
      # DEFAULT LOGGER IS NOT IMPLEMENTED YET
      # OVERRIDE!
    end
  end
  
  class SQLiteLogger < Logger
    attr_reader :db, :records
    
    # Initialize SQLite3 logger
    def initialize(path, overwrite=true)
      raise 'Database file with this name already exists!' if File.exists?(path) && !overwrite
      File.delete(path) if File.exists?(path)
      
      @db = Sequel.sqlite(path)
      @db.create_table :requests do
        primary_key :id
        string :request_headers
        string :request_url
        string :request_body
        string :response_headers
        string :response_body
      end
      @records = @db[:requests]
    end
    
    # Save request and response data
    def packet(req, resp)
      @records.insert(
        :request_headers  => req.header.to_json,
        :request_url      => req.request_line,
        :request_body     => req.body.inspect,
        :response_headers => resp.header.to_json,
        :response_body    => resp.body.inspect
      )
    end
  end
end