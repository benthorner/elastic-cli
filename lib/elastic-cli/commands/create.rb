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
        c.option '--template TEMPLATE', String, 'Document template'
        c.option '--type TYPE', String, 'Document type'

        c.action do |args, options|
          options.default(host: ENV['ELASTIC_HOST'])
          options.default(port: ENV['ELASTIC_PORT'])
          options.default(type: ENV['ELASTIC_TYPE'])
                
          index, id  = *args
          fail('Missing argument: index') unless index
          fail('Missing argument: id') unless id

          params = { index: index, id: id, type: options.type }
          client = client_for(options)
          template = template_for(options)

          puts "Creating document in #{index}"
          call(client, template, **params)
          puts "Saved document #{id} in #{index}"
        end
      end

      def self.call(client, template, **params)
        body = ask_editor(template)
        client.create(**params, body: body)
      end

      def self.template_for(options)
        return "{\n}" if options.template.nil?
        fail('Missing template') unless File.exists?(options.template)
        File.read(options.template)
      end

      def self.client_for(options)
        args = { host: options.host, port: options.port }
        Elasticsearch::Client.new(**args)
      end
    end
  end
end
