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
      year = get_year($opts)
      day = get_day($opts, year)
      part = get_part($opts, year, day)

      # if this creates a new rb file, it also exits the program
      build_todays_folder!(year, day, part)

      file = find_file({type: 'rb', year: year, part: part, day: day})
      puts "Requiring specified file: #{file}"
      require file
      puts "Running tests...."
      result = Minitest.run
      return puts("Tests failed, try again!") unless result

      if $opts[:tests_only]
        return
      end

      if $opts[:auto_run]
        puts "\n\nTests passed, autorunning full input...."
        run_full(day, year)
        return
      end

      puts "\n\nTests passed, do you want to run full input? (y/N)"
      if gets.chomp.downcase != "y"
        return puts("Exiting")
      end

      puts "To skip this next time, use '-y'"
      run_full(day, year)
    end

    def file_does_not_exist?(year, day, part)
      return false if year != Time.now.year.to_s && day.nil?

      file = find_file({type: 'txt', year:year, day: day})
      return true if !file

      file = find_file({type: 'rb', year:year, part: part, day: day})
      return !!file
    end

    def build_todays_folder!(year, day, part)
      day_s = day.rjust(2, '0')
      folder = "#{Dir.pwd}/#{year}/Day #{day_s}/"
      FileUtils.mkdir_p folder

      input = find_file({type: 'txt', year:year, day: day})
      if !input
        uri = URI.parse "https://adventofcode.com/#{year}/day/#{day}/input"
        cookie = File.read("#{Dir.pwd}/.auth-cookie")
        user_agent = "ruby script by jenheilemann @ https://github.com/jenheilemann/advent-of-code, Merry Christmas!"
        puts "opening uri: #{uri}"

        request = Net::HTTP.get_response(uri, {
          Cookie: "session=#{cookie}",
          UserAgent: user_agent})

        if request.response.code == '200'
          # Save the response body (file content) to a local file
          File.open(folder + 'input.txt', 'w') do |file|
            file.write(request.response.body)
          end
        else
          puts "Error: #{request.response.code} - #{request.response.message}"
          raise StandardError.new("Input file unable to download - did you put your session cookie in .auth-cookie?")
        end
      end

      file = find_file({type: 'rb', year:year, part: part, day: day})
      return if file
      to_copy = part == '1' ? "#{Dir.pwd}/utils/part1.rb.template" : "#{folder}part1.rb"
      FileUtils.cp(to_copy, folder + "part#{part}.rb")
      puts "Created #{folder}part#{part}.rb, good luck!"
      exit
    end

    def is_advent_season?
      t = Time.now
      t.month == 12 && t.day < 26
    end

    def get_year(opts)
      if opts[:year]
        ynum = opts[:year].to_i
        if ynum < 15 ||  ynum > 100 && ynum < 2015
          raise ArgumentError.new("There aren't AdventofCode problems before 2015, silly.")
        end
        return opts[:year].to_i < 2000 ? '20' + opts[:year] : opts[:year]
      end
      t = Time.now
      return t.year.to_s if t.month == 12
      (t.year - 1).to_s
    end

    def get_day(opts, year)
      return opts[:day].to_i.to_s if opts[:day]
      t = Time.now
      return t.day.to_s if is_advent_season? && year == t.year.to_s
      latest = find_file(type: 'txt', year: year)
      return '1' if !latest
      return /Day\s?(\d+)/.match(latest).captures[0].to_i.to_s
    end

    def get_part(opts, year, day)
      return opts[:part] if opts[:part]
      latest = find_file(type: 'rb', year: year, day: day)
      return '1' if !latest
      return /part(\d+)/.match(latest).captures[0].to_i.to_s
    end

    def run_full(day, year)
      input = File.read(find_file(type: 'txt', day: day, year: year))
      puts "#{Main.run!(input)}"
    end

    def find_file(opts = {})
      day = opts[:day].nil? ? '' : opts[:day].rjust(2, '0')
      search_str = "#{Dir.pwd}/"
      search_str += opts[:year] ? "#{opts[:year]}/"   : "**/"
      search_str += opts[:day]  ? "Day*#{day}/"  : (opts[:year] ? "**/" : "")
      search_str += opts[:part] ? "*part#{opts[:part]}" : "*"
      search_str += ".#{opts[:type]}"
      files = Dir.glob(search_str)
      files.filter{|f| !f.match(/(run\.rb)|(utils)/) }.last
    end
  end
end


