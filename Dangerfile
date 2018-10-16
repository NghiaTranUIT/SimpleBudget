# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
has_app_changes = !git.modified_files.grep(/Sources/).empty?

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR, try to keep changes smaller if you can") if git.lines_of_code > 500

# Added (or removed) library files need to be added (or removed) from the
# Carthage Xcode project to avoid breaking things for our Carthage users.
added_swift_library_files = !(git.added_files.grep(/Sources.*\.swift/).empty?)
deleted_swift_library_files = !(git.deleted_files.grep(/Sources.*\.swift/).empty?)
modified_carthage_xcode_project = !(git.modified_files.grep(/StatsdClient\.xcodeproj/).empty?)
if (added_swift_library_files || deleted_swift_library_files) && !modified_carthage_xcode_project
  fail("Added or removed library files require the Carthage Xcode project to be updated. See the Readme")
end

# Warn when library files has been updated but not tests.
tests_updated = !git.modified_files.grep(/Tests/).empty?
if has_app_changes && !tests_updated
  warn("The library files were changed, but the tests remained unmodified. Consider updating or adding to the tests to match the library changes.")
end

# Run SwiftLint
swiftlint.lint_files inline_mode: true
