# Params below match to parameteres in the azuredeploy.json that are gen-unique, otherwise pointing to
# the azuredeploy.parameters.json file for default values.  Some options below are mandatory, some(such as deployment password for BIG IP)
# can be supplied inline when running this script but if they arent then the default will be used as specificed in below param arguments

param(
[Parameter(Mandatory=$True)]
[string]
$vmSize,

[Parameter(Mandatory=$True)]
[string]
$dnsLabelPrefix,

[Parameter(Mandatory=$True)]
[string]
$licenseToken1,

[Parameter(Mandatory=$True)]
[string]
$licenseToken2,

[Parameter(Mandatory=$True)]
[string]
$adminPassword,

[Parameter(Mandatory=$True)]
[string]
$applicationAddress,

[Parameter(Mandatory=$True)]
[string]
$vaultResourceGroup,

[Parameter(Mandatory=$True)]
[string]
$vaultName,

[Parameter(Mandatory=$True)]
[string]
$httpssecretUrlWithVersion,

[Parameter(Mandatory=$True)]
[string]
$certThumbprint,

[string]
$deploymentName = $dnsLabelPrefix,

[string]
$region = "West US",

[string]
$templateFilePath = "azuredeploy.json",

[string]
$parametersFilePath = "azuredeploy.parameters.json"
)

$timestamp = get-date -format g
Write-Host "[$timestamp] Starting Script "

# Connect to Azure, right now it is only interactive login
Add-AzureRmAccount

# Create Resource Group for ARM Deployment
New-AzureRmResourceGroup -Name $deploymentName -Location "$region"

# Create Arm Deployment
$pwd = ConvertTo-SecureString -String $adminPassword -AsPlainText -Force
$deployment = New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $deploymentName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -vmSize $vmSize -adminPassword $pwd -dnsLabelPrefix $dnsLabelPrefix -licenseToken1 "$licenseToken1" -licenseToken2 "$licenseToken2" -applicationAddress $applicationAddress -applicationType $applicationType -blockingLevel $blockingLevel -customPolicy $customPolicy -vaultResourceGroup $vaultResourceGroup -vaultName $vaultName -httpssecretUrlWithVersion $httpssecretUrlWithVersion -certThumbprint $certThumbprint

# Print Output of Deployment to Console
$deployment