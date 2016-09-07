require 'elasticsearch'
require 'json'

module ElasticCli
  module Commands
    module Edit
      command :"edit" do |c|
        c.syntax = 'edit INDEX ID'
        c.description = 'Edit a document'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'

        c.action do |args, options|
          options.default(host: ENV['ELASTIC_HOST'])
          options.default(port: ENV['ELASTIC_PORT'])

          index, id = *args
          fail('Missing argument: index') unless index
          fail('Missing argument: id') unless id

          client = client_for(options)
          params = { index: index, id: id, type: 'default' }

          puts "Opening document in #{index}"
          call(client, **params)
          puts "Saved document #{id} in #{index}"
        end
      end

      def self.call(client, **params)
        document = client.get(**params)

        body = JSON.pretty_generate(document['_source'])
        body = JSON.parse(ask_editor(body))

        client.delete(**params)
        client.create(**params, body: body)
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
