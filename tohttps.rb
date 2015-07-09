#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require "uri"
require "rexml/document"

# TODO tests

class Ruleset
  attr_accessor :name, :targets, :rules, :exclusions

  def initialize(content)
    compile content
  end

  def compile(content)
    doc = REXML::Document.new(content)
    root = doc.root

    @name = root.attribute("name").to_s

    @targets = root.get_elements("//target").map do |t|
      make_host_pattern t.attribute("host").to_s
    end

    @rules = root.get_elements("//rule").map do |r|
      [
        Regexp.new(r.attribute("from").to_s.sub(%r[/$], "")),
        r.attribute("to").to_s.sub(%r[/$], "")
      ]
    end

    @exclusions = root.get_elements("//exclusion").map do |r|
      make_host_pattern r.attribute("pattern").to_s
    end
  end

  def rewrite url
    return url unless match? url

    rule = @rules.find { |r, _| r =~ url }
    return url unless rule

    rule, replacement = rule

    replacement.gsub!(/\$(\d+)/, '\\\\\1')

    url.sub(rule, replacement)
  end

  def match? host
    host.start_with?("http://") && !exclusions_match?(host) && targets_match?(host)
  end

  def exclusions_match?(host)
    @exclusions.any? { |e| e =~ host }
  end

  def targets_match?(host)
    host = URI.parse(host).host || host
    @targets.any? { |t| t =~ host }
  end

  private

  def make_host_pattern(s)
    left_wildcard = s.start_with? "*"
    right_wildcard = s.end_with? "*"

    s.slice!(0) if left_wildcard
    s.slice!(-1) if right_wildcard

    s = Regexp.escape(s)

    s = "[.\\w]*#{s}" if left_wildcard
    s << "\\w*" if right_wildcard

    Regexp.new "^#{s}$"
  end
end

# not optimized
class BatchRuleset
  attr_reader :rulesets

  def initialize directory
    @rulesets = Dir["#{directory}/*.xml"].map { |f| Ruleset.new(File.read f) }
  end

  def ruleset_for url
    @rulesets.find { |r| r.match? url }
  end
end
