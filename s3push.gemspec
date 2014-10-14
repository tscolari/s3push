$:.push File.expand_path("../lib", __FILE__)

require "s3push/version"
Gem::Specification.new do |s|
  s.name        = "s3push"
  s.version     = McDuck::VERSION
  s.authors     = ["Tiago Scolari"]
  s.email       = ["tscolari@gmail.com"]
  s.homepage    = "https://github.com/tscolari/s3ckup"
  s.summary     = "Versioned file backup tool to S3."
  s.description = "Uploads command outputs to s3."
  s.executables = ["s3push"]

  s.files = Dir["{bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "aws-s3"

  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry-nav"
end
