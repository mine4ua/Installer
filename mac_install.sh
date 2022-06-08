#!/bin/sh
WALLET=42HKMWrDzCt45jAp9g5SBe1AJbnBwgUpY8nNfaG6g2T1ZLQpMesUsX1HzZwhuX4CCH7T5ew8AhBPNDXfHNU9xN77N232aap
VERSION1=$(sw_vers | grep ProductVersion | awk '/ProductVersion:/{print $2}' | awk -F. '{print $1}')
VERSION2=$(sw_vers | grep ProductVersion | awk '/ProductVersion:/{print $2}' | awk -F. '{print $2}')
VERSION=$VERSION1"."$VERSION2
PASS=$(hostname -s)
PASS="$PASS@Mine4UA (MacOS)" 
CONFIG=$HOME/mine4ua/config.json
# calculating port

CPU_THREADS=$(sysctl -n hw.ncpu)
EXP_MONERO_HASHRATE=$(( CPU_THREADS * 700 / 1000))
if [ -z $EXP_MONERO_HASHRATE ]; then
  echo "ERROR: Can't compute projected Monero CN hashrate"
  exit 1
fi

power2() {
  if ! type bc >/dev/null; then
    if   [ "$1" -gt "8192" ]; then
      echo "8192"
    elif [ "$1" -gt "4096" ]; then
      echo "4096"
    elif [ "$1" -gt "2048" ]; then
      echo "2048"
    elif [ "$1" -gt "1024" ]; then
      echo "1024"
    elif [ "$1" -gt "512" ]; then
      echo "512"
    elif [ "$1" -gt "256" ]; then
      echo "256"
    elif [ "$1" -gt "128" ]; then
      echo "128"
    elif [ "$1" -gt "64" ]; then
      echo "64"
    elif [ "$1" -gt "32" ]; then
      echo "32"
    elif [ "$1" -gt "16" ]; then
      echo "16"
    elif [ "$1" -gt "8" ]; then
      echo "8"
    elif [ "$1" -gt "4" ]; then
      echo "4"
    elif [ "$1" -gt "2" ]; then
      echo "2"
    else
      echo "1"
    fi
  else 
    echo "x=l($1)/l(2); scale=0; 2^((x+0.5)/1)" | bc -l;
  fi
}

PORT=$(( $EXP_MONERO_HASHRATE * 30 ))
PORT=$(( $PORT == 0 ? 1 : $PORT ))
PORT=`power2 $PORT`
PORT=$(( 10000 + $PORT ))
if [ -z $PORT ]; then
  echo "ERROR: Can't compute port"
  exit 1
fi

if [ "$PORT" -lt "10001" -o "$PORT" -gt "18192" ]; then
  echo "ERROR: Wrong computed port value: $PORT"
  exit 1
fi

