#vim

require 'fileutils'

namespace :vim do

  desc 'setup vim configurations'
  task :setup do
    begin
      raise '~/.vimrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.vimrc')
      ln_sf File.join($repo_root, 'rc', 'vimrc'), File.join(ENV['HOME'], '.vimrc') unless File.symlink?(File.join(ENV['HOME'], '.vimrc')) && ENV['FORCE'].nil?
    rescue Exception => e
      puts e.message
    end

    begin
      raise '~/.gvimrc already exists' if exists_but_symlink? File.join(ENV['HOME'], '.gvimrc')
      ln_sf File.join($repo_root, 'rc', 'vimrc'), File.join(ENV['HOME'], '.gvimrc') unless File.symlink?(File.join(ENV['HOME'], '.gvimrc')) && ENV['FORCE'].nil?
    rescue Exception => e
      puts e.message
    end

    begin
      raise '~/.vim already exists' if exists_but_symlink? File.join(ENV['HOME'], '.vim')
      ln_sf File.join($repo_root, 'vim'), File.join(ENV['HOME'], '.vim') unless File.symlink?(File.join(ENV['HOME'], '.vim')) && ENV['FORCE'].nil?
    rescue Exception => e
      puts e.message
    end

    puts "Sync up all Vim add-ons {pathogen,}"
    vim_bundle = File.join($repo_root, 'vim', 'bundle')
    Dir.mkdir(vim_bundle) unless File.exists?(vim_bundle)
    tasks_shell_path = File.join($repo_root, 'tasks', 'shell')
    puts %x{ bash #{tasks_shell_path}/vim-pathogen-plugin-sync.sh }
  end

end
