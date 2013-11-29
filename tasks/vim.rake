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

    puts "Vundle up all Vim add-ons"
    vim_bundle = File.join($repo_root, 'vim', 'bundle')
    Dir.mkdir(vim_bundle) unless File.exists?(vim_bundle)
    vim_bundle_vundle = File.join(vim_bundle, 'vundle')
    unless File.exists?(vim_bundle_vundle)
      %x{ cd '#{vim_bundle}' ; git clone https://github.com/gmarik/vundle.git ; cd - }
    else
      %x{ cd '#{vim_bundle_vundle}/' ; git pull ; cd - }
    end
    %x{ vim +BundleInstall +qall}
  end

end
