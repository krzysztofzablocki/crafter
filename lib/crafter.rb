unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative 'project_helper'
require_relative 'git_helper'
require_relative 'target_configuration'

module Crafter
  extend self
  Crafter::ROOT = File.expand_path('.', File.dirname(__FILE__))

  @targets = {}
  @add_git_ignore = false
  @platforms = []

  def configure(&block)
    instance_eval &block
  end

  def with(name, &block)
    self.find_target_configuration(name).instance_eval(&block)
  end

  def project
    @project ||= ProjectHelper.new
  end

  def find_target_configuration(name)
    target = @targets[name]
    target ||= self.project.select_target_for_name name
    target_configuration = TargetConfiguration.new(name, target)
    @targets[name] = target_configuration
    target_configuration
  end

  def add_platform(platform_hash)
    @platforms << platform_hash
  end

  def add_git_ignore
    @add_git_ignore = true
  end

  def duplicate_configurations(duplication_hash)
    @configuration = duplication_hash
  end

  def set_options(options)
    @options = options
  end

  def set_build_settings(build_settings)
    @build_settings = build_settings
  end

  def setup_project
    process_optional()
    process_configurations() if @configuration unless @configuration.empty?
    process_options() if @options unless @options.empty?
    process_build_settings() if @build_settings unless @build_settings.empty? 
    process_git() if @add_git_ignore
    process_pods()
    process_scripts()
  end

  def process_configurations
    puts 'duplicating configurations'
    self.project.duplicate_configurations(@configuration)
  end

  def process_optional
    @targets.each { |_, v| v.process_optional }
  end

  def process_options
    puts 'setting up variety of options'
    self.project.enable_options(@options)
  end

  def process_build_settings
    puts 'set specified values for build settings'
    self.project.set_build_settings(@build_settings)
  end

  def process_git
    puts 'preparing git ignore'
    GitHelper.new.generate_files
  end

  def process_pods
    puts 'preparing pod file'
    File.open('Podfile', File::WRONLY|File::CREAT|File::EXCL) do |f|

      @platforms.each do |hash|
        name = hash[:platform]
        deployment = hash[:deployment]
        if deployment
          f.puts "platform :#{name}, '#{deployment}'"
        else
          f.puts "platform #{name}"
        end
      end

      @targets.each { |_, v| v.write_pods(f) }
    end

  rescue Exception => e
    puts "Skipping pod generation - #{e}"
  end

  def process_scripts
    puts 'adding scripts'
    @targets.each { |_, v| v.process_scripts(self.project) }
  end

  if File.exists?(File.join(ENV['HOME'], '.crafter.rb')) then
    load '~/.crafter.rb'
  else
    load "#{Crafter::ROOT}/config/default.rb"
  end
end