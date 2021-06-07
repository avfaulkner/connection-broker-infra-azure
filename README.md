# Connection Broker Infrastructure in Azure

## Diagram
![certiport_leostream](https://user-images.githubusercontent.com/6284506/120906922-3d97c680-c612-11eb-974b-01e84a13208f.png)

## Resources
- resource group
- application gateway
    - static public ip address for app gateway frontend
    - backend pool for app gateway backend
        - virtual machine scale set for brokers
    - app gateway listener
    - a routing rule to send traffic from a given frontend IP address to one or more backend targets. 
        - A routing rule must contain a listener and at least one backend target.
- virtual network
- public subnet
- private subnet
- ssh key pair
    
