SUDO = 'sudo' unless ENV['SUDOLESS']

desc "Install #{GEM_NAME}"
task :install => :gem do
  sh %{#{SUDO} gem install --local pkg/#{GEM_NAME}-#{GEM_VERSION}.gem}
end


desc "Build the gem for #{GEM_NAME}"
task :gem do
  sh %{gem build #{GEM_NAME}.gemspec; mkdir -p pkg; mv #{GEM_NAME}-#{GEM_VERSION}.gem pkg/}
end