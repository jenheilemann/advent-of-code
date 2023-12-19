# advent-of-code
Solutions to the puzzles at https://adventofcode.com

To use:

0. Make sure you have ruby 3.0+ installed, and probably a `.ruby-gemset` or whatever your prefered flavor of gem management is; `bundle install`.
1. Create a `.auth-cookie` file in the root of this project, and copy your login token marked 'session' from the advent of code website into this file.
2. Run `ruby run.rb`. This will either download your input for the current day and create the day folder with a basic template, or run the code in /year/day{n}/part{latest}.rb. If tests pass, it will prompt to run the code against the input file.
3. Profit!

This repo follows the automation guidelines on the /r/adventofcode community [wiki](https://www.reddit.com/r/adventofcode/wiki/faqs/automation). Specifically:

- There are no scheduled outbound calls, only one that happens if today's advent folder doesn't exist yet.
- Once inputs are downloaded, they are cached locally (`build_todays_folder!`)
- The User-Agent is set to 'Jen Heilemann' since I maintain this repo :)

