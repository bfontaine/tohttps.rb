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
r = RuleSet.new File.read("path/to/https-everywhere/rules/the-rule.xml")

# check if an URL matches the rule
r.match? "http://example.com/foo"

# rewrite an URL using the rule
r.replace "http://example.com/foo"
```

Note: this is a quick &amp; dirty script for now, it doesn’t have unit tests
nor documentation, and could *really* be optimized. I might make a gem at some
point in the future.
