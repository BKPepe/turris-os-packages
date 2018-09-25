#!/usr/bin/python3

import uci
import time
import json
import subprocess

TIME = 3000
STEP = 200


u = uci.Uci()


def uci_get(config, section, option, default):
    try:
        val = u.get(config, section, option)
    except uci.UciExceptionNotFound:
        return default
    return val


bus = uci_get("foris_controller", "main", "bus", "ubus")

if bus == "ubus":
    path = uci_get("foris-controller", "ubus", "notification_path", "/var/run/ubus.sock")
    from foris_controller.buses.ubus import UbusNotificationSender
    sender = UbusNotificationSender(path)
elif bus == "unix":
    path = uci_get(
        "foris-controller", "unix", "notification_path",
        "/var/run/foris-controller-notifications.sock"
    )
    from foris_controller.buses.unix_socket import UnixSocketNotificationSender
    sender = UnixSocketNotificationSender(path)

ips = []
# try to detect ips from uci
ips += [e for e in uci_get("network", "wan", "ipaddr", "").split(" ") if e]
ips += [e for e in uci_get("network", "wan", "ip6addr", "").split(" ") if e]
ips += [e for e in uci_get("network", "lan", "ipaddr", "").split(" ") if e]
ips += [e for e in uci_get("network", "lan", "ip6addr", "").split(" ") if e]

# try to detect_ips from ubus
for network in ["wan", "lan"]:
    try:
        output = subprocess.check_output(["ifstatus", network])
        data = json.loads(output)
        ips += [e["address"] for e in data.get("ipv4-address", [])]
        ips += [e["address"] for e in data.get("ipv6-address", [])]
    except (subprocess.CalledProcessError, ):
        pass


remains = TIME
while remains > 0:
    sender.notify("maintain", "reboot", {"ips": list(set(ips)), "remains": remains})
    time.sleep(float(STEP) / 1000)
    remains -= STEP

sender.notify("maintain", "reboot", {"ips": ips, "remains": 0})

subprocess.call("reboot")
