#!/bin/bash
# LigUnity inference script
# This script is called by predict.py and runs the actual model inference

results_path="${RESULTS_PATH:-./test}"  # Read from environment variable, default to ./test
batch_size="${BATCH_SIZE:-128}"  # Read from environment variable, default to 128
weight_path="${WEIGHT_PATH:-checkpoint.pt}"  # Read from environment variable, default to checkpoint.pt

CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0}" python3 ./unimol/test.py --user-dir ./unimol "./test_datasets" --valid-subset test \
       --results-path $results_path \
       --num-workers 0 --batch-size $batch_size \
       --task test_task --loss rank_softmax --arch pocket_ranking \
       --fp16 --fp16-init-scale 4 --fp16-scale-window 256 --seed 1 \
       --path $weight_path \
       --log-interval 100 --log-format simple \
       --max-pocket-atoms 511

