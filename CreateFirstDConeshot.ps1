

##########EXTRACT THE ISO #################
$isoloc ="C:\ISOs\6mnth2016.ISO"   ##where the iso currently is
$isoOut ="C:\ISOs\6mnth2016ext"  ##where you'll extract the iso too

start-process -Wait -FilePath "$env:ProgramFiles\7-zip\7z.exe" `
-ArgumentList "x $isoloc -o$isoOut -y"

########################EDIT THE XML ##########################

#https://blogs.msdn.microsoft.com/sonam_rastogi_blogs/2014/05/14/update-xml-file-using-powershell/
##where's the master and where will you copy to
$path = "$env:USERPROFILE\TestLab\Autounattendmaster.xml" ##This is setup to work with Server 2016. Don't mod it.
$newxmlfile = "$env:USERPROFILE\TestLab\Autounattend.xml"  ##you can change this


$Administrator = "TLAdmin2GM"
$Password = "TLAdmin3Pass!"
$Organization = "TestLandoo"
$Owner = "Boss"
$ComputerName = "PCname1edited"


$xml = [xml](Get-Content $path)
$xmlcomponent = $xml.unattend.settings.component


$xmlcomponent.autologon.password.value = "$Password"
$xmlcomponent.useraccount.AdministratorPassword.value = "$Password"
$xmlcomponent.getelementsbytagname("Username").innertext = $Administrator
$xmlcomponent.getelementsbytagname("Name").innertext = $Administrator  
$xmlcomponent.getelementsbytagname("FullName").innertext = $Administrator
$xmlcomponent.getelementsbytagname("Description").innertext = $Administrator
$xmlcomponent.getelementsbytagname("Displayname").innertext = $Administrator
$xmlcomponent.getelementsbytagname("RegisteredOrganization").innertext = "$organization"
$xmlcomponent.getelementsbytagname("RegisteredOwner").innertext = "$owner"
$xmlcomponent.getelementsbytagname("ComputerName").innertext = "$computername"

$xmlcomponent
$xml.Save($newxmlfile)


####################CREATE THE ISO ################################
# where the files from the iso were extracted to
$filesforiso = "$isoOut"
#copy the unattendxml into the extracted files location before it gets wrapped
Copy-Item -Path $newxmlfile -Destination $filesforiso
#what the new iso will be called
$newiso = "C:\ISOs\6mnth2016GMMOD.iso"


#this following function isnt mine tho I may edited it a LITTLE from the original . all credit to original author
#https://gallery.technet.microsoft.com/scriptcenter/New-ISOFile-function-a8deeffd

function New-IsoFile  
{  
  <#  
   .Synopsis  
    Creates a new .iso file  
   .Description  
    The New-IsoFile cmdlet creates a new .iso file containing content from chosen folders  
   .Example  
    New-IsoFile "c:\tools","c:Downloads\utils"  
    This command creates a .iso file in $env:temp folder (default location) that contains 
    c:\tools and c:\downloads\utils folders. The folders themselves are included at the 
    root of the .iso image.  
   .Example 
    New-IsoFile -FromClipboard -Verbose 
    Before running this command, select and copy (Ctrl-C) files/folders in Explorer first.  
   .Example  
    dir c:\WinPE | New-IsoFile -Path c:\temp\WinPE.iso 
    -BootFile "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\ ~~~
    ~Deployment Tools\amd64\Oscdimg\efisys.bin" -Media DVDPLUSR -Title "WinPE" 
    This command creates a bootable .iso file containing the content from c:\WinPE folder,
     but the folder itself isn't included. Boot file etfsboot.com can be found in Windows ADK. 
    Refer to IMAPI_MEDIA_PHYSICAL_TYPE enumeration for possible media types:
     http://msdn.microsoft.com/en-us/library/windows/desktop/aa366217(v=vs.85).aspx  
   .Notes 
    NAME:  New-IsoFile  
    AUTHOR: Chris Wu 
    LASTEDIT: 03/23/2016 14:46:50  
 #>  
  
  [CmdletBinding(DefaultParameterSetName='Source')]Param( 
    [parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true, ParameterSetName='Source')]$Source,  
    [parameter(Position=2)][string]$Path = "$env:temp\$((Get-Date).ToString('yyyyMMdd-HHmmss.ffff')).iso",  
    [ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$BootFile = $null, 
    [ValidateSet('CDR','CDRW','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','BDR','BDRE')][string] $Media = 'DVDPLUSRW_DUALLAYER', 
    [string]$Title = (Get-Date).ToString("yyyyMMdd-HHmmss.ffff"),  
    [switch]$Force, 
    [parameter(ParameterSetName='Clipboard')][switch]$FromClipboard 
  ) 
 
  Begin {  
    ($cp = new-object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = '/unsafe' 
    if (!('ISOFile' -as [type])) {  
      Add-Type -CompilerParameters $cp -TypeDefinition @' 
public class ISOFile  
{ 
  public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks)  
  {  
    int bytes = 0;  
    byte[] buf = new byte[BlockSize];  
    var ptr = (System.IntPtr)(&bytes);  
    var o = System.IO.File.OpenWrite(Path);  
    var i = Stream as System.Runtime.InteropServices.ComTypes.IStream;  
  
    if (o != null) { 
      while (TotalBlocks-- > 0) {  
        i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes);  
      }  
      o.Flush(); o.Close();  
    } 
  } 
}  
'@  
    } 
  
    if ($BootFile) { 
      if('BDR','BDRE' -contains $Media) { Write-Warning "Bootable image doesn't seem to work with media type $Media" } 
      ($Stream = New-Object -ComObject ADODB.Stream -Property @{Type=1}).Open()  # adFileTypeBinary 
      $Stream.LoadFromFile((Get-Item -LiteralPath $BootFile).Fullname) 
      ($Boot = New-Object -ComObject IMAPI2FS.BootOptions).AssignBootImage($Stream) 
    } 
 
    $MediaType = @('UNKNOWN','CDROM','CDR','CDRW','DVDROM','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','HDDVDROM','HDDVDR','HDDVDRAM','BDROM','BDR','BDRE') 
 
    Write-Verbose -Message "Selected media type is $Media with value $($MediaType.IndexOf($Media))" 
    ($Image = New-Object -com IMAPI2FS.MsftFileSystemImage -Property @{VolumeName=$Title}).ChooseImageDefaultsForMediaType($MediaType.IndexOf($Media)) 
  
    if (!($Target = New-Item -Path $Path -ItemType File -Force:$Force -ErrorAction SilentlyContinue)) { Write-Error -Message "Cannot create file $Path. Use -Force parameter to overwrite if the target file already exists."; break } 
  }  
 
  Process { 
    if($FromClipboard) { 
      if($PSVersionTable.PSVersion.Major -lt 5) { Write-Error -Message 'The -FromClipboard parameter is only supported on PowerShell v5 or higher'; break } 
      $Source = Get-Clipboard -Format FileDropList 
    } 
 
    foreach($item in $Source) { 
      if($item -isnot [System.IO.FileInfo] -and $item -isnot [System.IO.DirectoryInfo]) { 
        $item = Get-Item -LiteralPath $item 
      } 
 
      if($item) { 
        Write-Verbose -Message "Adding item to the target image: $($item.FullName)" 
        try { $Image.Root.AddTree($item.FullName, $true) } catch { Write-Error -Message ($_.Exception.Message.Trim() + ' Try a different media type.') } 
      } 
    } 
  } 
 
  End {  
    if ($Boot) { $Image.BootImageOptions=$Boot }  
    $Result = $Image.CreateResultImage()  
    [ISOFile]::Create($Target.FullName,$Result.ImageStream,$Result.BlockSize,$Result.TotalBlocks) 
    Write-Verbose -Message "Target image ($($Target.FullName)) has been created" 
    $Target 
  } 
} 

dir $filesforiso | New-IsoFile -Path $newiso -force -BootFile "$filesforiso\boot\etfsboot.com" -Media DISK -Title "Win2016mod6mo"

################### NEW ISO CREATED ##################

############# CREATE THE VM ON LOCAL HYPER V ###################

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
$ServerOSIso =  "$newiso" #location of your Server2016 (or 2012R2)iso
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

 