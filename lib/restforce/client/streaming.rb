module Restforce
  class Client
    module Streaming

      # Public: Subscribe to a PushTopic
      #
      # channel - The name of the PushTopic channel to subscribe to.
      # block   - A block to run when a new message is received.
      #
      # Returns a Faye::Subscription
      def subscribe(channel, &block)
        faye.subscribe "/topic/#{channel}", &block
      end

      # Public: Faye client to use for subscribing to PushTopics
      def faye
        raise 'Instance URL missing. Call .authenticate! first.' unless @options[:instance_url]
        @faye ||= Faye::Client.new("#{@options[:instance_url]}/cometd/#{@options[:api_version]}").tap do |client|
          client.bind 'transport:down' do
            Restforce.log "[COMETD DOWN]"
            client.set_header 'Authorization', "OAuth #{authenticate!.access_token}"
          end
          client.bind 'transport:up' do
            Restforce.log "[COMETD UP]"
          end
        end
      end

    end
  end
end
