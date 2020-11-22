# dsproxy

A simple terraform script to set up a proxy for your self hosted services.  
It uses (sniproxy)[https://github.com/dlundquist/sniproxy] to route traffic based on server name indicator.  

## To use

1. Already have a wireguard network setup (if you don't, take a look at [dsnet](https://github.com/naggie/dsnet))
2. You will also need a AWS account
3. Set up an EIP in the AWS account in the same region that the proxy runs in, make sure to note the ID of the EIP
4. Install the AWS cli and log in
5. Add a new entry for the proxy server
6. Set up a service on your homeserver
7. Make sure your home server and the proxy server can communicate over wireguard
8. Add `wg0.conf` with the wireguard details inside the `files` folder
9. Copy the `sniproxy.conf.example` to `sniproxy.conf` and configure as detailed in the conf file
10. Copy the `terraform.tfvars.example` to `terraform.tfvars`
11. Open `terraform.tfvars` and fill in the ssh public key with your own public key and the eip id

## Why

A lot of ISPs block you from running a webserver at home, this can be quite frustrating if your trying to self host apps and want to access them from your phone or let other people use your hosted service.  
Although many projects help you set up self hosted apps on cloud infrastructure, the data will be decrypted in those servers and possibly stored there.  

## VPN

Although you could access your home server through a VPN, some services (i.e. matrix) require you to let https traffic be sent between 2 servers.  

## Security

One of the features of sniproxy is that it does not need to decrypt the traffic to route it, this means you can continue to use services like AWS, GCP, DO and so on without the risk of them intercepting the traffic.  

### Unsolved risk

One unsolved risk is another reverse pxoy in front of the proxy intercepting the traffic, getting their own SSL certs, decrypting and resealing the traffic before it's sent to the proxy.  
This project is not trying to solve state actor level interception.  



# Todo

- Support other providers
  - 1. Digital ocean
  - 2. Scaleway
  - 3. Google cloud
  - 4. Vultr
  - 5. Azure
- Ability to add new hosts without rerunning the bootstrap
