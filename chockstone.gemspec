Gem::Specification.new do |s|
  s.name        = %q{chockstone}
  s.version     = %q{0.3.3}
  s.summary     = ""
  s.description = "Wrapper for Chockstone API requests"
  s.authors     = ["Thomas Mulloy"]
  s.email       = %q{twmulloy@gmail.com}
  s.files       = [
    "lib/chockstone/connection.rb",
    "lib/chockstone.rb",
    ".gitignore",
    "chockstone.gemspec",
    "Gemfile",
    "Rakefile",
    "README.rdoc"
  ]
  s.homepage = %q{https://github.com/teeem/chockstone-api}
  s.test_files = [
    "test/test_icle.rb"
  ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ['lib']

  s.add_dependency('libxml-ruby')
end