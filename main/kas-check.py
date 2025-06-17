import requests
import os
from dotenv import load_dotenv

load_dotenv('/root/1.82/.env')

WALLET = os.getenv("WALLET")
WORKER = os.getenv("WORKER")
BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")

def send_telegram(msg):
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        payload = {"chat_id": CHAT_ID, "text": msg, "parse_mode": "HTML"}
        requests.post(url, json=payload)
    except Exception as e:
        print(f"[❌] Telegram error: {e}")

def get_kas_info():
    try:
        res = requests.get(f"https://kaspa-pool.org/api/wallet/{WALLET}")
        data = res.json()
        hashrate = data['hashrate']
        balance = data['balance']
        return hashrate, balance
    except Exception as e:
        print(f"[❌] Error fetching data: {e}")
        return None, None

if __name__ == "__main__":
    hashrate, balance = get_kas_info()
    if hashrate:
        msg = f"💡 <b>Worker:</b> {WORKER}\n⚙️ <b>Hashrate:</b> {hashrate} H/s\n💰 <b>Balance:</b> {balance} KAS"
        send_telegram(msg)
        print("✅ Info dihantar ke Telegram.")
    else:
        print("⚠️ Gagal semak data.")
