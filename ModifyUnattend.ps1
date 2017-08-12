#https://blogs.msdn.microsoft.com/sonam_rastogi_blogs/2014/05/14/update-xml-file-using-powershell/

<#This works to set it
#($xml.unattend.settings.selectnodes("*")|where {$_.ProductKey -gt 1}).ProductKey = "1233"
running this doesn't tho
$xml.unattend.settings.component.productkey | Get-Member   
Comesback as TypeName: System.String

$xml.unattend.settings.component | Get-Member
   TypeName: System.Xml.XmlElement#urn:schemas-microsoft-com:unattend#component
Doesn't have a Product Key Method or Parameter listed so that's why you can't set it that way !


This one below  works as it has a ProductKey Parameter you can set even though seems same Objecttype??
($xml.unattend.settings.selectnodes("*")|where {$_.ProductKey -gt 1}) |Get-Member
Comes back as TypeName: System.Xml.XmlElement#urn:schemas-microsoft-com:unattend#component
Because you're selecting the node, then you're editing a property of the node this works. 


($xmlcomponent |where {$_.Productkey -gt 1}).Productkey = "444"  THIS ALSO WORKS

$xmlcomponent.getelementsbytagname("ProductKey").innertext = "333" THIS WORKS, clean



#>


$Administrator = "TLAdmin2GM"
$Password = "TLAdmin3Pass!"
$Organization = "TestLandoo"
$Owner = "Boss"
$ComputerName = "PCname1edited"

$path = "$env:USERPROFILE\TestLab\Autounattendmaster.xml"
$newfile = "$env:USERPROFILE\TestLab\Autounattend.xml"
$xml = [xml](Get-Content $path)
$xmlcomponent = $xml.unattend.settings.component


#$xmlcomponent.autologon.username #= $Administrator
$xmlcomponent.autologon.password.value = "$Password"
$xmlcomponent.getelementsbytagname("Username").innertext = $Administrator
$xmlcomponent.getelementsbytagname("Name").innertext = $Administrator  
$xmlcomponent.getelementsbytagname("FullName").innertext = $Administrator
$xmlcomponent.getelementsbytagname("RegisteredOrganization").innertext = "$organization"
$xmlcomponent.getelementsbytagname("RegisteredOwner").innertext = "$owner"
$xmlcomponent.getelementsbytagname("ComputerName").innertext = "$computername"

$xmlcomponent
$xml.Save($newfile)



