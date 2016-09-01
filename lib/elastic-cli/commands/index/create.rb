require 'elasticsearch'
require 'json'

module ElasticCli
  module Commands
    module Index
      module Create
        command :"index create" do |c|
          c.syntax = 'index create ID'
          c.description = 'Create an index'
          c.option '--host HOST', String, 'Elasticsearch host'
          c.option '--port PORT', String, 'Elasticsearch port'

          c.action do |args, options|
            options.default(host: 'localhost')
            options.default(port: '9200')

            id = args[0]
            fail('Missing argument: id') unless id

            params = { index: id }
            client = client_for(options)

            puts "Creating index"
            call(client, **params)
            puts "Saved index #{id}"
          end
        end

        def self.call(client, **params)
          body = ask_editor(JSON.pretty_generate({}))
          client.indices.create(**params, body: body)
        end

        def self.client_for(options)
          args = { host: options.host, port: options.port }
          Elasticsearch::Client.new(**args)
        end
      end
    end
  end
end
