#!/bin/bash

### Step 05: Install the bookstore application with egress 

###
### After this step the cluster will not be able to "recover"
###

kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/bookstore-egress-service-entry.yaml) -n electronic-shop
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/music-egress-service-entry.yaml) -n electronic-shop
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/music-v4.yaml) -n electronic-shop