if Rails.env.development? || Rails.env.test?
  BotVersion.find_or_create_by(build_date: 1556274480) do |m|
    m.beta = true
    m.codename = "Vueko"
    m.version = { major: 4, minor: 1, patch: 666 }
  end

  # Commands & Modules

  cat = CommandCategory.find_or_create_by(name: "test")
  cat.commands << Command.find_or_create_by(name: "hello") do |c|
    c.desc = "Nothing"
    c.nsfw = false
    c.partner = false
    c.admin = false
  end
  cat.commands << Command.find_or_create_by(name: "help") do |c|
    c.desc = "I've fallen"
    c.nsfw = true
    c.partner = false
    c.admin = true
  end

  Donor.find_or_create_by(duid: 217078934976724992) do |m|
    m.tier = 1
  end

  # Leaderboards

  ids = Array.new(21) { rand(100_000_000_000_000_000) }
  gids = %w[200751504175398912 217081703137542145 273534239310479360 442252698964721669]

  ids.each.with_index(0) do |uid, i|
    CurrencySystem.find_or_create_by(uid: uid) do |m|
      m.score = rand(10000)
      m.origins = {
        "guilds" => { gids[i % 4] => rand(99) },
        "users" => { rand(100_000_000_000_000_000).to_s => rand(99) },
        "channels" => { rand(100_000_000_000_000_000).to_s => rand(99) }
      }
    end

    ExperienceSystem.find_or_create_by(uid: uid) do |m|
      m.score = rand(10000)
      m.origins = {
        "guilds" => { gids[i % 4] => rand(99) },
        "users" => { rand(100_000_000_000_000_000).to_s => rand(99) },
        "channels" => { rand(100_000_000_000_000_000).to_s => rand(99) }
      }
    end

    Cookie.find_or_create_by(uid: uid) do |m|
      m.score = rand(20)
      m.origins = {
        "guilds" => { gids[i % 4] => rand(99) },
        "users" => { rand(100_000_000_000_000_000).to_s => rand(99) },
        "channels" => { rand(100_000_000_000_000_000).to_s => rand(99) }
      }
    end
  end

  # Statistics

  %w[givecookie hunt fish].each do |cmd|
    CommandStatistic.find_or_create_by(command: cmd) do |m|
      m.count = rand(1000)
    end
  end

  %w[ready dbinit command].each do |evt|
    EventStatistic.find_or_create_by(event: evt) do |m|
      m.count = rand(1000)
    end
  end

  GeneralStatistic.find_or_create_by(name: "population") do |m|
    m.guild_count = 3
    m.channel_count = 20
    m.member_count = 100
  end
end
