namespace :bin do

  task :setup do
    bin_dir = File.join ENV['HOME'], 'bin'
    Dir.mkdir bin_dir unless File.directory? bin_dir
    [
      "http://stedolan.github.io/jq/download/linux64/jq"
    ].each do |url|
      fylname = File.basename url
      %x{ cd #{bin_dir} ; wget -c #{url} ; chmod +x #{fylname} ; cd - }
      puts "placed: #{fylname} at #{bin_dir}"
    end
  end
end
