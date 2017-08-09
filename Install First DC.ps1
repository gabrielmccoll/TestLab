Install-WindowsFeature dns,dhcp,ad-domain-services -IncludeAllSubFeature -IncludeManagementTools -Restart

#https://technet.microsoft.com/en-us/library/hh974720(v=wps.630).aspx

#To create seccure password for recovery
$PlainPassword = "Redc0ver1!"
$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force
$domainname = "Testlandia.com"
#domainmode forest mode , 7 is 2016 ,6 is 2912r2
$domainmode = 7
$forestmode = 7

Install-ADDSForest -DomainName $domainname -DomainMode $domainmode -ForestMode $forestmode -SafeModeAdministratorPassword $SecurePassword -WhatIf