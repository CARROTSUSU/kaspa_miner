#!/bin/bash

echo "🛠️ Memasang keperluan asas..."

# 1. Install cronie if not available
if ! command -v crontab >/dev/null 2>&1; then
    echo "[⚠️] Crontab not found. Installing cronie..."
    pkg update -y && pkg install cronie -y
fi

# 2. Buat direktori
mkdir -p /root/1.82 && cd /root/1.82

# 3. Muat turun dan ekstrak lolMiner
echo "⬇️ Muat turun lolMiner..."
wget -q https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82/lolMiner_v1.82_Lin64.tar.gz
tar -xvf lolMiner_v1.82_Lin64.tar.gz >/dev/null
cd 1.82

# 4. Auto cipta mining.sh
echo "⚙️ Menjana mining.sh..."
cat <<EOF > mining.sh
#!/bin/bash
POOL="stratum+tcp://kheavyhash.auto.unmineable.com:3333"
WALLET="kaspa:qrqws372y3rzj5q9tana7uhp7m3uz2aywc9sntx6xxzy8g07ufz5sdmzdltk0"
WORKER="kasnode_\$(hostname)"
./lolMiner --algo KAS --pool \$POOL --user \$WALLET.\$WORKER#unm
EOF
chmod +x mining.sh

# 5. Start miner dalam screen
echo "📟 Memulakan lolMiner dalam screen..."
screen -dmS kasminer ./mining.sh

# 6. Muat turun kas_check.py dan config.json
echo "📦 Muat turun Telegram payout checker..."
wget -qO kas_check.py https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/kas_check.py
wget -qO config.json https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/config.json

# 7. Tambah ke crontab untuk auto-run selepas reboot
echo "🧠 Setup crontab..."
(crontab -l 2>/dev/null; echo "@reboot cd /root/1.82/1.82 && screen -dmS kasminer ./mining.sh") | crontab -

# 8. Mula kas_check.py (optional)
echo "🚀 Menjalankan Telegram Notifier..."
nohup python3 kas_check.py >/dev/null 2>&1 &

echo "✅ SEMUA TELAH SIAP!"
echo "🔋 Miner + Telegram Notifier sedang berjalan."
