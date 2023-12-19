# --- Part Two ---

# Now, you're ready to choose a directory to delete.

# The total disk space available to the filesystem is 70000000. To run the
# update, you need unused space of at least 30000000. You need to find a
# directory you can delete that will free up enough space to run the update.

# In the example above, the total size of the outermost directory (and thus the
# total amount of used space) is 48381165; this means that the size of the
# unused space must currently be 21618835, which isn't quite the 30000000
# required by the update. Therefore, the update still requires a directory with
# total size of at least 8381165 to be deleted before it can run.

# To achieve this, you have the following options:

#     Delete directory e, which would increase unused space by 584.
#     Delete directory a, which would increase unused space by 94853.
#     Delete directory d, which would increase unused space by 24933642.
#     Delete directory /, which would increase unused space by 48381165.

# Directories e and a are both too small; deleting them would not free up enough
# space. However, directories d and / are both big enough! Between these, choose
# the smallest: d, increasing unused space by 24933642.

# Find the smallest directory that, if deleted, would free up enough space on
# the filesystem to run the update. What is the total size of that directory?

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

TOTAL_AVAILABLE = 70_000_000
REQUIRED_FREE = 30_000_000
CURRENT_USED = hard_drive[['/']].size
CURRENT_FREE = TOTAL_AVAILABLE - CURRENT_USED
MIN_TO_DELETE = REQUIRED_FREE - CURRENT_FREE

large_folders = hard_drive.values.select {|dir| dir.size >= MIN_TO_DELETE }
print large_folders.map(&:size).min
