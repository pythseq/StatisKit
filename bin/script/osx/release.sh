set -ve

source activate
rm -rf ${CONDA_PREFIX}/conda-bld/

cd ../../conda
conda build llvm-suite \
            python-scons \
            scons-tools \
            libtoolchain \
            python-toolchain \
            boost-suite \
            boost-meta \
            python-parse

cd ../../share/git/ClangLite/bin/conda
set +e
git branch v4.0.1 origin/v4.0.1
git checkout v4.0.1
set -e

conda build libclanglite \
            python-clanglite

cd ../../../AutoWIG/bin/conda
conda build python-autowig

cd ../../../../../bin/conda
conda build statiskit-dev

cd ../script/osx

set +ve