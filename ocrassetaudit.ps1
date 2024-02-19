#Install the PSOCR module

#Install-Module -Name PSOCR

 

#Import the PSOCR module:

#Import-module -Name PSOCR

 

#Variables

 

$Date = Get-date -format "yyyy-MM-dd"

$Path = "C:\Users\Username\One-drive Name\Pictures\Camera Roll\2024\"

$FileName = $Date + "-AssetImport"

$Pictures = Get-ChildItem $Path | select name

 

#Foreach loop making use of Core OCR functionality

Foreach ($Picture in $Pictures){

$FullPath = $Path + $Picture.Name

$Asset = Convert-PsoImageToText -Path $FullPath -language en-us

 

#Text manipulation so we've got something to work with

$JustAssetName = $Asset.text | Select-String "Asset", "A*t"

$SplittingAssetName = $JustAssetName -split ": "

$JustSN = $Asset.text | Select-String "SIN"

$SplittingSN = $JustSN -split ": " | Select-Object -Last 1

 

#AssetObject that we can export to CSV

 

$AssetObject = [ pscustomobject]@{

    Name = $SplittingAssetName[1]

    SN = $SplittingSN

}