

def process(line, current, highest)
  if line == ""
    highest = current > highest ? current : highest
    current = 0
  else
    current += line.to_i
  end
end


highest = 0
current = 0

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    if line == "\n"
      highest = current > highest ? current : highest
      current = 0
    else
      current += line.to_i
    end
  end
end

puts(highest)
puts current
