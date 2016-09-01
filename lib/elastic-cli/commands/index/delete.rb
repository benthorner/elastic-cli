require 'elasticsearch'

module ElasticCli
  module Commands
    module Index
      module Delete
        command :"index delete" do |c|
          c.syntax = 'index delete ID'
          c.description = 'Delete an index'
          c.option '--host HOST', String, 'Elasticsearch host'
          c.option '--port PORT', String, 'Elasticsearch port'

          c.action do |args, options|
            options.default(host: 'localhost')
            options.default(port: '9200')

            id = args[0]
            fail('Missing argument: id') unless id

            params = { index: id }
            client = client_for(options)

            call(client, **params)
            puts "Deleted index #{id}"
          end
        end

        def self.call(client, **params)
          exit unless agree("Delete index #{params[:id]}?")
          client.indices.delete(**params)
        end

        def self.client_for(options)
          args = { host: options.host, port: options.port }
          Elasticsearch::Client.new(**args)
        end
      end
    end
  end
end
