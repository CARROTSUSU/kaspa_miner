#!/bin/bash

echo "🔧 Setup KASPA Miner (Unmineable + kheavyhash) on VPS"

# 1. Update & install keperluan
apt update -y
apt install wget screen unzip -y

# 2. Download lolMiner v1.82 (versi support kheavyhash)
wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82/lolMiner_v1.82_Lin64.tar.gz
tar -xvzf lolMiner_v1.82_Lin64.tar.gz
cd 1.82

# 3. Buat fail mining.sh
cat <<EOF > mining.sh
#!/bin/bash
POOL="stratum+tcp://kheavyhash.auto.unmineable.com:3333"
WALLET="kaspa:qrqws372y3rzj5q9tana7uhp7m3uz2aywc9sntx6xxzy8g07ufz5sdmzdltk0"
WORKER="kasnode_\$(hostname)"
./lolMiner --algo KAS --pool \$POOL --user \$WALLET.\$WORKER#unm
EOF

chmod +x mining.sh

# 4. Jalankan mining dalam screen
screen -dmS kasminer ./mining.sh

echo "✅ Miner is now running in background (screen: kasminer)"
echo "👉 Run 'screen -r kasminer' to check mining progress."
