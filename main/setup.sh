#!/bin/bash

echo "🔧 Setup Mining + Telegram Notifier"

apt update -y
apt install wget screen unzip python3 -y

cd /root

# Muat turun lolMiner
wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82/lolMiner_v1.82_Lin64.tar.gz
tar -xvzf lolMiner_v1.82_Lin64.tar.gz
cd 1.82

# Buat mining.sh
cat <<EOF > mining.sh
#!/bin/bash
POOL="stratum+tcp://kheavyhash.auto.unmineable.com:3333"
WALLET="kaspa:qrqws372y3rzj5q9tana7uhp7m3uz2aywc9sntx6xxzy8g07ufz5sdmzdltk0"
WORKER="kasnode_\$(hostname)"
./lolMiner --algo KAS --pool \$POOL --user \$WALLET.\$WORKER#unm
EOF

chmod +x mining.sh
screen -dmS kasminer ./mining.sh

# Tambah cron mining auto-reboot
(crontab -l 2>/dev/null; echo "@reboot sleep 10 && screen -dmS kasminer /root/1.82/mining.sh") | crontab -

# Muat turun skrip check.py + config
wget -O /root/1.82/kas_check.py https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/kas_check.py
wget -O /root/1.82/config.json https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/config.json

# Jalankan kas_check dalam screen
screen -dmS kascheck python3 /root/1.82/kas_check.py

# Tambah auto run kas_check selepas reboot
(crontab -l 2>/dev/null; echo "@reboot sleep 15 && screen -dmS kascheck python3 /root/1.82/kas_check.py") | crontab -

echo "✅ SEMUA TELAH SIAP!"
echo "📡 Miner + Telegram Notifier sedang berjalan."
