#!/bin/bash
# Train ACT policy on duck pickup dataset

uv run lerobot-train \
    --dataset.repo_id=duck_pickup_v1 \
    --dataset.video_backend=pyav \
    --policy.type=act \
    --policy.device=mps \
    --output_dir=outputs/train/act_duck_pickup_v1 \
    --job_name=act_duck_pickup_v1 \
    --steps=30000 \
    --save_freq=5000 \
    --wandb.enable=false \
    --policy.push_to_hub=false
