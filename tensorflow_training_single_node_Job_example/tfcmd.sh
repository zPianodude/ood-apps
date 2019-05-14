#!/bin/bash

APP=nvcnn.py
LDIR=$(pwd)/log

set +x

# Train using standard gpu enabled TF app in container
python ${APP} --model=resnet50 --data_dir=/data --batch_size=32 --num_gpus=8 --fp16 \
   --num_epochs=120 --display_every=50 --log_dir=${LDIR} --fp16
