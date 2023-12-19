require 'minitest'
require 'optparse'
require 'fileutils'
require 'net/http'

require_relative 'array.rb'
require_relative 'map.rb'
require_relative 'position.rb'
require_relative 'heapq.rb'

$opts = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby run.rb [options]"

  opts.on("-y", "--[no-]auto_run", "Skip confirmations") do |y|
    $opts[:auto_run] = y
  end
  opts.on("-t", "--tests_only", "Skip confirmations, stop after tests") do |t|
    $opts[:tests_only] = t
  end
  opts.on("-dINTEGER", "--day INTEGER", "Select day, defaults to latest") do |day|
    $opts[:day] = day
  end
  opts.on("-YINTEGER", "--year INTEGER", "Select year, defaults to latest") do |year|
    $opts[:year] = year
  end
  opts.on("-pINTEGER", "--part INTEGER", "Select part 1 or 2, defaults to latest") do |part|
    $opts[:part] = part
  end
end.parse!

class AdventRunner
  class << self
    def go!
      if is_advent_season? && todays_folder_does_not_exist?
        build_todays_folder!
        puts "Today's folder created, input data downloaded."
        puts "Good luck!"
        return
      end

      file = find_file({type: 'rb', year:$opts[:year], part: $opts[:part], day: $opts[:day]})
      puts "Requiring latest file: #{file}"
      require file
      sleep(0.3)
      puts "Running tests...."
      sleep(0.3)
      result = Minitest.run
      return puts("Tests failed, try again!") unless result

      if $opts[:tests_only]
        return
      end

      if $opts[:auto_run]
        puts "\n\nTests passed, autorunning full input...."
        sleep(1) && run_full
        return
      end

      puts "\n\nTests passed, do you want to run full input? (y/N)"
      if gets.chomp.downcase != "y"
        return puts("Exiting")
      end

      puts "To skip this next time, use '-y'"
      sleep(1)
      run_full
    end

    def todays_folder_does_not_exist?
      t = Time.now
      files = Dir.glob("#{Dir.pwd}/#{t.year}/Day #{t.strftime('%d')}/*")
      files.length == 0
    end

    def build_todays_folder!
      t = Time.now
      folder = "#{Dir.pwd}/#{t.year}/Day #{t.strftime('%d')}/"


      uri = URI.parse "https://adventofcode.com/#{t.year}/day/#{t.day}/input"
      cookie = File.read("#{Dir.pwd}/.auth-cookie")
      user_agent = "ruby script by jenheilemann @ https://github.com/jenheilemann/advent-of-code, Merry Christmas!"
      puts "opening uri: #{uri}"

      request = Net::HTTP.get_response(uri, {
        Cookie: "session=#{cookie}",
        UserAgent: user_agent})

      if request.response.code == '200'
        FileUtils.mkdir_p folder
        FileUtils.cp("#{Dir.pwd}/utils/part1.rb.template", folder + 'part1.rb')
        # Save the response body (file content) to a local file
        File.open(folder + 'input.txt', 'w') do |file|
          file.write(request.response.body)
        end
      else
        puts "Error: #{request.response.code} - #{request.response.message}"
      end
    end

    def is_advent_season?
      t = Time.now
      t.month == 12 && t.day < 26
    end

    def run_full
      input = File.read(find_file({type: 'txt', day: $opts[:day], year:$opts[:year]}))
      puts "#{Main.run!(input)}"
    end

    def find_file(opts = {})
      search_str = "#{Dir.pwd}/"
      search_str += opts[:year] ? "20#{opts[:year]}/"   : "**/"
      search_str += opts[:day]  ? "Day*#{opts[:day]}/"  : (opts[:year] ? "**/" : "")
      search_str += opts[:part] ? "*part#{opts[:part]}" : "*"
      search_str += ".#{opts[:type]}"
      files = Dir.glob(search_str)
      files.filter{|f| !f.match(/(run\.rb)|(utils)/) }.last
    end
  end
end


