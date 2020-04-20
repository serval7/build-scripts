#!/bin/bash -ue

get_package(){
    package_url=$1
    package_name=$(basename ${package_url})
    package_extension=".tar.xz"
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

extracted=$(get_package "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-project-10.0.0.tar.xz")

pushd ${build_path}
cmake -G "Ninja"                             \
      -DCMAKE_INSTALL_PREFIX=${install_path} \
      -DCMAKE_C_COMPILER="gcc"               \
      -DCMAKE_CXX_COMPILER="g++"             \
      -DLLVM_PARALLEL_LINK_JOBS="1"          \
      -DCMAKE_BUILD_TYPE="Release"           \
      -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt;libc;libclc;libcxx;libcxxabi;libunwind;lld;lldb;openmp;parallel-libs;polly;pstl" \
      ../${extracted}/llvm
ninja 2>&1 | tee log.txt
ninja install
popd

