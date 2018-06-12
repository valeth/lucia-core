json.array! @categories do |cat|
  json.name cat.name.titleize

  json.icon cat.icon

  json.commands cat.commands do |cmd|
    json.admin cmd.admin
    json.category cmd.category.name
    json.desc cmd.desc.present? ? cmd.desc : "No description"
    json.names do
      json.primary cmd.name
      json.alts cmd.alts
    end
    json.partner cmd.partner
    json.sfw !cmd.nsfw
    json.usage cmd.usage
  end
end
