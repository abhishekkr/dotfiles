#!rake
#

require 'rubygems'
require 'rake'

$repo_root = File.expand_path File.dirname(__FILE__)

FileList['tasks/*.rake'].each{|rake| import rake}

def exists_but_symlink?(path)
  return true if File.exists?(path) && !File.symlink?(path)
  false
end

desc 'set it all'
task :default => ["git:setup", "vim:setup", "profile:setup", "runcom:setup"]
