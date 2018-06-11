json.array! @categories do |cat|
  json.name cat.name

  json.icon cat.icon

  json.commands cat.commands do |cmd|
    json.admin cmd.admin
    json.category cmd.category
    json.desc cmd.desc
    json.names cmd.names
    json.partner cmd.partner
    json.sfw cmd.sfw
    json.usage cmd.usage
  end
end
