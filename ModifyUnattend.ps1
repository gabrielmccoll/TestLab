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



$ProductKey = "GGGGN-FT8W3-Y4M27-J84CP-Q3VJ9"
$Administrator = "TLAdmin2"
$Password = "TLAdmin3Pass!"
$Organization = "TestLandia2"
$Owner = "Boss"
$ComputerName = "PCname1"

$path = "$env:USERPROFILE\TestLab\Autounattendtest.xml"
$newfile = "$env:USERPROFILE\TestLab\Autounattendtest2.xml"
$xml = [xml](Get-Content $path)
$xmlcomponent = $xml.unattend.settings.component


$xmlcomponent.item(8).autologon.username = $Administrator
$xmlcomponent.item(8).autologon.password.value = "$Password"
$xmlcomponent.item(8).RegisteredOrganization = $Organization
$xmlcomponent.item(8).RegisteredOwner = $Owner
$xmlcomponent.item(7).ProductKey = $ProductKey
$xmlcomponent.item(7).ComputerName = $ComputerName

$xml.Save($newfile)


$xmlcomponent.item["RegisteredOwner"]
