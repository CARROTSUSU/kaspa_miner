import os
import requests
from dotenv import load_dotenv

load_dotenv("/root/1.82/.env")

wallet = os.getenv("WALLET")
worker = os.getenv("WORKER")
token = os.getenv("TELEGRAM_BOT_TOKEN")
chat_id = os.getenv("TELEGRAM_CHAT_ID")

def send_telegram(msg):
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": msg,
        "parse_mode": "Markdown"
    }
    try:
        requests.post(url, json=payload)
    except:
        print("[❌] Gagal hantar notifikasi Telegram.")

def check_payout():
    try:
        response = requests.get(f"https://api.unmineable.com/v4/address/{wallet}")
        data = response.json()
        if "data" in data:
            balance = float(data["data"]["balance"])
            paid = float(data["data"]["totalPaid"])
            msg = f"""
💸 *KASPA MINER UPDATE*
👤 *Worker:* `{worker}`
📦 *Balance:* `{balance:.6f} KAS`
✅ *Paid Total:* `{paid:.6f} KAS`
"""
            print(msg)
            send_telegram(msg)
        else:
            print("[⚠️] Data tak dijumpai.")
    except Exception as e:
        print(f"[❌] Error: {e}")

if __name__ == "__main__":
    check_payout()
