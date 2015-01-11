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
# OS X Finder
.DS_Store

# Xcode per-user config
*.mode1
*.mode1v3
*.mode2v3
*.perspective
*.perspectivev3
*.pbxuser
xcuserdata
*.xccheckout

# Build products
build/
*.o
*.LinkFileList
*.hmap

# Automatic backup files
*~.nib/
*.swp
*~
*.dat
*.dep

# AppCode
.idea

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
