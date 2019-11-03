# frozen_string_literal: true

class BlacklistedUser
  include Mongoid::Document

  store_in collection: "BlacklistedUsers"

  field :user_id, as: :uid, type: Integer
  field :total, type: Boolean
  field :commands, type: Array
  field :modules, type: Array
end
