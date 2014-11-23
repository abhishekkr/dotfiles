#profile

namespace :profile do

  desc 'link all shell profiles'
  task :setup do
    mkdir_p File.join(ENV['HOME'], 'cache', 'pip') # used in a.python.sh profile

    profiles = []
    # projectrc ## git-ignored
    projectrc = File.join $repo_root, 'shell_profile', 'nda.project.sh'
    File.write(projectrc, "#!/bin/bash\n#non git config") unless File.exists? projectrc
    Dir.glob(File.join $repo_root, 'shell_profile', '*.sh').each do |profile|
      destination = File.join '/etc/profile.d', File.basename(profile)
      raise "#{destination} already exists" if exists_but_symlink? destination
      %x{ sudo ln -sf '#{profile}' '#{destination}' }
      raise "#{destination} copy failed." unless File.symlink? destination
      puts "copied: #{destination}"
      profiles << destination
    end
    profiles << '/etc/profile.d/a.profiles.sh'
    profiles_source = profiles.collect{|file| "source #{file}"}.join("\n\ \ ")
    func_profiles_source = "re_source(){\n\ \ #{profiles_source}\n}"
    %x{ echo "#{func_profiles_source}" | sudo tee /etc/profile.d/a.profiles.sh }
    puts "run : 'source /etc/profile.d/a.profiles.sh'"
  end
end
