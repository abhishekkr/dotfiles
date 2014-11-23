#runcom ~ rc

namespace :runcom do

  desc 'link all rc files'
  task :setup do

    home_rcs = ["zshrc", "bashrc", "screenrc", "curlrc", "gemrc", "rvmrc", "irbrc", "wgetrc", "npmrc"]
    home_rcs.each do |rcfile|
      target_rc_path = File.join(ENV['HOME'], ".#{rcfile}")
      raise "#{target_rc_path} already exists" if exists_but_symlink? target_rc_path
      ln_sf(File.join($repo_root, 'rc', rcfile), target_rc_path) unless File.symlink?(target_rc_path) && ENV['FORCE'].nil?
      puts "Linking #{rcfile} to #{target_rc_path}"
      raise "Failed to stat path: #{target_rc_path}" if !File.exists?(target_rc_path)
    end
  end
end

