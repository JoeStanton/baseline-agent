class BaselineAgent
  desc 'event:config', "Create a configuration event"

  method_option 'description', required: true
  method_option 'service', required: true
  method_option 'url', required: false
  method_option 'author', required: false
  method_option 'host', required: false

  define_method 'event:config' do
    send_event({
      type: :configuration,
      service_slug: options.service,
      description: options.description,
      url: options.url,
      author: options.author,
      host: options.host || Socket.gethostname
    })
  end
end
