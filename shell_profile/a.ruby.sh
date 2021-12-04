# profile for ruby

alias rb='ruby'

alias bi='bundle install'
alias be='bundle exec'
alias berb='bundle exec ruby'
alias beirb='bundle exec irb -I .'
alias beirbr='bundle exec irb -I . -r'

alias gem-i="gem install"
alias gem-u="gem uninstall"

alias server.rb='ruby -run -e httpd . -p5000'

bib(){
  bundle config set --local path '.bundle'
  bundle install
}

dot-ruby-version-2-2-3(){
  local RUBY_VERSION_FILE="${PWD}/.ruby-version"
  echo 'ruby-2.2.3' | tee "${RUBY_VERSION_FILE}"
}
