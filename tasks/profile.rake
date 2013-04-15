#profile

namespace :profile do

  desc 'link all shell profiles'
  task :setup do
    profiles = []
    Dir.glob(File.join $repo_root, 'shell_profile', '*.sh').each do |profile|
      destination = File.join '/etc/profile.d', File.basename(profile)
      raise "#{destination} already exists" if exists_but_symlink? destination
      %x{ sudo ln -sf '#{profile}' '#{destination}' }
      raise "#{destination} copy failed." unless File.symlink? destination
      puts "copied: #{destination}"
      profiles << destination
    end
    profiles_source = profiles.collect{|file| "source #{file}"}.join("\n\ \ ")
    func_profiles_source = "a.source(){\n\ \ #{profiles_source}\n}"
    %x{ echo "#{func_profiles_source}" | sudo tee /etc/profile.d/a.profiles.sh }
    puts "run : 'source /etc/profile.d/a.profiles.sh'"

    # zshrc
    raise '~/.zshrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.zshrc')
    ln_sf File.join($repo_root, 'rc', 'zshrc'), File.join(ENV['HOME'], '.zshrc') unless File.symlink?(File.join(ENV['HOME'], '.zshrc')) && ENV['FORCE'].nil?

    # bashrc
    raise '~/.bashrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.bashrc')
    ln_sf File.join($repo_root, 'rc', 'bashrc'), File.join(ENV['HOME'], '.bashrc') unless File.symlink?(File.join(ENV['HOME'], '.bashrc')) && ENV['FORCE'].nil?

    # screenrc 
    raise '~/.screenrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.screenrc')
    ln_sf File.join($repo_root, 'rc', 'screenrc'), File.join(ENV['HOME'], '.screenrc') unless File.symlink?(File.join(ENV['HOME'], '.screenrc')) && ENV['FORCE'].nil?
  end
end
