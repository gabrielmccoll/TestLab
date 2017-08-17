#install-module lability 
$labfolder = "c:\lability"
$labconfig = "$labfolder\configurations"
$labhotfix = "$labfolder\hotfixes"
$labiso = "$labfolder\isos"
Set-LabHostDefault -ConfigurationPath $labconfig -HotfixPath $labhotfix -IsoPath $labiso