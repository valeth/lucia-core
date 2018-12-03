[217078934976724992, 125750263687413760, 137951917644054529].each do |uid|
  # DiscordUser.create(uid: uid)
  CookiesResource.create(uid: uid, score: rand(20))
  CurrencyResource.create(uid: uid, score: rand(10000))
  ExperienceResource.create(uid: uid, score: rand(10000))
end
