#!/bin/bash

# ========== WARNA ========== 
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# ========== INPUT ==========
echo -e "${GREEN}💼 Masukkan Wallet Kaspa anda (kaspa:...)${NC}"
read WALLET

echo -e "${GREEN}🔧 Nama Worker (contoh: rig01)${NC}"
read WORKER

echo -e "${GREEN}📬 Telegram Bot Token${NC}"
read TELEGRAM_BOT_TOKEN

echo -e "${GREEN}🆔 Telegram Chat ID${NC}"
read TELEGRAM_CHAT_ID

# ========== PASANG KEGUNAAN ==========
echo -e "${GREEN}📦 Memasang keperluan...${NC}"
pkg update -y && pkg upgrade -y
pkg install -y python git wget curl
pip install --upgrade pip
pip install requests python-dotenv

# ========== BUAT FOLDER & DOWNLOAD MINER ==========
mkdir -p /root/1.82
cd /root/1.82

echo -e "${GREEN}⬇️ Memuat turun Unmineable miner...${NC}"
wget -O kaspa_miner https://github.com/CARROTSUSU/kaspa_miner/raw/main/main/kaspa_miner
chmod +x kaspa_miner

# ========== BUAT FILE .env ==========
echo -e "${GREEN}🧾 Menjana fail .env...${NC}"
cat <<EOF > /root/1.82/.env
WALLET=${WALLET}
WORKER=${WORKER}
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_CHAT_ID=${TELEGRAM_CHAT_ID}
EOF

# ========== MUAT TURUN kas_check.py ==========
wget -O kas_check.py https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/kas_check.py
chmod +x kas_check.py

# ========== JALANKAN MINER ==========
echo -e "${GREEN}🚀 Menjalankan miner dalam screen...${NC}"
screen -dmS kasmin ./kaspa_miner

# ========== TAMBAH CRON UNTUK SEMAK BAYARAN (PILIHAN) ==========
if command -v crontab >/dev/null 2>&1; then
  echo -e "${GREEN}⏰ Menambah cronjob semakan bayaran (setiap 30 minit)...${NC}"
  (crontab -l ; echo "*/30 * * * * cd /root/1.82 && python3 kas_check.py") | crontab -
else
  echo -e "${GREEN}[⚠️] crontab tidak dijumpai, langkau semakan automatik.${NC}"
fi

# ========== SELESAI ==========
echo -e "${GREEN}✅ SEMUA TELAH SIAP!${NC}"
echo -e "🪙 Miner + Telegram Notifier sedang berjalan."
