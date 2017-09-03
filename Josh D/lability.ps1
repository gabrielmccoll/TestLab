#big thanks to josh duffney for this stuff
#http://duffney.io/Configure-HTTPS-DSC-PullServerPSv5
#install-module lability 
$labfolder = "c:\lability"
$labconfig = "$labfolder\configurations"
$labhotfix = "$labfolder\hotfixes"
$labiso = "$labfolder\isos" 


#might need to install these 
Install-Module PSDscResources,xActiveDirectory, xPSDesiredStateConfiguration, xAdcsDeployment -Verbose;



Set-LabHostDefault -ConfigurationPath $labconfig -HotfixPath $labhotfix -IsoPath $labiso

Start-LabHostConfiguration -Verbose
#you can get list of available media using get-labmedia, then download by invoking. I used a different one from article so I needed to edit th .psd
#invoke-labresourcedownload -mediaid 2016_x64_Datacenter_EN_Eval

$URI = 'https://gist.githubusercontent.com/Duffney/d62d05b3fd42b4308014bae8c586e184/raw/ec7dad827e7e0a0cd10395d6342e82c0aef2337f/DSCPullServerLab.ps1'
$content = (Invoke-WebRequest -Uri $URI).content
New-Item -Path C:\Lability\Configurations\ -Name DSCPullServerLab.ps1 -Value $content

$URI = 'https://gist.githubusercontent.com/Duffney/77f038437abbd742fa3b0614bf6471a4/raw/e9cb784edad0758bf2244e475e40cfc80fa06cfd/PullServerLab.psd1'
$content = (Invoke-WebRequest -Uri $URI).content
New-Item -Path C:\Lability\Configurations\ -Name DSCPullServerLab.psd1 -Value $content

#if you have multiple versions of a module, delete all but latest

Get-Module -ListAvailable -FullyQualifiedName xPSDesiredStateConfiguration #might need this with psdscresources too
#if need to remove old versions
#Get-Module -ListAvailable -FullyQualifiedName xPSDesiredStateConfiguration | where {$_.version -ne "7.0.0.0"}| Uninstall-Module

cd c:\Lability\Configurations
.\DSCPullServerLab.ps1 #this should load and run but if not then just open with code xxxx and run it, i got errors until I put import-module on seperate lines

#This next part generates the MOFs, the Pull command is from loading the ps1 file into memory. You can type "code .\DSCPullServerLab.ps1" to look at it
#code .\DSCPullServerLab.psd1 will let you edit the config parameters needed if changed media type above
Pull1 -ConfigurationData .\DSCPullServerLab.psd1 -OutputPath C:\Lability\Configurations\

#now build it using the mof and psd , I had to remove the environement prefix from the .psd
Start-LabConfiguration -ConfigurationData .\DSCPullServerLab.psd1 -Verbose -Force

#might need this but doesn't fix it 
#Set-LabHostDefault -DismPath "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\Microsoft.Dism.PowerShell.dll"