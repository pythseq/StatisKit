set +x

UPLOAD_TARGETS="python-parse python-pkgtk"

if [[ -z $ANACONDA_USERNAME ]]; then
  read -p "Username: " ANACONDA_USERNAME;
else
  echo "Username: "$ANACONDA_USERNAME;
fi

if [[ -z $ANACONDA_PASSWORD ]];
  read -s -p %ANACONDA_USERNAME"'s password: " ANACONDA_PASSWORD;
else
  echo $ANACONDA_USERNAME"'s password: [secure]";
fi

ANACONDA_FLAGS="-c conda-forge "$ANACONDA_FLAGS
if [[ -z $ANACONDA_LABEL ]]; then
    ANACONDA_CHANNEL="statiskit";
else
    echo "Using anaconda label: "$ANACONDA_LABEL;
    ANACONDA_CHANNEL="statiskit/label/"$ANACONDA_LABEL;
    ANACONDA_FLAGS="-c statiskit "$ANACONDA_FLAGS;
fi

set -x

conda install -n root anaconda-client
if [ $? -ne 0 ]; then
  exit 1;
fi

set +x

anaconda login --username "$ANACONDA_USERNAME" --password "$ANACONDA_PASSWORD"
if [ $? -ne 0 ]; then
  exit 1;
fi

set -x

git clone https://gist.github.com/c491cb08d570beeba2c417826a50a9c3.git toolchain
if [ $? -ne 0 ]; then
    anaconda logout;
    exit 1;
fi
cd toolchain
source config.sh
if [ $? -ne 0 ]; then
    cd ..
    anaconda logout;
    rm -rf toolchain;
    exit 1;
fi
cd ..
rm -rf toolchain

for UPLOAD_TARGET in $UPLOAD_TARGETS; do
  UPLOAD_FILE=`conda build $UPLOAD_TARGET -c $ANACONDA_CHANNEL $ANACONDA_FLAGS --output`
  anaconda upload ${UPLOAD_FILE%%} --user $ANACONDA_CHANNEL
  if [ $? -ne 0 ]; then
    echo "upload failed";
  fi
done

anaconda logout