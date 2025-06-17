#!/bin/bash

echo "🔧 Memasang modul Python..."
pip install --upgrade pip
pip install requests python-dotenv


# ========== GUNA .env UNTUK KONFIGURASI ==========
ENV_FILE="/root/1.82/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "🔧 Membina .env default..."
    mkdir -p /root/1.82
    cat <<EOF > "$ENV_FILE"
WALLET=kaspa:MASUKKAN_WALLET_ANDA
WORKER=kasrig01
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=
EOF
    echo "📄 Fail .env dibina di $ENV_FILE. Sila kemaskini dahulu."
    nano $ENV_FILE
fi

# Source .env
source "$ENV_FILE"

# ========== SEMAK CRONTAB ==========
if ! command -v crontab &>/dev/null; then
  pkg update -y && pkg install cronie -y
fi

# ========== PASANG screen ==========
if ! command -v screen &>/dev/null; then
  pkg install screen -y
fi

# ========== BUAT DIREKTORI ==========
mkdir -p /root/1.82 && cd /root/1.82

# ========== MUAT TURUN lolMiner ==========
echo "⬇️ Muat turun lolMiner..."
wget -q https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82/lolMiner_v1.82_Lin64.tar.gz

# ========== EKSTRAK ==========
tar -xzf lolMiner_v1.82_Lin64.tar.gz && mv 1.82 lolMiner

# ========== CIPTA mining.sh ==========
cat <<EOF > /root/1.82/mining.sh
#!/bin/bash
cd /root/1.82/lolMiner
./lolMiner --algo KASPA --pool kas.unmineable.com:3333 \
--user ${WALLET}.${WORKER} \
--pass x
EOF
chmod +x /root/1.82/mining.sh

# ========== RUN DENGAN screen ==========
screen -dmS kasminer bash /root/1.82/mining.sh

# ========== MUAT TURUN kas_check.py ==========
wget -q -O /root/1.82/kas_check.py https://raw.githubusercontent.com/CARROTSUSU/kaspa_miner/main/main/kas_check.py
chmod +x /root/1.82/kas_check.py

# ========== CIPTA config.json UNTUK TELEGRAM ==========
cat <<EOF > /root/1.82/config.json
{
  "bot_token": "${TELEGRAM_BOT_TOKEN}",
  "chat_id": "${TELEGRAM_CHAT_ID}",
  "wallet": "${WALLET}"
}
EOF

# ========== SETUP CRON ==========
(crontab -l 2>/dev/null; echo "*/5 * * * * python3 /root/1.82/kas_check.py") | crontab -

# ========== PAPAR STATUS ==========
echo "✅ SEMUA TELAH SIAP!"
echo "🚀 Mining bermula dalam screen. Guna: screen -r kasminer"
echo "📩 Notifikasi Telegram akan dihantar jika payout diterima."
echo "📂 Sila semak dan ubah .env untuk ubah wallet atau worker"
