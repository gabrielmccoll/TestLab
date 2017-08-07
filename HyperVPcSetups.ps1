#Powershell to setup the VMs in Hyper V, basic desktop host hypervisor with 1 Network card.

$ServerOSIso =  "C:\ISO\Server2012R2.ISO" #location of your Server2016 (or 2012R2)iso
$VMandVHDlocation = "U:\VirtualMachines\" #where you're going to store the VMsand their Harddisks


#Pick the domain name, and then what your VMs will be prefixed and suffixed with
$Domainname = "Testlandia.com"
$DomainPre = "TL-"
$OnPremSuf = "-OnPr"

#4 Vms to make up, this will not install the commented roles. 
$DC1 = $DomainPre + "DC1" + $OnPremSuf #initial Forest, dns,dhcp and windows deployment server
$DC2 = $DomainPre + "DC2" + $OnPremSuf #second dc , dns,dhcp
$Utility = $DomainPre +  "Utility" + $OnPremSuf #File / DSC pull Server/ Cert Services
$Router = $DomainPre + "Router" + $OnPremSuf #RRAS




