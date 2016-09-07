include Commander::Methods

require 'elastic-cli/commands/create'
require 'elastic-cli/commands/config'
require 'elastic-cli/commands/delete'
require 'elastic-cli/commands/edit'
require 'elastic-cli/commands/index/create'
require 'elastic-cli/commands/index/delete'
require 'elastic-cli/commands/index/show'
require 'elastic-cli/commands/list'
require 'elastic-cli/commands/show'
require 'elastic-cli/utilities/config'

program :name, 'elastic-cli'
program :version, '0.0.1'
program :description, 'CLI for elasticsearch'

default_command :help
ElasticCli::Utilities::Config.load
