require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

# to run a single test:
# ruby -I"lib:test" test/test_icle.rb -n test_update_user