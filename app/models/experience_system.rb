# frozen_string_literal: true

class ExperienceSystem
  include Mongoid::Document
  include Score

  store_in collection: "ExperienceResource"

  field :user_id, as: :uid, type: Integer
  field :ranked, as: :score, type: Integer, default: 0
  field :origins, type: Hash, default: { "users": {}, "guilds": {}, "channels": {} }

private

  def prefixes
    @prefixes ||= %w[
      Hiding Silent Whispering Chatty Talkative
      Loud Yelling Supersonic Worldwide Galactic
    ].freeze
  end

  def suffixes
    @suffixes ||= [
      "Ghost", "Shadow", "Lurker", "Ninja", "Person",
      "Loudmouth", "Drill Sergeant", "Announcer", "Mother", "Jet Engine"
    ].freeze
  end

  def leveler
    @leveler ||= 13266.85
  end
end
