# Params below match to parameteres in the azuredeploy.json that are gen-unique, otherwise pointing to
# the azuredeploy.parameters.json file for default values.  Some options below are mandatory, some(such as deployment password for BIG IP)
# can be supplied inline when running this script but if they arent then the default will be used as specificed in below param arguments

param(
[Parameter(Mandatory=$True)]
[string]
$deploymentName,

[Parameter(Mandatory=$True)]
[string]
$instanceType,

[Parameter(Mandatory=$True)]
[string]
$dnsLabel,

[Parameter(Mandatory=$True)]
[string]
$licenseKey1,

[Parameter(Mandatory=$True)]
[string]
$licenseKey2,

[Parameter(Mandatory=$True)]
[string]
$adminPassword,

[Parameter(Mandatory=$True)]
[string]
$applicationAddress,

[Parameter(Mandatory=$True)]
[string]
$applicationType,

[Parameter(Mandatory=$True)]
[string]
$blockingLevel,

[Parameter(Mandatory=$True)]
[string]
$customPolicy,

[Parameter(Mandatory=$True)]
[string]
$restrictedSrcAddress,

[Parameter(Mandatory=$True)]
[string]
$vaultResourceGroup,

[Parameter(Mandatory=$True)]
[string]
$vaultName,

[Parameter(Mandatory=$True)]
[string]
$secretUrl,

[Parameter(Mandatory=$True)]
[string]
$certThumbprint,

[string]
$deploymentName = $dnsLabel,

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
$deployment = New-AzureRmResourceGroupDeployment -Name $dnsLabel -ResourceGroupName $dnsLabel -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -instanceType $instanceType -adminPassword $pwd -dnsLabel $dnsLabel -licenseKey1 "$licenseKey1" -licenseKey2 "$licenseKey2" -applicationAddress $applicationAddress -applicationType $applicationType -blockingLevel $blockingLevel -customPolicy $customPolicy -vaultResourceGroup $vaultResourceGroup -vaultName $vaultName -secretUrl $secretUrl -certThumbprint $certThumbprint -restrictedSrcAddress $restrictedSrcAddress

# Print Output of Deployment to Console
$deployment