require 'elasticsearch'
require 'json'

module ElasticCli
  module Commands
    module Show
      command :"show" do |c|
        c.syntax = 'show INDEX ID'
        c.description = 'Show a document'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'

        c.action do |args, options|
          options.default(host: 'localhost')
          options.default(port: '9200')

          index, id = *args
          fail('Missing argument: index') unless index
          fail('Missing argument: id') unless id

          params = { index: index, id: id }
          client = client_for(options)

          document = client.get(**params)
          puts JSON.pretty_generate(document['_source'])
        end
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
