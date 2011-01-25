require 'rubygems'
require 'sinatra'

enable :run
set :logging, false
set :dump_errors, false

get '/' do
  @files = Dir.glob("#{Proxie.root}/*.sqlite").map do |f|
    {:name => File.basename(f), :size => File.size(f) / 1024 }
  end
  erb :index
end
  
get '/db/:name' do
  db = Sequel.sqlite("#{Proxie.root}/#{params[:name]}")
  @rows = db[:requests].all
  erb :records
end

__END__

@@ layout
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Proxie Web</title>    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style>
      html { background: #e5e5e5; }
      body { background: transparent; font:13px 'Lucida Grande',Geneva,Helvetica,Arial,sans-serif; position: relative; }
      .wrapper { padding: 10px; }
      h1 { border-bottom: 2px solid #ccc; }
      .db { padding: 2px 0px; }
      .db span { font-color: #555; font-size: 11px; }
      .req { background: #fff; border: 1px solid #ccc; margin-bottom: 8px; }
      .req .url { padding: 4px; background: #f1f1f1; }
      .req pre { padding: 4px; white-space: normal; overflow-x: auto; }
      table.headers { }
      table.headers td { border-collapse: 0px; padding: 2px; border-right: 1px solid #ccc; border-bottom: 1px solid #ccc; }
    </style>
  </head>
  <body>
    <div class="wrapper">
      <h1>Proxie v<%= Proxie::VERSION %></h1>
      <%= yield %>
    </div>
  </body>
</html>

@@ index
<h2>Your databases:</h2>
<% unless @files.empty? %>
  <% @files.each do |f| %>
    <div class="db">
      <a href="/db/<%= f[:name] %>"><%= f[:name] %></a> - 
      <span><%= f[:size] %> Kb</span>
    </div>
  <% end %>
<% else %>
  <p>You dont have any databases yet.</p>
<% end %>

@@records
<h2><a href="/">Databases</a> :: <%= params[:name] %></h2>
<% @rows.each do |r| %>
  <div class="req">
    <div class="url"><%= r[:id] %>. <%= r[:request_url] %></div>
    <pre>
      <b>Request Headers:</b><br/>
      <table class="headers">
        <% JSON.parse(r[:request_headers]).each_pair do |k,v| %>
          <tr>
            <td><%= k %></td>
            <td><%= v %></td>
          </tr>
        <% end %>
      </table>
    </pre>
    <pre><b>Request Body:</b><%= r[:request_body] %></pre>
    <pre>
      <b>Request Headers:</b><br/>
      <table class="headers">
        <% JSON.parse(r[:response_headers]).each_pair do |k,v| %>
          <tr>
            <td><%= k %></td>
            <td><%= v %></td>
          </tr>
        <% end %>
      </table>
    </pre>
    <pre><b>Response Body:</b><br/><%= r[:response_body] %></pre>
  </div>
<% end %>