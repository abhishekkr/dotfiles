#vim

require 'fileutils'

namespace :vim do

  desc 'setup vim configurations'
  task :setup do
    raise '~/.vimrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.vimrc')
    ln_sf File.join($repo_root, 'vimrc'), File.join(ENV['HOME'], '.vimrc') unless File.symlink?(File.join(ENV['HOME'], '.vimrc')) && ENV['FORCE'].nil?

    raise '~/.gvimrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.gvimrc')
    ln_sf File.join($repo_root, 'vimrc'), File.join(ENV['HOME'], '.gvimrc') unless File.symlink?(File.join(ENV['HOME'], '.gvimrc')) && ENV['FORCE'].nil?

    raise '~/.vim already exists' if exists_but_symlink? File.join(ENV['HOME'], '.vim')
    ln_sf File.join($repo_root, 'vim'), File.join(ENV['HOME'], '.vim') unless File.symlink?(File.join(ENV['HOME'], '.vim')) && ENV['FORCE'].nil?
  end

end
