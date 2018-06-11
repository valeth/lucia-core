# frozen_string_literal: true

class Command
  ABILITIES = %i[admin partner nsfw].freeze

  def initialize(cmd, category)
    @name = cmd["name"]
    @attributes = {
      desc: cmd.fetch("description", ""),
      usage: define_usage(cmd),
      category: category,
      names: {
        primary: @name,
        alts: cmd["alts"]
      }
    }

    permissions(cmd["permissions"])

    @attributes.each_key do |key|
      define_singleton_method(key) { @attributes[key] }
    end
  end

  def sfw
    !@attributes.fetch(:nsfw, false)
  end

  def matches?(**criteria)
    criteria.map { |k, v| send("matches_#{k}?", v) }.all?
  end

private

  def matches_name?(search)
    [
      @attributes.dig(:names, :primary).downcase.include?(search.downcase),
      @attributes.dig(:names, :alts)&.any? { |x| x.downcase.include?(search.downcase) }
    ].any?
  end

  def matches_desc?(search)
    @attributes[:desc].downcase.include?(search.downcase)
  end

  def define_usage(cmd, prefix: ">>")
    if cmd["usage"].present?
      cmd["usage"]&.sub("{pfx}", prefix)&.sub("{cmd}", @name)
    else
      "#{prefix}#{@name}"
    end
  end

  def permissions(perms)
    if perms
      ABILITIES.each do |ability|
        @attributes[ability] = perms.fetch(ability.to_s, false)
      end
    else
      ABILITIES.each { |a| @attributes[a] = false }
    end
  end
end
