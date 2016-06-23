require 'pp'

def modify_gemfile
  append_to_gemfile = <<-all_done

# BEGIN added by guard-setup.rb
group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry', '0.9.12'
end
# END
all_done

  File.open("Gemfile", "r+") do |gemfile|
    # p gemfile
    re = Regexp.new append_to_gemfile
    gemfile_s = gemfile.read
    if re.match(gemfile_s) == nil
      gemfile.puts append_to_gemfile
    else
      puts "Gemfile already modified!"
    end
  end

  puts "modify_gemfile done..."
end

# modify_gemfile

def move_ruby_files_into_lib
  `mkdir -p lib`
  # move all ruby files into lib
  `mv *.rb lib/`
  # move guard-setup.rb back into current directory
  `mv ./lib/#{$0} .`

  puts "move_ruby_files_into_lib done..."
end

# move_ruby_files_into_lib

def modify_spec_files
  Dir.glob('./spec/*_spec.rb') do |spec_file_name_s|
    # do work on files ending in .rb in the desired directory
    # p rb_file_s
    # p rb_file_s.class
    spec_file_s = File.read(spec_file_name_s)
    if /require_relative '\.\.\/lib/.match(spec_file_s) == nil
      spec_file_formatted = spec_file_s.gsub(/require_relative '\.\./, \
        "require_relative '../lib")
      spec_file_formatted = spec_file_formatted.gsub(/^describe/, \
                                                     "RSpec.describe")
      File.open(spec_file_name_s, "w") { |file| file.puts spec_file_formatted }
    end

    puts "modify_spec_files done..."
  end
end

# modify_spec_files


def bundle_stuff
  `rm -f Gemfile.lock`
  puts "Gemfile.lock done..."
  
  `bundle install --binstubs`
  puts "bundle install --binstubs done..."

  `bundle exec rspec --init`
  puts "bundle exec rspec --init done..."

  `bundle exec guard init`
  puts "bundle exec guard init done..."

  puts "bundle_stuff done..."
end

# bundle_stuff

def modify_guardfile
  guard_config = "Guardfile"
  guard_file = File.read(guard_config)
  guard_file_formatted = guard_file.gsub(/"bundle exec rspec"/, \
                                         "\"bin/rspec\"")
  File.open(guard_config, "w") { |file| file.puts guard_file_formatted }

  puts "modify_guardfile done..."
end

# modify_guardfile


# Run methods
modify_gemfile
move_ruby_files_into_lib
modify_spec_files
bundle_stuff
modify_guardfile
puts "installation and configuation complete..."
puts "to start guard, execute the following command:"
puts "bundle exec guard --clear"