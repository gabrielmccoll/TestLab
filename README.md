# TestLab
set of tools to make testlabs for local or in Azure

Requirements  
Hyper V /Vmware workstation (initial scripts will focus on hyperv)  
Windows Server 2012 r2 or 2016 datacentre (trial is fine)  
Azure account (for the Azure part)  

Broad Outline


Powershell create initial domain controller, Forest, dns,dhcp and windows deployment server- DC1  
walk through gui manually    
Setup WDS with config files and isos for any further server creation 

Powershell create second dc , dns,dhcp  - DC2  
WDS should take care of it  
 
Third server is File / DSC pull Server/ Cert Services - Utility  
setup this via Powershell DSC

4rth Server RRAS  - Router   
setup via DSC and WDS