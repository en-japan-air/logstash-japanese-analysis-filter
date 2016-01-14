#!/usr/bin/env bash
if [[ ! -f "$HOME/mecab/lib/libmecab.so" ]]; then
  if [[ ! -f $HOME/mecab-0.996/Makefile ]]; then
    wget -c http://mecab.googlecode.com/files/mecab-0.996.tar.gz && tar xf mecab-0.996.tar.gz -C $HOME
  fi
  pushd $HOME/mecab-0.996 && ./configure --enable-utf8-only --prefix="$HOME/mecab" && make && make install && popd
  if [[ ! -f $HOME/mecab-ipadic-2.7.0-20070801/Makefile ]]; then
    wget -c http://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz && tar xf mecab-ipadic-2.7.0-20070801.tar.gz -C $HOME
  fi
  pushd $HOME/mecab-ipadic-2.7.0-20070801 && ./configure --with-charset=utf8 --prefix="$HOME/mecab" --exec-prefix="$HOME/mecab" --with-mecab-config="$HOME/mecab/bin/mecab-config" && make && make install && popd
  if [[ ! -f $HOME/mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd ]]; then
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git $HOME/mecab-ipadic-neologd
  fi
  pushd $HOME/mecab-ipadic-neologd && PATH=$HOME/mecab/bin:$PATH ./bin/install-mecab-ipadic-neologd -u -p $HOME/mecab/lib/mecab/dic/mecab-ipadic-neologd -y && popd
fi
