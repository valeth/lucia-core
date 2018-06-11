# frozen_string_literal: true

class Command
  ABILITIES = %i[admin partner nsfw].freeze

  def initialize(cmd, category)
    @name = cmd["name"]
    @attributes = {
      desc: cmd["description"],
      usage: cmd["usage"]&.sub("{pfx}", ">>")&.sub("{cmd}", @name),
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

private

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
