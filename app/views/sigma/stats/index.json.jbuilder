json.commands do
  @stats[:commands].each do |cmd|
    json.set! cmd.name, cmd.count
  end
end

json.events do
  @stats[:events].each do |evt|
    json.set! evt.name, evt.count
  end
end

json.general do
  json.population do
    json.guild_count @stats[:general].guild_count
    json.member_count @stats[:general].member_count
    json.channel_count @stats[:general].channel_count
  end

  json.cmd_count @stats[:commands].sum(&:count)
end

json.special do
  @stats[:special].each do |spc|
    json.set! spc.name, spc.count
  end
end
