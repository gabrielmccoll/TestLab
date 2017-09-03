Configuration Pull {
    param (
        [Parameter()] [ValidateNotNull()] [PSCredential] $Credential = (Get-Credential -Credential 'Administrator')        
    )
    #Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName psdscresources
    Import-DscResource -ModuleName xActiveDirectory
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName xAdcsDeployment
    
node $AllNodes.Where({$true}).NodeName {

        LocalConfigurationManager {
            RebootNodeIfNeeded   = $true;
            AllowModuleOverwrite = $true;
            ConfigurationMode = 'ApplyOnly';
        }
        
        WindowsFeature ADDSTools 
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"             
        }

        File ADFiles            
        {            
            DestinationPath = 'C:\NTDS'            
            Type = 'Directory'            
            Ensure = 'Present'            
        }
                            
        WindowsFeature ADDSInstall             
        {             
            Ensure = "Present"             
            Name = "AD-Domain-Services"
            IncludeAllSubFeature = $true
            
        }
                
        xADDomain FirstDS            
        {             
            DomainName = $Node.DomainName             
            DomainAdministratorCredential = $Credential             
            SafemodeAdministratorPassword = $Credential            
            DatabasePath = 'C:\NTDS'            
            LogPath = 'C:\NTDS'            
            DependsOn = "[WindowsFeature]ADDSInstall","[File]ADFiles"            
        }

        WindowsFeature ADCS-Cert-Authority 
        {
                Ensure = 'Present'
                Name = 'ADCS-Cert-Authority'
        }

        WindowsFeature ADCSmgmt {
            Name = 'RSAT-ADCS'
            IncludeAllSubFeature = $true
        }

        WindowsFeature WebConsole {
            Name = 'Web-Mgmt-Console'
            Ensure = 'Present'
        }

        xADCSCertificationAuthority ADCS 
        {
                Ensure = 'Present'
                Credential = $Credential
                CAType = 'EnterpriseRootCA'
                DependsOn = '[WindowsFeature]ADCS-Cert-Authority'              
        }
           
       WindowsFeature ADCS-Web-Enrollment 
       {
                Ensure = 'Present'
                Name = 'ADCS-Web-Enrollment'
                DependsOn = '[WindowsFeature]ADCS-Cert-Authority'
        }
           
       xADCSWebEnrollment CertSrv 
       {
                Ensure = 'Present'
                CAConfig = 'CertSrv'
                IsSingleInstance = 'Yes'
                Credential = $Credential
                DependsOn = '[WindowsFeature]ADCS-Web-Enrollment','[xADCSCertificationAuthority]ADCS'
        }         
}


} #end Configuration Example