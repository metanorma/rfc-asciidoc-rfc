def wrap(s, width=78)
  s.gsub(/(.{10,#{width}})(\s+|\Z)/, "\\1\n").sub(/^\s+/, "")
end

embed = 0
$stdin.each_line do |line|
  embed = embed+1 if /CODE BEGINS/.match? line
  embed = embed-1 if /CODE ENDS/.match? line
  line = wrap(line, 72) if embed>0 # && line.length > 72
  puts line
end
