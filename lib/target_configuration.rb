class TargetConfiguration
  attr_accessor :pods
  attr_accessor :scripts

  def initialize(name, target)
    @name = name
    @target = target
    @pods = []
    @scripts = []
    @options = {}
  end

  def add_option(name, &block)
    @options[name] = block
  end

  def process_optional
    @options.each do |key, obj|
      key_string = key.to_s
        if ask_question "do you want to add #{key_string}? [y/n]"
          raise unless obj.is_a? Proc
          obj.call()
        end
    end
  end

  def write_pods(f)
    return if @pods.empty?
    f.puts "target '#{@target.name}', :exclusive => true do"
    pods.flatten.each do |pod|
      f.puts "  pod '#{pod}'"
    end
    f.puts 'end'
  end

  def process_scripts(project)
    scripts.each do |hash|
      project.add_shell_script(@target, hash[:name], hash[:script])
    end
  end

  def ask_question(question)
    puts question
    get_input()
  end

  def get_input
    STDOUT.flush
    input = STDIN.gets.chomp
    case input.upcase
      when 'Y'
        true
      when 'N'
        false
      else
        puts 'Please enter Y or N'
        get_input
    end
  end
end