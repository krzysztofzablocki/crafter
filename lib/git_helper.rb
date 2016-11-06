#Copyright (c) 2012-2013 thoughtbot, inc.
#
#    MIT License
#
#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#                                 distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

GITIGNORE_CONTENTS = <<GITIGNORE
# Xcode
#
# gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

## Build generated
build/
DerivedData/

## Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

## Other
*.moved-aside
*.xcuserstate

## Obj-C/Swift specific
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# CocoaPods
#
# We recommend against adding the Pods directory to your .gitignore. However
# you should judge for yourself, the pros and cons are mentioned at:
# https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
#
# Pods/

# Carthage
#
# Add this line if you want to avoid checking in source code from Carthage dependencies.
# Carthage/Checkouts

Carthage/Build

# fastlane
#
# It is recommended to not store the screenshots in the git repo. Instead, use fastlane to re-generate the
# screenshots whenever they are needed.
# For more information about the recommended setup visit:
# https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Gitignore.md

fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output

# Code Injection
#
# After new code Injection tools there's a generated folder /iOSInjectionProject
# https://github.com/johnno1962/injectionforxcode

iOSInjectionProject/

GITIGNORE

GITATTRIBUTES_CONTENTS = '*.pbxproj binary merge=union'

class GitHelper
  def initialize
    if Dir['*.xcodeproj'].empty?
      puts 'Could not find an Xcode project file. You need to run me from a valid project directory.'
      exit
    end
  end

  def generate_files
    generate_gitignore
    generate_gitattributes
  end

  private

  def generate_gitignore
    write_unique_contents_to_file(GITIGNORE_CONTENTS, '.gitignore')
  end

  def generate_gitattributes
    write_unique_contents_to_file(GITATTRIBUTES_CONTENTS, '.gitattributes')
  end

  def write_unique_contents_to_file(contents, filename)
    if File.exists? filename
      current_file_contents = File.read(filename).split("\n")
    else
      current_file_contents = []
    end

    new_contents = current_file_contents + contents.split("\n")

    File.open(filename, 'w') do |file|
      file.write(new_contents.uniq.join("\n"))
    end
  end
end
