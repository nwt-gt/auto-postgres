#!/bin/bash
docker volume rm autotest_9.6_data autotest_12_data
echo "Cleaning data"
sudo rm -rf data
echo "Creating data"
mkdir -p data/12
mkdir -p data/9.6
echo "Done"
#mkdir -p data/9.6-config
#mkdir -p data/12-config
cp -r  data-to-upgrade/* data/9.6/
