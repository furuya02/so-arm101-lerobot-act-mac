#!/bin/bash
# Evaluate trained ACT model - 1 episode only (records video)

#CHECKPOINT="last"
CHECKPOINT="025000"
EVAL_NAME="eval_${CHECKPOINT}_single_$(date +%Y%m%d_%H%M%S)"

uv run lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/tty.usbmodem5B3D0430421 \
    --robot.id=my_follower \
    --robot.cameras="{ front: {type: opencv, index_or_path: 1, width: 640, height: 480, fps: 15} }" \
    --display_data=true \
    --dataset.repo_id=${EVAL_NAME} \
    --dataset.num_episodes=1 \
    --dataset.single_task="Pick up the yellow duck and put it in the basket" \
    --dataset.push_to_hub=false \
    --dataset.episode_time_s=20 \
    --dataset.reset_time_s=5 \
    --dataset.fps=15 \
    --dataset.video_encoding_batch_size=1 \
    --dataset.vcodec=h264_videotoolbox \
    --policy.path=outputs/train/act_duck_pickup_v1/checkpoints/${CHECKPOINT}/pretrained_model
