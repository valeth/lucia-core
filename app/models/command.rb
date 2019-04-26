# frozen_string_literal: true

class Command
  include Mongoid::Document

  store_in collection: "CommandCache"

  field :name, type: String
  field :desc, type: String, default: ""
  field :alts, type: Array, default: []
  field :usage, type: String, default: -> { "{pfx}{name}" }
  field :nsfw, type: Boolean, default: false
  field :partner, type: Boolean, default: false
  field :admin, type: Boolean, default: false

  belongs_to :category, class_name: "CommandCategory"

  validates :name, presence: true, uniqueness: true

  def usage
    self[:usage].sub("{pfx}", ">>").sub("{name}", name)
  end

  def matches?(**criteria)
    criteria.map { |k, v| send("matches_#{k}?", v) }.all?
  end

private

  def matches_name?(search)
    [
      name.downcase.include?(search.downcase),
      alts.any? { |x| x.downcase.include?(search.downcase) }
    ].any?
  end

  def matches_desc?(search)
    desc.downcase.include?(search.downcase)
  end
end
