#big thanks to josh duffney for this stuff
#http://duffney.io/Configure-HTTPS-DSC-PullServerPSv5
#install-module lability 
$labfolder = "c:\lability"
$labconfig = "$labfolder\configurations"
$labhotfix = "$labfolder\hotfixes"
$labiso = "$labfolder\isos"

Set-LabHostDefault -ConfigurationPath $labconfig -HotfixPath $labhotfix -IsoPath $labiso

Start-LabHostConfiguration -Verbose

#invoke-labresourcedownload -mediaid 2016_x64_datacenter_en_eval

$URI = 'https://gist.githubusercontent.com/Duffney/d62d05b3fd42b4308014bae8c586e184/raw/ec7dad827e7e0a0cd10395d6342e82c0aef2337f/DSCPullServerLab.ps1'
$content = (Invoke-WebRequest -Uri $URI).content
New-Item -Path C:\Lability\Configurations\ -Name DSCPullServerLab.ps1 -Value $content

$URI = 'https://gist.githubusercontent.com/Duffney/77f038437abbd742fa3b0614bf6471a4/raw/e9cb784edad0758bf2244e475e40cfc80fa06cfd/PullServerLab.psd1'
$content = (Invoke-WebRequest -Uri $URI).content
New-Item -Path C:\Lability\Configurations\ -Name DSCPullServerLab.psd1 -Value $content