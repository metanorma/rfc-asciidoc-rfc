def wrap(s, width=78)
  s = s.
    sub(/<([^ >]+) (\S+)=(['"][^'"]+['"]|[^ "'\t\n\r]+) (\S+)=/, "<\\1 \\2= \\3 \\4= ").
    sub(/<([^ >]+) (\S+)=(\S)/, "<\\1 \\2= \\3").
    sub(%r{target='}, "target= '").
    gsub(/(.{10,#{width}})(\s+|\Z)/, "\\1\n").sub(/^\s+/, "").
    sub(/\.&#1499;&#1488;&#1503;/, "&#1499;&#1488;&#1503;").
    sub(/&#1502;&#1488;&#1512;&#1502;&#1514;&#1497;&#1492;/, ".&#1502;&#1488;&#1512;&#1502;&#1514;&#1497;&#1492;").
    sub(/\.&#1502;&#1497;/, "&#1502;&#1497;").
    sub(/&#1488;&#1488;&#1488;&#1488;&#1488;&#1488;&#1488;&#1492;/, ".&#1488;&#1488;&#1488;&#1488;&#1488;&#1488;&#1488;&#1492;")
    if s.length > width
      s = s.sub(/bibxml\//, "bibxml/\\\n").
        sub(/bibxml3\//, "bibxml3/\\\n")
    end
    s
end

embed = 0
cdata = false
$stdin.each_line do |line|
  embed = embed+1 if /^<CODE BEGINS>/.match? line
  cdata = false if cdata && line.include?('</artwork>')
  embed = embed-1 if /^<CODE ENDS>/.match? line
  linelen = line.length
  #warn line if embed>0 && !cdata && linelen > 72
  line = wrap(line, 72) if embed>0 && !cdata # && line.length > 72
  #warn line if embed>0 && !cdata && linelen > 72
  puts line
  cdata = true if /<artwork type=\s*['"]ascii-art['"]/.match(line)
  cdata = true if /<artwork alt/.match(line)
  cdata = !cdata if line == "....\n"
end
