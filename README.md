# NGROK secure introspectable tunnels to localhost

## Prerequisition

* Install your NGROK here https://ngrok.com/

## How to Install
  1. Open cmd, change directory to C:\ 
  2. run 
  ```sh
  git clone https://github.com/chengkangzai/ngrok
  ```
  3. Configure auth token from https://dashboard.ngrok.com/auth
  ```sh
  ngrok auth <your auth token>
  ```
  4. Change the setting under setup.json 
  5. Run the "Password Update" for creating email credential 

## Functionalities 
  1. Send Email 
  2. Send to Discord Webhook
  3. Get Your VPN address if you are using one
  4. Initiate NGROK if it wasn't running
  5. Send Spam (Basically Heart Beat Service to make sure your machine is all up)
