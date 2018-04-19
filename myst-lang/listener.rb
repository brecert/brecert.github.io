require 'listen'
require 'slim'
require 'ostruct'

#require 'redcarpet' # for :markdown
require 'redcarpet/compat'


location = 'src'
only = '.slim$'

# https://stackoverflow.com/questions/1489183/colorized-ruby-output
class String 
  # colorization
  def colorize(color_code)
    "\e[1;#{color_code}m#{self}\e[0m"
  end
end

class Env
end

at_exit do
  puts "Closed"
end

@variables = eval File.read('./src/variables.rb')

def render_slim(file)
  slim_file = File.read(file)
  
  # Yes I know this is really terrible but it only runs one to make the webpage so \shrug
  struct = OpenStruct.new(OpenStruct.new(@variables).to_h.transform_values! {|v| 
    if v.start_with?('markdown:')
      v.slice!('markdown:')
      Markdown.new(v).to_html 
    else
      v
    end
  })
  p struct
  
  template = Slim::Template.new {slim_file}.render struct
  File.write('./public/index.html', template)
  puts "  compiled ".colorize(32) << "#{File.expand_path(file).split('/').last(2).join('/')}"
end

puts "  watching ".colorize(32) << "#{location}/#{only}"
render_slim('./src/index.slim')

listener = Listen.to(location, only: Regexp.new("#{only}")) do |modified, added, removed|
  modified.each do |file|
    @variables = eval File.read('./src/variables.rb')
    render_slim(file)
  end
  puts "  watching ".colorize(32) << "#{location}/#{only}"
end

listener.start

variable_listener = Listen.to(location, only: Regexp.new(".rb$")) do |modified, added, removed|
  modified.each do |file|
    @variables = eval File.read('./src/variables.rb')
    render_slim('./src/index.slim')
  end
  puts "  watching ".colorize(32) << "#{location}"
end

variable_listener.start

puts system(' stylus ./src --out ./public --watch ')

sleep