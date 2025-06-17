import os
import requests
from dotenv import load_dotenv

# ========== LOAD ENV ==========
load_dotenv("/root/1.82/.env")

WALLET = os.getenv("WALLET")
BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")

# ========== SEMAK STATUS MINING ==========
try:
    url = f"https://kas-api.unmineable.com/v4/address/{WALLET}"
    res = requests.get(url)
    data = res.json()['data']

    total_paid = data['total_paid']
    last_paid = data['last_payment_amount']
    last_paid_date = data['last_payment_date']

    message = f"💸 Payout diterima!
💰 Jumlah: {last_paid} KAS
📆 Tarikh: {last_paid_date}"

    # Hantar notifikasi jika ada pembayaran baharu
    if float(last_paid) > 0:
        send_url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        payload = {
            "chat_id": CHAT_ID,
            "text": message
        }
        requests.post(send_url, data=payload)

except Exception as e:
    print("[❌] Error fetching data:", str(e))
    print("[⚠️] Gagal semak data.")
