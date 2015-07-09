require "./tohttps"
require "formula"

ohai "Loading the rules..."
g = BatchRuleset.new "rules/rules"
ohai "Done."

Formula.each do |f|
  next if f.tap?
  next unless f.bottle # we only work on bottled formulae for now

  homepage_rs = g.ruleset_for f.homepage
  stable_rs = g.ruleset_for f.stable.url if f.stable
  devel_rs = g.ruleset_for f.devel.url if f.devel
  head_rs = g.ruleset_for f.head.url if f.head

  next unless homepage_rs || stable_rs || devel_rs || head_rs

  ohai "Checking #{f.name}"

  source = "#{HOMEBREW_PREFIX}/Library/Formula/#{f.name}.rb"
  content = File.read(source)

  replaced = content.gsub(f.homepage, homepage_rs.rewrite(f.homepage)) if homepage_rs

  replaced.gsub!(f.stable.url, stable_rs.rewrite(f.stable.url)) if stable_rs
  replaced.gsub!(f.devel.url, devel_rs.rewrite(f.devel.url)) if devel_rs
  replaced.gsub!(f.head.url, head_rs.rewrite(f.head.url)) if head_rs

  if replaced == content
    opoo "Couldn't fix #{f.name} :("
    next
  end

  ohai "Fixed #{f.name}"

  File.open(source, "w") { |s| s.write replaced }
end
