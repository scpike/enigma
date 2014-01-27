require "bundler/gem_tasks"
require 'rake/testtask'

task :gendoc do
  system "yardoc"
  system "yard stats --list-undoc"
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**_test.rb']
  t.verbose = false
  t.warning = true
end

task :rubocop do |t|
  sh 'rubocop'
end

task :build => :gendoc do
  system "gem build enigma.gemspec"
end

task :release => :build do
  system "gem push enigma-#{Enigma::VERSION}.gem"
end

task default: [:test, :rubocop]