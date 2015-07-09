require "json"
require "./tohttps"

class Ruleset
  def to_h
    {
      :name => @name,
      :targets => @targets,
      :rules => @rules,
      :exclusions => @exclusions
    }
  end
end

class BatchRuleset
  def to_a
    @rulesets.map(&:to_h)
  end
end

b = BatchRuleset.new "rules/rules"

File.open("rules.json", "w") { |f| f.write b.to_a.to_json }
