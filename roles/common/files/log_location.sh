#!/bin/ash
CITY=$(wget -q https://ipinfo.io/city -O -)
COUNTRY=$(wget -q https://ipinfo.io/country -O -)

logger -p notice -t vpn_location "$CITY, $COUNTRY"
