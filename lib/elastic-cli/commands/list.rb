require 'elasticsearch'

module ElasticCli
  module Commands
    module List
      command :"list" do |c|
        c.syntax = 'list INDEX'
        c.description = 'List all documents'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'
        c.option '--size SIZE', String, 'Elasticsearch size'

        c.action do |args, options|
          options.default(host: ENV['ELASTIC_HOST'])
          options.default(port: ENV['ELASTIC_PORT'])
          options.default(size: ENV['ELASTIC_SIZE'])

          index = args[0]
          fail('Missing argument: index') unless index

          client = client_for(options)
          params = params_for(options, index)

          call(client, **params)
        end
      end

      def self.call(client, params)
        response = client.search(**params)
        documents = response['hits']['hits']
        documents.each { |d| puts d['_id'] }
      end

      def self.params_for(options, index)
        { index: index, size: options.size, fields: [] }
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
