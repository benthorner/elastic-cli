require 'elasticsearch'

module ElasticCli
  module Commands
    module Delete
      command :"delete" do |c|
        c.syntax = 'delete INDEX ID'
        c.description = 'Delete a document'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'

        c.action do |args, options|
          options.default(host: ENV['ELASTIC_HOST'])
          options.default(port: ENV['ELASTIC_PORT'])

          index, id = *args
          fail('Missing argument: index') unless index
          fail('Missing argument: id') unless id

          params = { index: index, id: id, type: 'default' }
          client = client_for(options)

          call(client, **params)
          puts "Deleted document #{id}"
        end
      end

      def self.call(client, **params)
        exit unless agree("Delete document #{params[:id]}?")
        client.delete(**params)
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
