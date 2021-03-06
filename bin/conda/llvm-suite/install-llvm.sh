## Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ##
##                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ##
## Copyright [2015-2016] UMR AGAP CIRAD, EPI Virtual Plants Inria        ##
##                                                                       ##
## This file is part of the StatisKit project. More information can be   ##
## found at                                                              ##
##                                                                       ##
##     http://statiskit.rtfd.io                                          ##
##                                                                       ##
## The Apache Software Foundation (ASF) licenses this file to you under  ##
## the Apache License, Version 2.0 (the "License"); you may not use this ##
## file except in compliance with the License. You should have received  ##
## a copy of the Apache License, Version 2.0 along with this file; see   ##
## the file LICENSE. If not, you may obtain a copy of the License at     ##
##                                                                       ##
##     http://www.apache.org/licenses/LICENSE-2.0                        ##
##                                                                       ##
## Unless required by applicable law or agreed to in writing, software   ##
## distributed under the License is distributed on an "AS IS" BASIS,     ##
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ##
## mplied. See the License for the specific language governing           ##
## permissions and limitations under the License.                        ##

#!/bin/bash

. activate "${PREFIX}"
PATH=${PREFIX}/cmake-bin/bin:${PATH}
cd "${SRC_DIR}"

DEST="${PWD}"/install-llvm
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd llvm_build_final
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  # Remove bits that are packaged in llvm-lto-tapi
  # (which llvm depends upon)
  rm include/llvm-c/lto.h
  rm lib/libLTO.dylib
  cp -Rf * "${PREFIX}"
  mkdir -p "${PREFIX}"/share/llvm/cmake/{modules,platforms}
  cp -Rf "${SRC_DIR}"/cmake/modules/*.cmake "${PREFIX}"/share/llvm/cmake/modules/
  cp -Rf "${SRC_DIR}"/cmake/platforms/*.cmake "${PREFIX}"/share/llvm/cmake/platforms/
popd
