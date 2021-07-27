#!/bin/bash

# VARS
APP=${TARGET_APP}
export BACK_HOST=${API_LB_IP}
set_vars () {
    if [ -z "$APP" ]; then
        echo "Error: which app are you provisioning (ui, api)"
        exit 1
    elif [ "$APP" = "ui" ]; then
        if [ -z "$BACK_HOST" ]; then
            echo "Error: you need to provide an IP where the API is running as follows: $0 api 10.0.0.2"
            exit 1
        fi
    elif [ "$APP" = "api" ]; then
        export PORT='3000' 
    else
        echo "Error: unkown argument. Allowed: 'api', 'ui'"
        exit 1
    fi
}

set_vars

#Installing main dependencies
sudo dnf module enable nodejs:14 -y
sudo dnf install nodejs git -y

#Downloads the code if not exists
if [ ! -d movie-analyst-$APP ]; then
    echo "Cloning code repo"
    git clone https://github.com/juan-ruiz/movie-analyst-$APP.git
fi

cd movie-analyst-$APP/
npm install
sudo npm install pm2 -g

/usr/local/bin/pm2 status server | grep -q 'server.*online'
if [ $? -ne 0 ]; then 
    echo "Starting service using pm2"
    /usr/local/bin/pm2 start server.js
fi

systemctl status pm2-$USER | grep -q enabled
if [ $? -ne 0 ]; then
    echo "Setting service to run on boot"
    /usr/local/bin/pm2 startup systemd -u $USER --hp $HOME
    sudo env PATH=$PATH:/usr/bin /usr/local/bin/pm2 startup systemd -u $USER --hp $HOME
    /usr/local/bin/pm2 save
fi
