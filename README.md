# so-arm101-lerobot-act-mac

Imitation learning of a duck pickup task with **SO-ARM101** + **LeRobot ACT**, trained and evaluated entirely on a Mac (Apple Silicon / MPS).

This repository hosts the scripts referenced in the blog post **"ロボットアーム(SO-ARM101)で、アヒルを掴んでみました〜模倣学習〜"**.

- Robot: SO-ARM101 (Leader + Follower)
- Camera: Logicool C920n (front view)
- Host: macOS on Apple Silicon (M2 series)
- Framework: LeRobot v0.5.1 / ACT (Action Chunking Transformer)
- Device: MPS (Apple Silicon GPU)

> A Japanese version of this README is available at [README.ja.md](README.ja.md).

---

## Repository layout

```
so-arm101-lerobot-act-mac/
├── README.md          # This file (English)
├── README.ja.md       # Japanese version
├── LICENSE            # MIT License
├── .gitignore
└── scripts/           # Shell / Python scripts for record / train / eval
```

---

## Setup

### 1. Clone

```bash
git clone https://github.com/<your-account>/so-arm101-lerobot-act-mac.git
cd so-arm101-lerobot-act-mac
```

### 2. Initialize Python workspace with uv

This project uses [uv](https://docs.astral.sh/uv/) (not pip / npm).

```bash
uv init --python 3.12 .
uv add "lerobot[feetech]>=0.5.1" matplotlib
```

### 3. Verify the environment

```bash
# LeRobot
uv run lerobot-info

# Feetech servo SDK
uv run python -c "import scservo_sdk; print('OK')"

# MPS (Apple Silicon GPU)
uv run python -c "import torch; print(f'MPS available: {torch.backends.mps.is_available()}')"
```

Expected: `MPS available: True`.

### 4. Identify USB ports

```bash
uv run lerobot-find-port
```

Note the device paths for the Leader and Follower (e.g. `/dev/tty.usbmodem5B3D0430111` / `/dev/tty.usbmodem5B3D0430421`) and update them in the scripts under `scripts/`.

---

## Usage

### Data collection (teleoperation)

Record 30 episodes of "Pick up the yellow duck and put it in the basket".

```bash
bash scripts/record.sh
```

### Training (Mac MPS)

Train the ACT policy for 30,000 steps. Checkpoints are saved every 5,000 steps.

```bash
caffeinate -d -i bash scripts/train_act.sh
```

`caffeinate -d -i` prevents the Mac from sleeping during the ~6.5 h training run.

### Monitor GPU usage (optional)

In a separate terminal during training:

```bash
sudo powermetrics --samplers gpu_power -i 1000
```

You should see GPU active residency at ~99% and the GPU running at the maximum frequency (1398 MHz on M2).

### Evaluation (autonomous inference)

Edit the `CHECKPOINT` variable inside `scripts/eval_act.sh` to choose the step to evaluate (defaults to `025000`). The 20K / 25K checkpoints performed best in our run.

```bash
bash scripts/eval_act.sh
```

---

## Results (reference)

| Step | Loss | Real-world success rate |
|---|---|---|
| 5,000 | 0.327 | 0% |
| 10,000 | 0.163 | 60% |
| 15,000 | 0.120 | 80% |
| **20,000** | **0.095** | **100%** |
| **25,000** | **0.085** | **100%** |
| 30,000 | 0.072 | 90% (overfitting) |

Training time: ~6h 40m on M2 Mac. Estimated electricity cost: ~5–10 JPY.

---

## License

[MIT](LICENSE)

## Acknowledgements

- [LeRobot](https://github.com/huggingface/lerobot) by Hugging Face
- [SO-ARM101](https://github.com/TheRobotStudio/SO-ARM100) by The Robot Studio
- [ACT (Action Chunking Transformer)](https://tonyzhaozh.github.io/aloha/)
