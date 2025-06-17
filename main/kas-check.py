import requests
import json
import time

CONFIG_PATH = "/root/1.82/config.json"

try:
    with open(CONFIG_PATH, "r") as f:
        config = json.load(f)
except Exception as e:
    print(f"[❌] Error loading config: {e}")
    exit(1)

WALLET = config.get("wallet")
WORKER = config.get("worker")
BOT_TOKEN = config.get("bot_token")
CHAT_ID = config.get("chat_id")

def send_telegram(msg):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": CHAT_ID,
        "text": msg,
        "parse_mode": "HTML"
    }
    try:
        requests.post(url, json=payload)
    except Exception as e:
        print(f"[❌] Telegram error: {e}")

def get_kas_info():
    url = f"https://kaspa-pool.org/api/wallet/{WALLET}"
    try:
        res = requests.get(url)
        data = res.json()
        hashrate = data['hashrate']
        balance = data['balance']
        return hashrate, balance
    except Exception as e:
        print(f"[❌] Error fetching data: {e}")
        return None, None

if __name__ == "__main__":
    hashrate, balance = get_kas_info()
    if hashrate is not None:
        msg = f"💡 <b>Worker:</b> {WORKER}\n⚙️ <b>Hashrate:</b> {hashrate} H/s\n💰 <b>Balance:</b> {balance} KAS"
        send_telegram(msg)
        print("✅ Info dihantar ke Telegram.")
    else:
        print("⚠️ Gagal semak data.")
