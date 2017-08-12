#Powershell to setup the VMs in Hyper V, basic desktop host hypervisor with 1 Network card.
#REMEMBER YOU'LL NEED TO START YOUR IDE AS ADMIN 

$Hypervisor = "localhost" #change this if you're setting it up on a remote PC
Set-VMhost -EnableEnhancedSessionMode $TRUE 


#https://technet.microsoft.com/en-us/itpro/powershell/windows/hyper-v/new-vmswitch
#CREATE THE VIRTUAL SWITCH
$SwitchName = "External" #change these if you like.
#switch type (external,private,internal isn't needed as we are using the netadaptername parameter which auto makes it External
$SwitchNote = "created by script"
$networkcardtobind = "Wifi" #get this by running get-netadapter and using the name of the one you want

#make new switch
New-VMSwitch -ComputerName $Hypervisor -Name $SwitchName -NetAdapterName $networkcardtobind -AllowManagementOS $true -note $SwitchNote

##Switch is now created for using with the new VMs


##VM global settings
#Pick the domain name, and then what your VMs will be prefixed and suffixed with
$Domainname = "Testlandia.com"
$DomainPre = "TL-"
$OnPremSuf = "-OnPr"
$ServerOSIso =  "C:\ISOs\6mnth2016GMMOD.ISO" #location of your Server2016 (or 2012R2)iso
$VMandVHDlocation = "C:\VirtualMachines\" #where you're going to store the VMsand their Harddisks
$generation = "1" #this is to ensure compatability with Azure
#example PC name TL-DC1-OnPr the suffix is to differentiate from on-premises/local and cloud hosted


##vm specific settings
#4 Vms to make up, this will not install the commented roles. 
#https://technet.microsoft.com/en-us/itpro/powershell/windows/hyper-v/new-vhd
#https://technet.microsoft.com/en-us/itpro/powershell/windows/hyper-v/new-vm
$DC1 = $DomainPre + "DC1" + $OnPremSuf #initial Forest, dns,dhcp and windows deployment server
$DC2 = $DomainPre + "DC2" + $OnPremSuf #second dc , dns,dhcp
$Utility = $DomainPre +  "Utility" + $OnPremSuf #File / DSC pull Server/ Cert Services
$Router = $DomainPre + "Router" + $OnPremSuf #RRAS


#Create DC1
#create the vhd then the vm 
$vmname = $dc1 #setting it this way to make this code more reusable
$vhddest = $VMandVHDlocation + "$vmname\" + "VHD\$vmname.vhd" #where the vhd is
$vmdest = $VMandVHDlocation #where keeping the vm
$vhdsize = 80GB 
$vmmemory = 2GB #startup memory, it will use dynamic memory anyway
$vmprocessors = 2 #how many processors you want
$bootdevice = "CD"

#create the vhd
New-VHD -Dynamic -Path $vhddest -SizeBytes $vhdsize -ComputerName $Hypervisor

#create the vm, set the number of processors, the ISO to the DVD/CD drive, start all inegration services then start the VM
New-VM -Name $vmname -MemoryStartupBytes $vmmemory -Path $vmdest -BootDevice $bootdevice -VHDPath $vhddest -SwitchName $SwitchName -ComputerName $Hypervisor
Set-VM -VMName $vmname -ComputerName $Hypervisor -ProcessorCount $vmprocessors
Set-VMDvdDrive -VMName $vmname -Path $ServerOSIso -ComputerName $Hypervisor
Get-VMIntegrationService -ComputerName $Hypervisor -VMName $vmname | Enable-VMIntegrationService
Start-VM -VMName $vmname -ComputerName $Hypervisor

 