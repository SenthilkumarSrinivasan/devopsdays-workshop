#!/bin/bash

echo "This workshop will use your GitHub account name as a unique identifier."
echo "We won't grant any permissions on the account, but the demo app will"
echo "use your avatar from GitHub so please use a real account name."
echo
echo -n "Enter your GitHub account name: "
read -r account

echo
echo '* checking that you have access to Docker engine on host...'
docker ps > /dev/null && echo 'ok!' || echo 'failed!'

echo
echo '* fetching environment variables...'
port=$(awk 'BEGIN{srand();print int(rand()*(10000-8000))+8000 }')

private_ip=$(ifdata -pa net1)  # note: this requires 'moreutils'
public_ip=$(ifdata -pa net0)
echo 'ok!'

echo
echo '* exporting workshop environment to a couple of config files...'
find ~/workshop -name 'config.json5' | xargs sed -i "s/GITHUB_ACCOUNT/${account}/"
echo 'ok!'

echo
echo '* exporting workshop environment to your shell...'
export ACCOUNT=$account
export PORT=$port
export PRIVATE_IP=$private_ip
export PUBLIC_IP=$public_ip
echo 'ok!'

echo
echo '* exported the following workshop environment:'
echo
echo "ACCOUNT=$ACCOUNT"
echo "PORT=$PORT"
echo "PRIVATE_IP=$PRIVATE_IP"
echo "PUBLIC_IP=$PUBLIC_IP"
echo

# otherwise we get the very long hostname
export PS1="\u@workshop:\w\$ "

alias cleanup='docker stop ${ACCOUNT} && docker rm ${ACCOUNT}'
