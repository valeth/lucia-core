# frozen_string_literal: true

class FetchCommandsJob < ApplicationJob
  queue_as :default

  def perform
    @in_filesystem = []
    @in_database = Command.all.pluck(:name)

    module_list
      .map { |f| YAML.load_file(f) }
      .reject { |x| x["category"].nil? }
      .each { |mod| category_from_dump(mod) }

    database_cleanup
  end

private

  def database_cleanup
    diff = @in_database - @in_filesystem
    return if diff.empty?
    Rails.logger.info { "Purging #{diff.size} commands from database" }
    Command.in(name: diff).destroy_all
  end

  def category_from_dump(mod)
    cat = CommandCategory.where(name: mod["category"]).first_or_create
    mod.fetch("commands", []).map { |c| command_from_dump(c, cat) }
  end

  def command_from_dump(cmd, cat)
    @in_filesystem << cmd["name"]

    options = {
      name:     cmd["name"],
      desc:     cmd["description"],
      usage:    cmd["usage"]&.sub("{pfx}", ">>")&.sub("{cmd}", cmd["name"]),
      alts:     cmd["alts"],
      nsfw:     cmd.dig("permissions", "nsfw"),
      partner:  cmd.dig("permissions", "partner"),
      admin:    cmd.dig("permissions", "admin"),
      category: cat
    }.reject { |_k, v| v.blank? }
    Command.where(name: cmd["name"]).first_or_initialize.update(options)
  end

  def module_list
    Rails.configuration.x.sigma_path.join("sigma/modules").glob("**/module.yml")
  end
end
