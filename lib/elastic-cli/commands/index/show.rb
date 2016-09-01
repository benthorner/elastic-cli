require 'elasticsearch'
require 'json'

module ElasticCli
  module Commands
    module Index
      module Show
        command :"index show" do |c|
          c.syntax = 'index show ID'
          c.description = 'Show an index'
          c.option '--host HOST', String, 'Elasticsearch host'
          c.option '--port PORT', String, 'Elasticsearch port'

          c.action do |args, options|
            options.default(host: 'localhost')
            options.default(port: '9200')

            id = args[0]
            fail('Missing argument: id') unless id

            params = { index: id }
            client = client_for(options)

            metadata = client.indices.get(**params)
            puts JSON.pretty_generate(metadata)
          end
        end

        def self.client_for(options)
          args = { host: options.host, port: options.port }
          Elasticsearch::Client.new(**args)
        end
      end
    end
  end
end
