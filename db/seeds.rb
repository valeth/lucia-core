[217078934976724992, 125750263687413760, 137951917644054529].each do |uid|
  # DiscordUser.create(uid: uid)
  Cookie.create(uid: uid, score: rand(20))
  CurrencySystem.create(uid: uid, score: rand(10000))
  ExperienceSystem.create(uid: uid, score: rand(10000))
end
