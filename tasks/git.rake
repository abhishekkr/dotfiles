#git

namespace :git do

  desc 'place git config'
  task :setup do
    raise '~/.gitconfig already exists' if exists_but_symlink? File.join(ENV['HOME'], '.gitconfig')
    ln_sf File.join($repo_root, 'gitconfig'), File.join(ENV['HOME'], '.gitconfig') unless File.symlink?(File.join(ENV['HOME'], '.gitconfig')) && ENV['FORCE'].nil?
  end
end
