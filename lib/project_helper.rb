require 'xcodeproj'
require 'highline/import'

class ProjectHelper
  PROJECTS = Dir.glob('*.xcodeproj')

  def initialize
    @project = Xcodeproj::Project.open(xcode_project_file)
  end

  def enable_options(options)
    @project.build_configurations.each do |configuration|
      options.each do |option|
        configuration.build_settings[option] = 'YES'
      end
    end
    save_changes
  end

  def set_build_settings(build_settings)
    @project.build_configurations.each do |configuration|
      build_settings.each do |configuration_name, settings|
        if configuration_name.to_s.downcase == "crafter_common" || configuration.name.downcase == configuration_name.to_s.downcase
          settings.each do |key, value|
            configuration.build_settings[key] = value
          end
        end
      end
    end
    save_changes
  end

  def add_shell_script(target, name, script)
    if target.shell_script_build_phases.to_a.index { |phase| phase.name == name }
      puts "Skipping adding \"#{name}\" script for target #{target} as it already exist"
    else
      target.new_shell_script_build_phase(name).shell_script = script
      save_changes
    end
  end

  def duplicate_configurations(configurations_hash)
    configurations_hash.each do |name, base|

      @project.targets.each do |target|
        base_configuration, project_configuration = find_configurations(base, target)

        if !base_configuration || !project_configuration
          puts "unable to find configurations for #{base}"
          next
        end

        target.build_configurations << clone_configuration(base_configuration, name)
        @project.build_configurations << clone_configuration(project_configuration, name)
      end
    end

    save_changes
  end

  def select_target_for_name(name)
    targets = @project.targets.to_a.select { |t| t.name.end_with? name.to_s }
    targets = @project.targets.to_a if targets.empty?
    choose_item("Which target should I use for #{name}?", targets)
  end

  private

  def clone_configuration(base_configuration, name)
    build_config = @project.new(Xcodeproj::Project::XCBuildConfiguration)
    build_config.name = name.to_s
    build_config.build_settings = base_configuration
    build_config
  end

  def find_configurations(base, target)
    base_configuration = target.build_configuration_list.build_configurations.find { |t| t.name.downcase == base.to_s.downcase }
    base_configuration = base_configuration.build_settings if base_configuration

    project_configuration = @project.build_configurations.find { |t| t.name.downcase == base.to_s.downcase }
    project_configuration = project_configuration.build_settings if project_configuration
    return base_configuration, project_configuration
  end

  def xcode_project_file
    @xcode_project_file ||= choose_item('Project', PROJECTS)

    if @xcode_project_file == 'Pods.xcodeproj'
      raise 'Can not run in the Pods directory. $ cd .. maybe?'
    end

    @xcode_project_file
  end

  def choose_item(title, objects)
    if objects.empty?
      raise 'Could not locate any Targets!'
    elsif objects.size == 1
      objects.first
    else
      choose do |menu|
        menu.prompt = title
        objects.map { |object| menu.choice(object) }
      end
    end
  end

  def available_targets
    @project.targets.to_a.delete_if { |t| t.name.end_with?('Tests') }
  end

  def save_changes
    @project.save xcode_project_file
  end
end
