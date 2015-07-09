# tohttps

This is a quick script to parse [HTTPS Everywhere’s rules][rules]

[rules]: https://github.com/EFForg/https-everywhere/tree/master/src/chrome/content/rules

## Usage

Clone their repo somewhere on your computer:

    git clone https://github.com/EFForg/https-everywhere.git

And this one:

    git clone https://github.com/bfontaine/tohttps.rb.git && cd tohttps.rb

Then load a rule like this:

```ruby
require "./tohttps"

# replace with a valid filepath
r = Ruleset.new File.read("path/to/https-everywhere/rules/the-rule.xml")

# check if a URL matches the rule
r.match? "http://example.com/foo"

# rewrite a URL using the rule
r.rewrite "http://example.com/foo"

# load all the rules from a directory (warning: it takes a few minutes)
b = BatchRuleset.new "path/to/https-everywhere/rules"

# returns the first rule matched by the URL
b.ruleset_for "http://example.com"
```

Note: this is a quick &amp; dirty script for now, it doesn’t have unit tests
nor documentation, and could *really* be optimized. I might make a gem at some
point in the future.
