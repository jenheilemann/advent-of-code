# --- Day 7: No Space Left On Device ---

# The device the Elves gave you has problems with more than just its
# communication system. You try to run a system update:

# $ system-update --please --pretty-please-with-sugar-on-top Error: No space
# left on device

# Perhaps you can delete some files to make space for the update?

# To begin, find all of the directories with a total size of at most 100000,
# then calculate the sum of their total sizes. In the example above, these
# directories are a and e; the sum of their total sizes is 95437 (94853 + 584).
# (As in this example, this process can count files more than once!)

# Find all of the directories with a total size of at most 100000. What is the
# sum of the total sizes of those directories?

Directory = Struct.new(:dir_name, :address, :size, keyword_init: true) do
  def parent_address
    address[0..-2]
  end

  def add_size(additional_size, hard_drive)
    self.size = size + additional_size
    unless dir_name == '/'
      hard_drive[parent_address].add_size(additional_size, hard_drive)
    end
  end
end

hard_drive = {}
hard_drive[['/']] = Directory.new(dir_name: '/', address: ['/'], size: 0)
location = ['/']
dir_name = ""

File.open("./input.txt", "r") do |f|
  f.each_line do |line|
    case line
    when /\$ cd \w+/
      dir_name = /\$ cd (\w+)/.match(line).captures[0]
      location.push(dir_name)
      hard_drive[location.dup] = Directory.new(dir_name: dir_name, address: location.dup, size: 0)
    when /\$ cd \.\./
      location.pop
      next
    when /\d+ \w+/
      hard_drive[location].add_size(/(\d+) \w+/.match(line).captures[0].to_i, hard_drive)
    end
  end
end

small_folders = hard_drive.values.select {|dir| dir.size <= 100_000 }
print small_folders.map(&:size).inject(0, &:+)
