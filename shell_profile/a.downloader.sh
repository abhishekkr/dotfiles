#####
## $ ddl-rss-media https://www.defcon.org/podcast/defcon-20-slides.rss
#####

ddl_rss_media(){
  # ddl-rss-media RSS_LINK {would download all media enclosed at current dir}
  enclosures=`curl -k -s -L $@ | cat | grep enclosure | sed 's/.*enclosure\s*url="//' | sed 's/".*//'`
  for url in `echo $enclosures | xargs -L1`;
  do  
    if [ ! -z $url ];
    then
      filename=`echo $url | sed 's/?.*//' | sed 's/.*\///'`
      echo "Downloading $filename..."
      wget -c -O $filename $url
    fi  
  done
}


# Usage Example: $ ddl-confreaks rubyconf2012 ~/Downloads/
# save it as /etc/profiles/ddl.confreaks.sh
##
## currently it checks for lowest resolution video mostly {640x360} and downloads it

ddl_confreaks(){
  if [ $# -ne 2 ];
  then
    echo 'Failed. Syntax: $> ddl-confreaks EVENT_NAME DOWNLOAD_PATH'
    return
  fi  
  event=$1
  download_path=$2
  event_url="http://confreaks.com/events/$event"
  echo '[*] Getting all talk urls from the Event Page'
  talk_urls=`curl -s $event_url  | grep --color -A1 "title" | grep href | sed 's/.*href="/http:\/\/confreaks\.com/' | sed 's/".*//'`
  echo '[*] Getting all MP4 Video URLs from the Talk Pages'
  for lines in `echo $talk_urls | xargs -L1`;
  do  
    xmp4_url=`echo $lines | xargs curl -s | grep 'application/x-mp4' | tail -1 | sed 's/.*href="//' | sed 's/".*//'`
    if [ ! -z $xmp4_url ];
    then
      echo "Scanned: "$lines
      mp4file=`echo $xmp4_url | sed 's/.*\///' | sed 's/\?.*//'`
      save_as=$download_path"/"$mp4file
      echo "Downloading URL: "$xmp4_url
      echo "to "$save_as"....."
      wget -c -O $save_as $xmp4_url
    fi  
  done
}

# Usage Example: $ ddl-gist 'https://gist.github.com/4137843' ~/Downloads/gists
# save the gist files at that URL in ~/Downloads/gists
##

ddl_gist(){
  if [ $# -ne 2 ];
  then
    echo 'Failed. Syntax: $> ddl-gist GITHUB_GIST_URL DOWNLOAD_PATH'
    return
  fi
  gist_url=$1
  download_path=$2
  echo '[*] Getting all GIST File URLs from '$gist_url
  gists=`curl -ksL -H 'User-Agent: Mozilla/5.0' $gist_url  | grep '<a\ .*href=".*/raw/' | sed 's/.*a\ .*href="//' | sed 's/".*//'`
  echo '[*] Downloading all files'
  for lines in `echo $gists | xargs -L1`;
  do
    if [ ! -z $lines ];
    then
      echo $lines
      gistfile=`echo $lines | sed 's/.*\///'`
      save_as=$download_path"/"$gistfile
      echo "Downloading URL: https://gist.github.com"$lines
      echo "to "$save_as"....."
      wget -c -O $save_as "https://gist.github.com"$lines
    fi
  done
}

# Download HTML converted from provided Markdown, using GitHub API v3
##
md2html(){
  if [[ $# -ne 2 ]]; then
    echo "ERROR.\nSYNTAX: Markdown_To_HTML <markdown-filepath> <dest-html-filepath>"
    return
  fi
  unset _markdown_filepath
  unset _html_filepath
  unset _github_json_filepath
  unset _markdown_for_github

  _markdown_filepath=$1
  _html_filepath=$2
  _github_json_filepath="${_markdown_filepath}.json"

  sed -i 's/$/\\n/g' $_markdown_filepath
  sed -i 's/"/\\"/g' $_markdown_filepath

  echo "{ \"text\" : \"" > $_github_json_filepath
  cat $_markdown_filepath >> $_github_json_filepath
  echo "\" }" >> $_github_json_filepath

  cat $_github_json_filepath | curl -sLk -X POST -d@- https://api.github.com/markdown > $_html_filepath
  rm $_github_json_filepath
  echo "Successful conversion of ${_markdown_filepath} to ${_html_filepath}."
}
