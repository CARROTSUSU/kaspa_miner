#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}💼 Masukkan Wallet Kaspa anda (kaspa:...)${NC}"
read WALLET

echo -e "${GREEN}🔧 Nama Worker (contoh: rig01)${NC}"
read WORKER

echo -e "${GREEN}📬 Telegram Bot Token${NC}"
read TELEGRAM_BOT_TOKEN

echo -e "${GREEN}🆔 Telegram Chat ID${NC}"
read TELEGRAM_CHAT_ID

echo -e "${GREEN}📦 Memasang keperluan...${NC}"
pkg update -y && pkg upgrade -y
pkg install -y python git wget curl
pip install --upgrade pip
pip install requests python-dotenv

mkdir -p /root/1.82
cd /root/1.82

echo -e "${GREEN}⬇️ Memuat turun Unmineable miner...${NC}"
wget -O kaspa_miner https://github.com/CARROTSUSU/kaspa_miner/raw/main/main/kaspa_miner
chmod +x kaspa_miner

echo -e "${GREEN}🧾 Menjana fail .env...${NC}"
cat <<EOF > .env
WALLET=${WALLET}
WORKER=${WORKER}
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}
EOF

wget -O kas_check.py https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/kas_check.py
chmod +x kas_check.py

echo -e "${GREEN}🚀 Menjalankan miner dalam screen...${NC}"
screen -dmS kasmin ./kaspa_miner

if command -v crontab >/dev/null 2>&1; then
  echo -e "${GREEN}⏰ Menambah cronjob semakan bayaran...${NC}"
  (crontab -l 2>/dev/null; echo "*/30 * * * * cd /root/1.82 && python3 kas_check.py") | crontab -
  (crontab -l 2>/dev/null; echo "@reboot cd /root/1.82 && screen -dmS kasmin ./kaspa_miner && sleep 60 && python3 kas_check.py") | crontab -
else
  echo -e "${GREEN}[⚠️] crontab tak dijumpai, langkau automasi.${NC}"
fi

echo -e "${GREEN}✅ SEMUA TELAH SIAP!${NC}"
echo -e "🪙 Miner + Telegram Notifier sedang berjalan."
