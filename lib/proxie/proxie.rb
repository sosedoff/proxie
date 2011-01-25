module Proxie
  # Regular expression to detect static
  REGEX_DEFAULT = /\.(png|jpeg|jpg|gif|ico|css|swf)/i
  
  # Regular expression to detect javascripts
  REGEX_JS = /\.js/i
  
  # Regular expression to detect html
  REGEX_HTML = /(<html>|<body>)/i
  
  # Get user work dir
  def self.root
    "#{ENV['HOME']}/.proxie"
  end
  
  # Setup Proxie work dir
  def self.init
    unless File.exists?(root) && File.directory?(root)
      Dir.mkdir(root)
    end
  end
end