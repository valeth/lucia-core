# frozen_string_literal: true

class ExperienceSystem
  include Score

  store_in collection: "ExperienceResource"

  self.prefixes = %w[
    Hiding Silent Whispering Chatty Talkative
    Loud Yelling Supersonic Worldwide Galactic
  ]

  self.suffixes = [
    "Ghost", "Shadow", "Lurker", "Ninja", "Person",
    "Loudmouth", "Drill Sergeant", "Announcer", "Mother", "Jet Engine"
  ]

  self.leveler = 13266.85
end
