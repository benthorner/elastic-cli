require 'yaml' 

module ElasticCli
  module Utilities
    module Config
      PATH = ENV['HOME'] + '/.elastic-cli'

      def self.load
        if File.exists?(PATH)
          settings = YAML.load(File.read(PATH))
          host, port = settings[:host], settings[:port]
          type = settings[:type]

          ENV['ELASTIC_HOST'] = host if host
          ENV['ELASTIC_PORT'] = port if port
          ENV['ELASTIC_TYPE'] = type if type
        end
      end

      def self.store(settings)
        File.write(PATH, settings.to_yaml)
      end
    end
  end
end


