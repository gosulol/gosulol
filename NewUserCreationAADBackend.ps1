Start-Transcript -Path

#Defines the parameters that are passed through from the Front end


Param($NewUserObject, $AdminCredential,$Mainform)

#This part initialises a hashtable skuHashTable to check the number of E3 licenses in the tennant


# Initialise skuHashTable

$skuHashTable = @{}

#Queries the available license SKUs in the tennant using the MSOL module

$FormattedSKUS = Get-MsolAccountSku | Sort-Object ActiveUnits -Descending | Select-Object @{Name='AccountSkuId'; Expression={$_.AccountSkuID}}, @{Name='Total'; Expression={$_.ActiveUnits}}, @{Name='Assigned'; Expression={$_.ConsumedUnits}}, @{Name='Unassigned'; Expression={$_.ActiveUnits - $_.ConsumedUnits}}, @{Name='Warning'; Expression={$_.WarningUnits}}

#Iterates over the formatted SKUs and add them to the hashtable skuHashtable

foreach ($sku in $FormattedSKUS) {
    $skuHashTable[$sku.AccountSkuId] = $sku

}


#Checks the number of licenses available from the hashtable we've created using the license name as the key


$Total = $SkuHashtable['xxxx:SPE_E3'].total

$Assigned = $SkuHashtable['xxxx:SPE_E3'].assigned

$UnAssigned = $SkuHashtable['xxxx:SPE_E3'].unassigned

 #Checks if licenses are available - and throw terminating error - haven't added throw yet

If ($Unassigned -lt 1) {

Write-Output "Need to order some more E3 licenses, Please follow KBXXXXX"

}

#Checks (Assigned - Total) rather than just available in case of over allocation in the tennant

Else($Assigned - $Total -gt 0) {

Write-OutPut "There are currently $Assigned licenses Assigned, and $Total licenses available - You may need to order more than one additional license "}

 

#UPN Checker

Else {

    $ExistingUser = Get-AzureADUSer -ObjectID $NewUserObject.Name

    #Check user UPN for duplicates - throw terminating error for duplicate

    $UPNComparison = $ExistingUser.Userprincipalname

    If ($UPNComparison -ieq  $NewUserObject.Name){

        Write-Output "A User with that Name already exists - Terminating Script, please try a different UPN"

        #If the name is found throw a terminating error:

        $Mainform.close()

        throw "A User with that Name already exists - Terminating Script, please try a different UPN"

         

    }

   

}

 

$CustomAttributes = Import-csv -Path 'C:\Users\xxxxx\Scripts\xxxxx\CustomAttributes.csv'

 
#Create HashTable of Custom Attributes#

$ExtensionAttributes = @{}

$AttributeFilePath = 'C:\Users\xxxxx\Scripts\xxxxx\CustomAttributes.csv'

$MyTable = Import-csv -Path $AttributeFilePath

Foreach ($r in $MyTable){

$ExtensionAttributes[$r.city] = $r.CustomAttribute2, $r.CustomAttribute3

 

}

 

#Capturing Extension attributes of relevant city for user from the hashtable generated above

 

$ExtensionAttribute2 = $ExtensionAttributes.$City[0]
$ExtensionAttribute3 = $ExtensionAttributes.$City[1]

###Unfortunately still have to deal with group assignments as we haven't received approval to implement dynamic group membership for default groups

 
#Creating the AD User
New-AzureADUser `

    -Firstname $FirstName `

    -LastName $LastName `

    -DisplayName $DisplayName `

    -UserPrincipalName $UserPrincipalName `

    -Country $Country `

    -JobTitle $JobTitle `

    -Mobile $Mobile `

    -UsageLocation $Australia `

    -Manager $Manager `

    -AccountEnabled $true `

    -ExtensionProperty2 $ExtensionAttribute2 `

    -ExtensionProperty3 $ExtensionAttribute3 `

 

Set-MSOLLicense -UserPrincipalName $UserPrincipalName -addlicenses "xxxx:SPE_E3"

 

$LegalSignature = $LegalSignature

$DevelopmentSignature = $DevelopmentSignature

$QLDDevelopmentSignature = $QLDDevelopmentSignature


#Writing Section for defaultGroups:

$DefaultGroups = @(xxxx, xxxxxx, xxxxx)

Foreach($Group in $DefaultGroups){

Add-AzureADGroup Member -ObjectID $Group -RefObjectiD $UPN

}

 


 
If ($QLDDevelopmentSignature -eq $True){

Add-AzureADGroupMember -ObjectID QLDDevelopmentSignature -RefObjectID $UPN }

Else ($LegalSignature -eq $True ){

Add-AzureADGroupMember -ObjectID LegalSignature -RefObjectID $UPN

}

Else($DevelopmentSignature -eq $True){

    Add-AzureADGroupMember -ObjectID DevelopmentSignature -RefObjectID $UPN

}

 

End-Transcript








