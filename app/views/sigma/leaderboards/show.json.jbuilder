json.leaderboards @scores do |s|
  json.user s.user_data

  json.value s.score

  json.level do
    json.curr s.current_level
    json.next_req s.next_level_required
    json.next_perc s.next_level_percent
  end

  json.title do
    json.tier s.tier
    json.name s.title
  end
end
