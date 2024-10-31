#!/usr/bin/env bash

gguf_file=$1
if [ $# -ge 2 ]
then
    model_name=$2
else
    model_name=$(basename $gguf_file | cut -d'.' -f 1)
fi
echo "Model Name: $model_name"

# Build (NOTE: First build may fail due to the need to download tools)
make -j || make -j

# Install the built binaries
make install PREFIX=/usr/local

# Make a temp dir to work in
start_dir=$PWD
temp_dir=$(mktemp -d)
cd $temp_dir

# Copy over the model and base binary
echo "Copying source materials..."
cp $gguf_file .
cp $(which llamafile) $model_name.llamafile

# Make the .args file
echo "Making .args file..."
echo "-m
$(basename $gguf_file)
--host
0.0.0.0
-ngl
9999
..." > .args

# Pack it all together
echo "Packing with zipalign..."
zipalign -j0 $model_name.llamafile $(basename $gguf_file) .args

# Move it back to the root dir
mv $model_name.llamafile $start_dir/
echo "DONE"