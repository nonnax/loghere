

task default: %w[build]

desc "Bundle install dependencies"
task :bundle do
  sh "bundle install"
end

desc "Build the loghere.gem file"
task :build do
  sh "gem build loghere.gemspec"
end

desc "install loghere-x.x.x.gem"
task install: %w[build] do
  sh "gem install $(ls loghere-*.gem)"
end
