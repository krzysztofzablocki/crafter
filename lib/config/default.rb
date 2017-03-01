load "#{Crafter::ROOT}/config/default_scripts.rb"

# All your configuration should happen inside configure block
Crafter.configure do

  # This are projects wide instructions
  add_platform({:platform => :ios, :deployment => 8.0})
  add_git_ignore
  duplicate_configurations({:Adhoc => :Release})

  # set of options, warnings, static analyser and anything else normal xcode treats as build options
  set_options %w(
    GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED
    GCC_WARN_MISSING_PARENTHESES
    GCC_WARN_ABOUT_RETURN_TYPE
    GCC_WARN_SIGN_COMPARE
    GCC_WARN_CHECK_SWITCH_STATEMENTS
    GCC_WARN_UNUSED_FUNCTION
    GCC_WARN_UNUSED_LABEL
    GCC_WARN_UNUSED_VALUE
    GCC_WARN_UNUSED_VARIABLE
    GCC_WARN_SHADOW
    GCC_WARN_64_TO_32_BIT_CONVERSION
    GCC_WARN_ABOUT_MISSING_FIELD_INITIALIZERS
    GCC_WARN_UNDECLARED_SELECTOR
    GCC_WARN_TYPECHECK_CALLS_TO_PRINTF
    GCC_WARN_UNINITIALIZED_AUTOS
    CLANG_WARN_INT_CONVERSION
    CLANG_WARN_ENUM_CONVERSION
    CLANG_WARN_CONSTANT_CONVERSION
    CLANG_WARN_BOOL_CONVERSION
    CLANG_WARN_EMPTY_BODY
    CLANG_WARN_SUSPICIOUS_IMPLICIT_CONVERSION
    GCC_WARN_64_TO_32_BIT_CONVERSION

    RUN_CLANG_STATIC_ANALYZER
    GCC_TREAT_WARNINGS_AS_ERRORS
  )

  # target specific options, :default is just a name for you, feel free to call it whatever you like
  with :default do

    # each target have set of pods
    pods << %w(NSLogger-CocoaLumberjack-connector TestFlightSDK)

    # each target can have optional blocks, eg. crafter will ask you if you want to include networking with a project
    add_option :networking do
      pods << 'AFNetworking'
    end

    add_option :coredata do
      pods << 'MagicalRecord'
    end

    # each target can have shell scripts added, in this example we are adding my icon versioning script as in http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/
    scripts << {:name => 'icon versioning', :script => Crafter.icon_versioning_script}

    # we can also execute arbitrary ruby code when configuring our projects, here we rename all our standard icon* to icon_base for versioning script
    icon_rename = proc do |file|
      extension = File.extname(file)
      file_name = File.basename(file, extension)
      File.rename(file, "#{File.dirname(file)}/#{file_name}_base#{extension}")
    end

    Dir['**/Icon.png'].each(&icon_rename)
    Dir['**/Icon@2x.png'].each(&icon_rename)
    Dir['**/Icon-72.png'].each(&icon_rename)
    Dir['**/Icon-72@2x.png'].each(&icon_rename)
  end

  # more targets setup
  with :tests do
    add_option :kiwi do
      pods << 'Kiwi'
      scripts << {:name => 'command line unit tests', :script => Crafter.command_line_test_script}
    end
  end
end
