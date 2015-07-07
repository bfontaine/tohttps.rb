#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require "./tohttps"

g = BatchRuleset.new "rules/rules"

Formula.each do |f|
  matches = []

  matches << "homepage" if g.ruleset_for f.homepage
  matches << "stable" if f.stable && g.ruleset_for(f.stable.url)
  matches << "devel" if f.devel && g.ruleset_for(f.devel.url)
  matches << "head" if f.head && g.ruleset_for(f.head.url)

  if matches.empty?
    puts "  #{f.full_name}"
  else
    # just in case full_name is nil (can it be?)
    puts "X #{f.full_name || f.name}: #{matches.join(", ")}"
  end
end
