#1. Creating ResourceGroup called Dev-HybridWorkers-RG

#Get displaynames for Azure locationso we can save in a variable
get-AzLocation | select displayname, ft

#Returns "Australia southeast" as a displayname and the value for variable $Location

$Location = 'Australia Southeast'
$resourceGroupName = 'Dev-HybridWorkers-RG'
$VnetName = 'Dev-HybridWorkers-Vnet-1'
New-AZResourceGroup -Name $resourceGroupName -location $Location

#Creating the virtual network for our Dev-Hybrid-Workers ResourceGroup
New-AzVirtualNetwork `
   -Name $VnetName `
   -ResourceGroupName $resourceGroupName `
   -location $Location `
   -AddressPrefix 10.10.0.0/16

#Subnet Config for 'Dev-HybridWorkers-Vnet-1' - this subnet is where the VMs will go :)

$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $VnetName
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name 'v1-Subnet1' `
  -AddressPrefix 10.10.255.0/24 `
  -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork

#Deploying an Azure Bastion Subnet to The 'Dev-HybridWorkers-Vnet-1'
$resourceGroupName = 'Dev-HybridWorkers-RG'
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name 'Dev-HybridWorkers-Vnet-1' 
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name 'AzureBastionSubnet' `
  -AddressPrefix 10.10.254.0/24 `
  -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork

#Navigate to Bastion in Dev-HybridWorkers-Vnet1 and click deploy bastion

#Deploying VM from ARM templates:
#Cloudshell command: 
#Note - the ARM template I'm using has parameters for domain join - even though for this test we're not using domain join - just use random params and allow the domain join to fail
$resourceGroupName = 'Dev-HybridWorkers-RG'
$location = (Get-AzResourceGroup -ResourceGroupName $resourceGroupName).Location
New-AzResourceGroupDeployment `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name HybridWorkerVMDeployment `
  -TemplateFile $HOME/HybridWorkerVM.json `
  -TemplateParameterFile $HOME/HybridWorkerVM.parameters.json



#Creating new Azure Automation Account - Creates an automation account in the resourcegroup/location
New-AzAutomationAccount -Name 'Dev-HybridWorkers-AutomationAccount' -Location $Location -ResourceGroupName $resourceGroupName 

  #Creating local user profiles on AzureVM
  #See LocalUserCreate.ps1 file


#Hybrid Extension based worker setup

GET https://westcentralus.management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}?api-version=2021-06-22

GET https://westcentralus.management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}?api-version=2021-06-22


$Subscription = Get-AzSubscription | select id 
$ResourceGroupName =  'Dev-HybridWorkers-RG'
$AutomationAccount = 'Dev-HybridWorkers-AutomationAccount'  # Get-AZAutomationAccount | select AutomationAccountName



Invoke-WebRequest GET https://AustraliaSoutheast.management.azure.com/xxx-xxxx

Remove-AzResourceGroup -Name 'Dev-HybridWorkers-RG'