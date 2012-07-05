require 'sequel'
require 'sequel/extensions/pagination'

# Database connection.
DB = Sequel.connect 'sqlite://db/bootcamp.db'

# Sequel schema plugin.
Sequel::Model.plugin :schema

# Application Controllers.
Dir['controllers/*.rb'].each { |controller| require_relative controller }

# Database models.
Dir['models/*.rb'].each { |model| require_relative model }
