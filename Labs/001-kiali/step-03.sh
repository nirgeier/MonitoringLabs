#!/bin/bash

### Step 03: Install the demo application versions 2,3
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/music-v2.yaml) -n electronic-shop
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/music-v3.yaml) -n electronic-shop

