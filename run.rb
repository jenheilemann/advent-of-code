# Required folder structure : year/day/file
# Input data in in the file : year/day/input.txt
# the last file in alphabetical order is loaded, tests are run, and if they pass
# then the Main run! method is executed with input.txt exploded as the input.

require_relative 'utils/advent_runner.rb'
AdventRunner.go!
