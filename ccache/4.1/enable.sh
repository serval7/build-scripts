#!/bin/sh -uex

sym_bin="~/symbin"

if [ -d ${sym_bin} ] ; then
    if which ccache > /dev/null ; then
        ccache_path=$(which ccache)
        ln -fs ${ccache_path} ${sym_bin}/gcc
        ln -fs ${ccache_path} ${sym_bin}/g++
        export PATH=${sym_bin}:${PATH}
    fi
fi
