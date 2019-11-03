# frozen_string_literal: true

class SabotagedUser
  include Mongoid::Document

  store_in collection: "SabotagedUsers"

  field :user_id, as: :uid, type: Integer
end
