#https://blogs.msdn.microsoft.com/sonam_rastogi_blogs/2014/05/14/update-xml-file-using-powershell/

#$xml.unattend.settings.selectnodes("*")|where {$_.name -like "*shell*"}


$ProductKey = "GGGGN-FT8W3-Y4M27-J84CP-Q3VJ9"
$Administrator = "TLAdmin2"
$Password = "TLAdmin3Pass!"
$Organization = "TestLandia2"
$Owner = "Boss"
$ComputerName = "PCname1"

$path = "C:\Users\breau\TestLab\Autounattendtest.xml"
$newfile = "C:\Users\breau\TestLab\Autounattendtest2.xml"
$xml = [xml](Get-Content $path)
$xmlcomponent = $xml.unattend.settings.component


$xmlcomponent.item(8).autologon.username = $Administrator
$xmlcomponent.item(8).autologon.password.value = "$Password"
$xmlcomponent.item(8).RegisteredOrganization = $Organization
$xmlcomponent.item(8).RegisteredOwner = $Owner
$xmlcomponent.item(7).ProductKey = $ProductKey
$xmlcomponent.item(7).ComputerName = $ComputerName

$xml.Save($newfile)
