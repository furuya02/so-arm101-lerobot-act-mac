# so-arm101-lerobot-act-mac

**SO-ARM101** + **LeRobot ACT** で「アヒル掴み」タスクを模倣学習します。データ収集・学習・評価をすべて Mac (Apple Silicon / MPS) で完結させます。

ブログ記事「**ロボットアーム(SO-ARM101)で、アヒルを掴んでみました〜模倣学習〜**」で紹介したスクリプトを公開するためのリポジトリです。

- ロボット: SO-ARM101 (Leader + Follower)
- カメラ: ロジクール C920n (front 視点)
- ホスト: macOS / Apple Silicon (M2 系列)
- フレームワーク: LeRobot v0.5.1 / ACT (Action Chunking Transformer)
- デバイス: MPS (Apple Silicon GPU)

> English README: [README.md](README.md)

---

## リポジトリ構成

```
so-arm101-lerobot-act-mac/
├── README.md            # 英語版
├── README.ja.md         # 日本語版（このファイル）
├── LICENSE              # MIT License
├── .gitignore
└── scripts/
    ├── preview_camera.py    # USB カメラのプレビュー確認
    ├── record.sh            # テレオペでデータ収集（30 エピソード）
    ├── train_act.sh         # ACT モデルを MPS で学習（30,000 step）
    └── eval_act.sh          # 学習済みポリシーで自律推論
```

---

## セットアップ

### 1. クローン

```bash
git clone https://github.com/<your-account>/so-arm101-lerobot-act-mac.git
cd so-arm101-lerobot-act-mac
```

### 2. uv で Python ワークスペースを初期化

本プロジェクトでは npm / pip ではなく [uv](https://docs.astral.sh/uv/) を使用します。

```bash
uv init --python 3.12 .
uv add "lerobot[feetech]>=0.5.1" matplotlib
```

### 3. 環境確認

```bash
# LeRobot
uv run lerobot-info

# Feetech サーボ SDK
uv run python -c "import scservo_sdk; print('OK')"

# MPS (Apple Silicon GPU)
uv run python -c "import torch; print(f'MPS available: {torch.backends.mps.is_available()}')"
```

`MPS available: True` が出れば OK です。

### 4. USB ポートの特定

```bash
uv run lerobot-find-port
```

Leader / Follower の device パス（例: `/dev/tty.usbmodem5B3D0430111` / `/dev/tty.usbmodem5B3D0430421`）を確認し、`scripts/` 配下のスクリプトを書き換えてください。

---

## 使い方

### データ収集（テレオペ）

「Pick up the yellow duck and put it in the basket」（黄色いアヒルをバスケットに入れる）操作を 30 エピソード収録します。

```bash
bash scripts/record.sh
```

### 学習 (Mac MPS)

ACT モデルを 30,000 ステップ学習します。5,000 ステップごとにチェックポイントを保存します。

```bash
caffeinate -d -i bash scripts/train_act.sh
```

`caffeinate -d -i` は約 6.5 時間の学習中に Mac がスリープしないようにするためのおまじないです。

### GPU 利用状況の確認（任意）

学習中に別ターミナルで以下を実行します。

```bash
sudo powermetrics --samplers gpu_power -i 1000
```

GPU active residency が ~99%、GPU 周波数が最高値（M2 系列なら 1398 MHz）に張り付いていれば、MPS が完全に GPU を使い切っている状態です。

### 評価（自律推論）

`scripts/eval_act.sh` 内の `CHECKPOINT` 変数で評価したい step を指定してください（デフォルトは `025000`）。今回の実測では 20K / 25K のチェックポイントが最も良い性能でした。

```bash
bash scripts/eval_act.sh
```

---

## 実測結果（参考）

| Step | Loss | 実機成功率 |
|---|---|---|
| 5,000 | 0.327 | 0% |
| 10,000 | 0.163 | 60% |
| 15,000 | 0.120 | 80% |
| **20,000** | **0.095** | **100%** |
| **25,000** | **0.085** | **100%** |
| 30,000 | 0.072 | 90%（過学習） |

学習時間: M2 Mac で約 6 時間 40 分。電気代の概算: 約 5〜10 円。

---

## ライセンス

[MIT](LICENSE)

## 謝辞

- [LeRobot](https://github.com/huggingface/lerobot)（Hugging Face）
- [SO-ARM101](https://github.com/TheRobotStudio/SO-ARM100)（The Robot Studio）
- [ACT (Action Chunking Transformer)](https://tonyzhaozh.github.io/aloha/)
