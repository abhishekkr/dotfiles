#profile for elxir

iex-ls(){
  [[ ! -f 'mix.exs' ]] && \
    echo "err, this doesn't seem like a *mix* managed elixir project... bye" && \
    return

  echo "[+] modules"
  grep -r '^\s*defmodule\s' lib | sed 's/:\s*defmodule/ =>/' | sed 's/\s\s*do.*//' | xargs -I{} echo "    "{}

  echo
  echo "[+] migrations"
  ls -1 priv/repo/migrations/ | xargs -I{} echo "    "{}

  echo
  [[ $(ls -1 _build/) == "" ]] && \
    echo "[+] no builds ran yet" && \
    return
  echo "[+] builds:"
  ls -1 _build/ | xargs -I{} echo "    "{}
}
