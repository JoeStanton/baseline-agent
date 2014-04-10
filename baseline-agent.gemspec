Gem::Specification.new do |s|
  s.name               = "baseline-agent"
  s.version            = "0.0.1"
  s.licenses           = ['MIT']
  s.executables        << "baseline-agent"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Stanton"]
  s.date = %q{2014-02-22}
  s.description = %q{CLI Agent interface to baseline}
  s.email = %q{joestanton100@gmail.com}
  s.files = `git ls-files`.split "\n"
  s.homepage = %q{http://rubygems.org/gems/baseline-agent}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{baseline-agent!}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
