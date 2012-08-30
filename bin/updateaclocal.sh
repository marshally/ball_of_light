eval `brew --config | grep HOMEBREW_PREFIX | sed 's/: /=/'`
sudo bash -c 'echo '$HOMEBREW_PREFIX/share/aclocal' >> `aclocal --print-ac-dir`/dirlist'
