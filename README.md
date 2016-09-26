### Azure Web Application Firewall Community Template ###
### Deploy F5 WAF Solution in Azure ###

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Ff5devcentral%2Ff5-azure-waf-community%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/f5devcentral/f5-azure-waf-community/master/azuredeploy.json" target="_blank">
  <img src="http://armviz.io/visualizebutton.png"/>
</a>

### Description ###
You can secure your web applications by creating a web application firewall (WAF) that uses the Local Traffic Manager™ (LTM®) and Application Security Manager™ (ASM™) modules. In Azure Security Center, the BIG-IP® VE instances are configured as a WAF for you, complete with traffic monitoring in Azure. The F5 WAF solution has more than 2600 signatures at its disposal to identify and block unwanted traffic.

When you secure your applications by using an F5 WAF, the BIG-IP VE instances are all in Active status (not Active-Standby), and are used as a single WAF, for redundancy and scalability, rather than failover. If one WAF goes down, Azure will keep load balancing to the other.

The F5 WAFs will be fully configured in front of your application with the base Security Blocking template that you choose.  When completed, the WAFs will pass traffic through the newly created Azure Public IP.  After acceptance testing, you will want to complete the configuration by changing the DNS entry for your application to point at the newly created public IP address, and then lock down the Network Security Group rules to prevent any traffic from reaching your application except through the F5 WAFs.

The configuration will look like the following diagram, with two separate Azure resource groups: one for your application, and one for the WAF:

![screenshot](WAF_1.png)

As traffic passes through the WAF, alerts are logged locally about possible violations. The amount of traffic that is flagged depends on the security blocking level you choose when you create the WAF.

### F5 WAF instance types and pricing tiers ###
Before you secure web applications with an F5 WAF, you need a license from F5.

You choose the license and corresponding Azure instance based on the number of cores and throughput you need. The instances listed below are minimums; you can choose larger instances if you want.

| Cores | Througput | Minimum Azure Instance |
| --- | --- | --- |
| 2 | 25 Mbps | D2_v2 |
| 4 | 200 Mbps | A3 Standard or D3_v2 |
| 8 | 1 Gbps | A4 or A7 Standard or D4v2 |

### Security blocking levels ###
The security blocking level you choose when you create the WAF determines how much traffic is blocked and alerted by the F5 WAF.

Attack signatures are rules that identify attacks on a web application and its components. The WAF has at least 2600 attack signatures available. The higher the security level you choose, the more traffic that is blocked by these signatures.

| Level | Details |
| --- | --- | --- |
| Low | The fewest attack signatures enabled. There is a greater chance of possible security violations making it through to the web applications, but a lesser chance of false positives. |
| Medium | A balance between logging too many violations and too many false positives. |
| High | The most attack signatures enabled. A large number of false positives may be recorded; you must correct these alerts for your application to function correctly. |

All traffic that is not being blocked is being used by the WAF for learning. Over time, if the WAF determines that traffic is safe, it allows it through to the application. Alternately, the WAF can determine that traffic is unsafe and block it from the application.

You cannot change the security blocking level after you create the WAF, so be sure that you select the correct level.

### Template parameters ###

| Parameter | Required | Description |
| --- | --- | --- |
| location | x | The location where the web application's resource group resides. | 
| numberOFWAFs | x | The number of WAFs that will be deployed in front of your application.  The only allowed value for this template is 2. |
| vmSize | x | The desired Azure Virtual Machine instance size. |
| adminUsername | x | A user name to login to the WAFs.  The default value is "azureuser". |
| adminPassword | x | A strong password for the WAFs. Remember this password; you will need it later. |
| dnsNameForPublicIP | x | Unique DNS Name for the public IP address used to access the WAFs for management. |
| licenseToken1 | x | The license token from the F5 licensing server. This license will be used for the first F5 WAF. |
| licenseToken2 | x | The license token from the F5 licensing server. This license will be used for the second F5 WAF. |
| applicationName | x | A simple name for your application. |
| applicationProtocols | x | A semi-colon separated list of protocols (http;https) that will be used to configure the application virtual servers (for example, http for port 80 and/or https for SSL). |
| applicationAddress | x | The public IP address or DNS FQDN of the application that this WAF will protect. |
| applicationPorts | x | A semi-colon separated list of ports that your application is listening on (for example, 80 and 443). |
| applicationType | x | The operating system on which your application is running. (Linux OS or Windows OS). |
| blockingLevel | x | The level of traffic you want to flag as unsecure. All applications behind the WAF will use this level. The higher the level, the more traffic that is blocked. The lower the level, the more chances that unsecure traffic will make it through to your application. See the Security blocking levels topic for more information. |
| applicationFQDN | x | The fully-qualified domain name of your application (for example, www.example.com). |
| applicationCertificate | x | The path to the SSL certificate file. This is only required when you are deploying WAF in front of an HTTPS application. |
| applicationKey | x | The path to the SSL key file.  This is only required when you are deploying WAF in front of an HTTPS application. |
| applicationChain |  | The path to the SSL chain file. |

### Results ###

This template will create a new resource group, and inside this new resource group it will configure the following:

* Availability Set
* Azure Load Balancer
* Network Security Group
* Storage Account
* Public IP Address
* Network Interface objects for the F5 WAF devices
* F5 WAF Virtual Machines

### Connecting to the management interface of the Web Application Firewalls ###

After the deployment successfully finishes, you can find the BIG-IP Management UI\SSH URLs by doing the following: 

* Find the resource group that was deployed, which is the same name as the "dnsNameForPublicIP".  When you click on this object you will see the deployment status.  
* Click on the deployment status, and then the deployment.  
* In the "Outputs" section you will find the URL's and ports that you can use to connect to the F5 WAF cluster. 

### Viewing and clearing security violations ###

From the BIG-IP Management UI, you can view and accept/ignore detected security violations:

* Click Security > Event Logs > Application > Requests
* From the Requests List, select the illegal request you want to view
* Select an action to be performed for future occurences of this violation
* From the top menu, click Apply Policy to apply the changes