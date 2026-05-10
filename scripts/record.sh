#!/bin/bash
# Main recording: 30 episodes of "Pick up the yellow duck" task

uv run lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/tty.usbmodem5B3D0430421 \
    --robot.id=my_follower \
    --robot.cameras="{ front: {type: opencv, index_or_path: 1, width: 640, height: 480, fps: 15} }" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/tty.usbmodem5B3D0413001 \
    --teleop.id=my_leader \
    --display_data=true \
    --dataset.repo_id=hirauchi/duck_pickup_v1 \
    --dataset.num_episodes=30 \
    --dataset.single_task="Pick up the yellow duck and put it in the basket" \
    --dataset.push_to_hub=false \
    --dataset.fps=15 \
    --dataset.episode_time_s=20 \
    --dataset.reset_time_s=10 \
    --dataset.video_encoding_batch_size=1 \
    --dataset.vcodec=h264_videotoolbox
