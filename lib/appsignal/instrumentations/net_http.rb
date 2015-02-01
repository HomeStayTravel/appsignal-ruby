require 'net/http'

Net::HTTP.class_eval do
  alias request_without_appsignal request

  def request(request, body=nil, &block)
    ActiveSupport::Notifications.instrument(
      'request.net_http',
      :url => "#{use_ssl? ? 'https' : 'http'}://#{request['host'] || self.address}#{request.path}",
      :method => request.method
    ) do
      request_without_appsignal(request, body, &block)
    end
  end
end
