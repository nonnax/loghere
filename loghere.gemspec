
Gem::Specification.new do |s|
  s.name = 'loghere'
  s.version = '0.0.1'
  s.date = '2023-01-15'
  s.summary = "loghere makes logs per directory into a global file"
  s.authors = ["xxanon"]
  s.email = "ironald@gmail.com"
  s.files = `git ls-files`.split("\n") - %w[bin misc]
  s.executables += `git ls-files bin`.split("\n").map{|e| File.basename(e)}
  s.homepage = "https://github.com/nonnax/loghere.git"
  s.license = "GPL-3.0"
end

