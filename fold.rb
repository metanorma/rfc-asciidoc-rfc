def wrap(s, width=78)
  s.gsub(/(.{10,#{width}})(\s+|\Z)/, "\\1\n").sub(/^\s+/, "")
end

embed = 0
cdata = false
$stdin.each_line do |line|
  embed = embed+1 if /CODE BEGINS/.match? line
  cdata = true if line.include? "<![CDATA["
  cdata = false if cdata && line.include?(']]>')
  embed = embed-1 if /CODE ENDS/.match? line
  line = wrap(line, 72) if embed>0 && !cdata # && line.length > 72
  puts line
end
