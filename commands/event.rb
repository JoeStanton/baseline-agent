class BaselineAgent
  no_commands {
    def send_event(payload)
      require_setup!
      url = Configuration.load.management_server
      RestClient.post "#{url}/events", event: payload, content_type: :json
    end
  }
end
