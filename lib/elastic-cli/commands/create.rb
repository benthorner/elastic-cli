require 'elasticsearch'
require 'json'

module ElasticCli
  module Commands
    module Create
      command :"create" do |c|
        c.syntax = 'create INDEX ID'
        c.description = 'Create a document'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'

        c.action do |args, options|
          options.default(host: 'localhost')
          options.default(port: '9200')

          index, id = *args
          fail('Missing argument: index') unless index
          fail('Missing argument: id') unless id

          params = { index: index, id: id, type: 'default' }
          client = client_for(options)

          puts "Creating document in #{index}"
          call(client, **params)
          puts "Saved document #{id} in #{index}"
        end
      end

      def self.call(client, **params)
        body = ask_editor(JSON.pretty_generate({}))
        client.create(**params, body: body)
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
