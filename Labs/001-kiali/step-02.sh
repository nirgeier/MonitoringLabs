#!/bin/bash

### Step 02: Install the demo application
kubectl create    namespace electronic-shop
kubectl label     namespace electronic-shop istio-injection=enabled
kubectl apply -f  <(curl -L https://raw.githubusercontent.com/kiali/demos/master/electronic-shop/electronic-shop.yaml) -n electronic-shop
