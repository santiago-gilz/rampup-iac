#!/usr/bin/env bash
echo '{"result":"'$(curl -s ifconfig.me)'"}'
