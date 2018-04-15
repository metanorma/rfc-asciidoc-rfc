require "rexml/document" 

doc = REXML::Document.new(File.read(ARGV[0]))
formatter = REXML::Formatters::Pretty.new

# Compact uses as little whitespace as possible
formatter.compact = true
formatter.width = 72
formatter.write(doc, $stdout)
