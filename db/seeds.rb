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

  cat2 = CommandCategory.find_or_create_by(name: "another")
  cat2.commands << Command.find_or_create_by(name: "poke") do |c|
    c.desc = "POKE!"
    c.nsfw = false
    c.partner = false
    c.admin = false
    c.alts = %w[finger stick]
  end

  [137951917644054529, 125750263687413760, 334387086293729281, 379342813814587392].each do |id|
    Donor.find_or_create_by(duid: id) do |m|
      m.tier = [1, 2].sample
      m.name = "Test#{id}"
    end
  end

  # Leaderboards

  # ids = Array.new(21) { rand(100_000_000_000_000_000) }
  ids = [
    137951917644054529, 125750263687413760, 334387086293729281,
    379342813814587392, 244285476368941058, 208974392644861952,
    182074044772909056, 146002691993108482, 290596897180352512,
    297810781163094027, 237619129673056257, 615337821309239337,
    263704629387198464, 233940818757419008, 346375728117317633,
    331793750273687553, 130605131182899200, 211922001546182656,
    160465236472758274, 454781232694427651, 459389205571960862,
    145800603598192640, 201657418701078529, 201769732234412032
  ]
  gids = %w[200751504175398912 217081703137542145 320652200319909889 273534239310479360]

  ids.each.with_index(0) do |uid, i|
    Leaderboard[:currency].find_or_create_by(uid: uid) do |m|
      m.score = rand(10000)
      m.origins = {
        "guilds" => { gids[i % 4] => rand(99) },
        "users" => { rand(100_000_000_000_000_000).to_s => rand(99) },
        "channels" => { rand(100_000_000_000_000_000).to_s => rand(99) }
      }
    end

    Leaderboard[:cookies].find_or_create_by(uid: uid) do |m|
      m.score = rand(20)
      m.origins = {
        "guilds" => { gids[i % 4] => rand(99) },
        "users" => { rand(100_000_000_000_000_000).to_s => rand(99) },
        "channels" => { rand(100_000_000_000_000_000).to_s => rand(99) }
      }
    end
  end

  # User blacklists and sabotages
  [201657418701078529, 201769732234412032].each do |uid|
    SabotagedUser.find_or_create_by(uid: uid)
  end

  BlacklistedUser.find_or_create_by(uid: 145800603598192640) do |m|
    m.total = true
    m.commands = []
    m.modules = []
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
