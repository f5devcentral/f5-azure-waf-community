# Azure-WAF
Deploy F5 WAF Solution in Azure  

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Ff5devcentral%2Ff5-azure-waf-community%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

### Description:
The F5 WAFs will be fully configured in front of your application with the base Security Blocking template that you choose.  When completed, the WAFs will pass traffic through the newly created Azure Public IP.  After some testing to make sure everything is working, you will want to complete the configuration by changing the DNS entry for your application to point at the newly created public IP address, and then locking down the Network Security Group rules to prevent any traffic from reaching your application except through the F5 WAFs.

### Parameter Definitions: ###

* location
  * Required
  * Choose the data center you want to install these Web Application Firewalls into from the drop down list.
* numberOFWAFs
  * Required
  * The number of Web Application Firewalls (2) that will be deployed in front of your application.
* vmSize
  * Required
  * Choose the size of the Azure Virtual Machine instance from the list.
* adminUsername
  * Required
  * User name to login to the Web Application Firewall.
* adminPassword
  * Required
  * Password to login to the Web Application Firewall.
* dnsNameForPublicIP
  * Required
  * Unique DNS Name for the public IP address used to access the Web Application Firewalls for management.
* licenseToken1
  * Required
  * The license token for the first F5 Web Application Firewall.
* licenseToken2
  * The license token for the second F5 Web Application Firewall.
* applicationName
  * Required
  * Please provide a simple name for your application.
* applicationProtocols
  * Required
  * A semi-colon separated list of protocols (http;https) that will be used to configure the application virtual servers, (e.g. http for port 80 and https for SSL).
* applicationAddress
  * Required
  * The public IP address or DNS FQDN of the application that this WAF is for.
* applicationPorts
  * Required
  * A semi-colon separated list of ports, (80;443) that your application is listening on, (e.g. 80 and 443).
* applicationType
  * Required
  * Select the operating system that your application is running on. (Linux OS or a Windows OS)
* blockingLevel
  * Required
  * Please select the security blocking level for this WAF deployment.  Remember that the more aggressive the blocking level, the more potential there is for the WAF to detect "false positive" violations.
* applicationFQDN
  * Required
  * The fully-qualified domain name of your application. (e.g. www.example.com).
* applicationCertificate
  * Optional
  * The path to the SSL certificate file.
* applicationKey
  * Optional
  * The path to the SSL key file.
* applicationChain
  * Optional
  * The path to the SSL chain file.


### What gets deployed:

This template will create a new resource group, and inside this new resource group it will configure the following;

* Availability Set
* Azure Load Balancer
* Network Security Group
* Storage Container
* Public IP Address
* NIC objects for the F5 WAF devices.
* F5 WAF Virtual Machines

### How to connect to your Web Application Firewalls to manage them:

After the deployment successfully finishes, you can find the BIG-IP Management UI\SSH URLs by doing the following: Find the resource group that was deployed, which is the same name as the "dnsNameForPublicIP".  When you click on this object you will see the deployment status.  Click on the deployment status, and then the deployment.  In the "Outputs" section you will find the URL's and ports that you can use to connect to the F5 WAF cluster. 