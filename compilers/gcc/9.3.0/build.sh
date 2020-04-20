#!/bin/bash -uex

current=$(pwd)
build_path="${current}/build"
install_path="${current}/install"

if [ -d ${build_path} ] ; then
    rm -rf ${build_path}
fi
mkdir ${build_path}

if [ -d ${install_path} ] ; then
    rm -rf ${install_path}
fi
mkdir ${install_path}

package_url=http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-9.3.0/gcc-9.3.0.tar.xz
package_name=$(basename ${package_url})
package_extension=".tar.xz"
extracted_directory_name=$(basename ${package_name} ${package_extension})

if [ ! -d ${extracted_directory_name} ] ; then
    if [ ! -f ${package_name} ] ; then
        wget ${package_url}
    fi
    tar xf ${package_name}
fi

pushd ${extracted_directory_name}
./contrib/download_prerequisites
popd

pushd ${build_path}
../${extracted_directory_name}/configure --prefix=${install_path} \
                                         --enable-languages=c,c++,fortran \
                                         --disable-multilib \
                                         --disable-bootstrap
make -j2
make install

popd
