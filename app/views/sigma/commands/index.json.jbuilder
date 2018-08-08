json.array! @categories do |cat|
  json.name cat.name.titleize

  json.icon cat.icon

  json.commands do
    json.partial! "sigma/commands/command", collection: cat.commands, as: :cmd
  end
end
