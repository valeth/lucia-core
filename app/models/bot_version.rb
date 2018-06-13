class BotVersion
  include Mongoid::Document

  store_in client: "sigma", collection: "VersionCache"

  field :beta, type: Boolean
  field :build_date, type: Integer
  field :codename, type: String
  field :version, type: Hash
end
