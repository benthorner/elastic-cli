require 'yaml'

module ElasticCli
  module Commands
    module Config
      command :"config" do |c|
        c.syntax = 'config'
        c.description = 'Configure Elasticsearch client'
        c.option '--host HOST', String, 'Elasticsearch host'
        c.option '--port PORT', String, 'Elasticsearch port'
        c.option '--type TYPE', String, 'Document type'

        c.action do |args, options|
          options.default(host: ENV['ELASTIC_HOST'])
          options.default(port: ENV['ELASTIC_PORT'])
          options.default(type: ENV['ELASTIC_TYPE'])

          settings = { host: options.host, port: options.port, 
                       type: options.type }

          ElasticCli::Utilities::Config.store(settings)
        end
      end
    end
  end
end
