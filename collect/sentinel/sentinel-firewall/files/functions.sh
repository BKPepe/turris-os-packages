. /lib/functions.sh

__enable_on_wan_zone() {
	local section="$1"
	local zone_name
	config_get zone_name "$section" "name"
	[ "$zone_name" != "wan" ] && return 0

	local enabled
	config_get_bool enabled "$section" "$option" ""
	[ -n "$enabled" ] || \
		uci -q set "firewall.$section.$option=1"
}

# This function enables given option on firewall zone wan unless it is already set
# to some value.
# option: option name to enable
config_firewall_default_enable() (
	local option="$1" # This is used inside __enable_on_wan_zone
	config_load "firewall"
	config_foreach __enable_on_wan_zone "zone"
	[ -z "$(uci changes firewall)" ] || \
		uci commit firewall
)