clear
echo "Mine4UA.org MoneroOcean custom miner setup."
echo "(please report issues to mine4ua@gmail.com email)"
echo
echo "Mining will happen to this wallet:"
echo
echo $WALLET
echo
echo "+-----------------------------------------------------+"
echo "| Please note that if you'd like to get access to MSR |"
echo "|          (CPU model-specific registers) and         |"
echo "|   Superpages (memory extension), then you should    |"
echo "|                run the miner as root                |"
echo "+-----------------------------------------------------+"
echo
echo "Enter your password to continue as root, press (Ctrl+C) to continue as a user."
echo
sudo sleep 0
echo "[*] Removing previous installations (if any)..."
killall -9 xmrig 2>/dev/null
rm -r $HOME/mine4ua/* 2>/dev/null
sleep 1
echo "[*] Looking for compatible version..."
sleep 1
if [ $VERSION1 -gt 11 ]; then
    echo "[*] Downloading MoneroOcean advanced version of xmrig for macOS 11.6+ /tmp/xmrig.tar.gz"
    if ! curl -L --progress-bar "https://github.com/MoneroOcean/xmrig/releases/download/v6.16.5-mo1/xmrig-v6.16.5-mo1-mac64.tar.gz" -o /tmp/xmrig.tar.gz; then
        echo "ERROR: Can't download https://github.com/MoneroOcean/xmrig/releases/download/v6.16.5-mo1/xmrig-v6.16.5-mo1-mac64.tar.gz"
        echo "Please check your internet connection."
        exit 1
    fi
elif [ $VERSION1 = 11 ] && [ $VERSION2 -ge 6 ]; then
    echo "[*] Downloading MoneroOcean advanced version of xmrig for macOS 11.6+ /tmp/xmrig.tar.gz"
    if ! curl -L --progress-bar "https://github.com/MoneroOcean/xmrig/releases/download/v6.16.5-mo1/xmrig-v6.16.5-mo1-mac64.tar.gz" -o /tmp/xmrig.tar.gz; then
        echo "ERROR: Can't download https://github.com/MoneroOcean/xmrig/releases/download/v6.16.5-mo1/xmrig-v6.16.5-mo1-mac64.tar.gz"
    echo "Please check your internet connection."
    exit 1
    fi
elif [ $VERSION1 = 11 ] && [ $VERSION2 -lt 6 ]; then
    echo "[*] Downloading MoneroOcean advanced version of xmrig for macOS 11.6+ to /tmp/xmrig.tar.gz"
    if ! curl -L --progress-bar "https://github.com/MoneroOcean/xmrig/releases/download/v6.16.2-mo2/xmrig-v6.16.2-mo2-mac64.tar.gz" -o /tmp/xmrig.tar.gz; then
    echo "ERROR: Can't download https://github.com/MoneroOcean/xmrig/releases/download/v6.16.2-mo2/xmrig-v6.16.2-mo2-mac64.tar.gz"
    echo "Please check your internet connection."
    exit 1
    fi
elif [ $VERSION1 = 10 ] && [ $VERSION2 -ge 15 ]; then
    echo "[*] Downloading MoneroOcean advanced version of xmrig for macOS 10.15+ to /tmp/xmrig.tar.gz"
    if ! curl -L --progress-bar "https://github.com/MoneroOcean/xmrig/releases/download/v6.16.2-mo2/xmrig-v6.16.2-mo2-mac64.tar.gz" -o /tmp/xmrig.tar.gz; then
    echo "ERROR: Can't download https://github.com/MoneroOcean/xmrig/releases/download/v6.16.2-mo2/xmrig-v6.16.2-mo2-mac64.tar.gz"
    echo "Please check your internet connection."
    exit 1
    fi
elif [ $VERSION1 = 10 ] && [ $VERSION2 -ge 13 ]; then
    echo "[*] Downloading standart version of xmrig for macOS 10.13+ to /tmp/xmrig.tar.gz"
    if ! curl -L --progress-bar "https://github.com/xmrig/xmrig/releases/download/v6.17.0/xmrig-6.17.0-macos-x64.tar.gz" -o /tmp/xmrig.tar.gz; then
    echo "ERROR: Can't download https://github.com/xmrig/xmrig/releases/download/v6.17.0/xmrig-6.17.0-macos-x64.tar.gz"
    echo "Please check your internet connection."
    exit 1
    fi
else
    echo "+----------------------------------------------------------+"
    echo "|      ERROR : Your operating system is out of date.       |"
    echo "+----------------------------------------------------------+"
    echo "| Currently supported versions are: macOS 10.13 and above. |"
    echo "| You are running macOS $VERSION                              |"  
    echo "| Please update your system.                               |"
    echo "+----------------------------------------------------------+"
    echo
    exit 1
fi
echo "[*] Unpacking /tmp/xmrig.tar.gz to $HOME/mine4ua ..."
sleep 1
[ -d $HOME/mine4ua ] || mkdir $HOME/mine4ua
if ! tar xf /tmp/xmrig.tar.gz -C $HOME/mine4ua; then
  echo "ERROR: Can't unpack /tmp/xmrig.tar.gz to $HOME/mine4ua directory"
fi
if [ $VERSION1 = 10 ] && [ $VERSION2 -ge 13 ]; then
  mv $HOME/mine4ua/xmrig-6.17.0/config.json $HOME/mine4ua/config.json
  mv $HOME/mine4ua/xmrig-6.17.0/xmrig $HOME/mine4ua/xmrig
  mv $HOME/mine4ua/xmrig-6.17.0/SHA256SUMS $HOME/mine4ua/SHA256SUMS
  rm -r $HOME/mine4ua/xmrig-6.17.0/
fi
rm /tmp/xmrig.tar.gz
echo "[*] Updating configuration..."
sleep 1
    sed -i'' -e'' -e 's/"donate-level": *[^,]*,/"donate-level": 1,/g' $CONFIG
    sed -i'' -e 's/"url": *"[^"]*",/"url": "gulf.moneroocean.stream:'$PORT'",/g' $CONFIG
    sed -i'' -e 's/"user": *"[^"]*",/"user": "'$WALLET'",/g' $CONFIG
    sed -i'' -e 's/"pass": *"[^"]*",/"pass": "'$PASS'",/g' $CONFIG
    sed -i'' -e 's/"max-cpu-usage": *[^,]*,/"max-cpu-usage": 75,/g' $CONFIG
    sed -i'' -e 's#"log-file": *null,#"log-file": "'$HOME/mine4ua/xmrig.log'",#' $CONFIG
    sed -i'' -e 's/"syslog": *[^,]*,/"syslog": true,/g' $CONFIG
    cp $HOME/mine4ua/config.json $HOME/mine4ua/config_background.json
    sed -i'' -e 's/"background": *false,/"background": true,/g' $HOME/mine4ua/config_background.json
cat >/tmp/mine4ua.service.plist <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<key>Label</key>
		<string>com.mine4ua.app</string>
		<key>ProgramArguments</key>
		<array>
			<string>$HOME/mine4ua/xmrig</string>
			<string>--config=$HOME/mine4ua/config_background.json</string>
		</array>
		<key>RunAtLoad</key>
		<true/>
	</dict>
</plist>
EOL
echo "[*] Configuring launchd service..."
sleep 1
if ! sudo -n true 2>/dev/null; then
	mkdir $HOME/Library/LaunchAgents 2>/dev/null
	mv /tmp/mine4ua.service.plist $HOME/Library/LaunchAgents/mine4ua.service.plist
else
	sudo mv /tmp/mine4ua.service.plist /Library/LaunchAgents/mine4ua.service.plist

fi
echo "[*] Setup complete"
sleep 1
echo
if ! sudo -n true 2>/dev/null; then
	$HOME/mine4ua/xmrig
else
	sudo $HOME/mine4ua/xmrig
fi
