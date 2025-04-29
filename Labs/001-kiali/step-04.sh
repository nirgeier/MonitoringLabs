#!/bin/bash

### Step 04: Install the bookstore application 
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/bookstore-service-entry.yaml) -n electronic-shop
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/bookstore-v2.yaml) -n electronic-shop

kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/bookstore-egress-service-entry.yaml) -n electronic-shop
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/music-egress-service-entry.yaml) -n electronic-shop
kubectl apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/music-v4.yaml) -n electronic-shop


