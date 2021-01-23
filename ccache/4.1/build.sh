#!/bin/sh -ue

get_package(){
    package_url=$1
    package_name=$(basename ${package_url})
    package_extension=".tar.gz"
    extracted_directory_name=$(basename ${package_name} ${package_extension})

    if [ ! -d ${extracted_directory_name} ] ; then
        if [ ! -f ${package_name} ] ; then
            wget ${package_url}
        fi
        tar xf ${package_name}
    fi
    echo ${extracted_directory_name}
}

current=$(pwd)
build_dir="build"
install_dir="install"
build_zstd_dir="build_zstd"
install_zstd_dir="install_zstd"


if [ -d ${build_dir} ] ; then
    rm -rf ${build_dir}
fi

if [ -d ${install_dir} ] ; then
    rm -rf ${install_dir}
fi
mkdir ${install_dir}

if [ -d ${build_zstd_dir} ] ; then
    rm -rf ${build_zstd_dir}
fi

if [ -d ${install_zstd_dir} ] ; then
    rm -rf ${install_zstd_dir}
fi
mkdir ${install_zstd_dir}

# build zstd
extracted=$(get_package "https://github.com/facebook/zstd/releases/download/v1.4.8/zstd-1.4.8.tar.gz")
cmake -B${build_zstd_dir} \
      -DCMAKE_INSTALL_PREFIX=${install_zstd_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      ${extracted}/build/cmake
cd ${build_zstd_dir}
make -j"$(nproc)"
make install
cd ../

# build ccache
extracted=$(get_package "https://github.com/ccache/ccache/releases/download/v4.1/ccache-4.1.tar.gz")
cmake -B${build_dir} \
      -DCMAKE_INSTALL_PREFIX=${install_dir} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=${install_zstd_dir} \
      -DZSTD_LIBRARY=${install_zstd_dir}/lib/libzstd.a \
      ${extracted}
cd ${build_dir}
make -j"$(nproc)"
make install
cd ../

rm -rf ${build_dir} ${build_zstd_dir} ${install_zstd_dir} zstd-1.4.8* ccache-4.1*
