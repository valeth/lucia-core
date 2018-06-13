json.array! @categories do |cat|
  json.cache! ["v1", cat], expires_in: 5.minutes do
    json.name cat.name.titleize

    json.icon cat.icon

    json.commands do
      json.partial! "sigma/commands/command", collection: cat.commands, as: :cmd
    end
  end
end
