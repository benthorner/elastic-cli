require 'elasticsearch'

module ElasticCli
  module Commands
    module List
      command :"list" do |c|
        c.syntax = 'list INDEX'
        c.description = 'List all documents'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'

        c.action do |args, options|
          options.default(host: 'localhost')
          options.default(port: '9200')

          index = *args
          fail('Missing argument: index') unless index

          params = { index: index, fields: [] }
          client = client_for(options)

          call(client, **params)
        end
      end

      def self.call(client, params)
        response = client.search(**params)
        documents = response['hits']['hits']
        documents.each { |d| puts d['_id'] }
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
