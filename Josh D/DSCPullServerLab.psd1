@{
    AllNodes = @(
      @{
        NodeName = '*'
        Lability_SwitchName = 'External'
        DomainName = 'labtest.com'
        Lability_StartupMemory = 2GB;
        PSDscAllowPlainTextPassword = $true;
      }
    
      @{
        NodeName = 'Pull'
        Lability_ProcessorCount = 2
        Lability_Media = '2012r2_x64_datacenter_EN_v5_1_eval'
        Lability_HasDynamicMemory = $false
      }
  )

  NonNodeData = @{

    Lability = @{
      # Prefix all of our VMs with 'DSC-' in Hyper-V
     # EnvironmentPrefix         = 'DSC-'

      Network = @(
        @{
          Name              = 'External'
          Type              = 'External'
          NetadapterName    = 'Ethernet'
          AllowManagementOS = $true
        }
      ) # network
    
        DSCResource = @(
          @{ Name = 'xActiveDirectory'; MinimumVersion = '2.16.0.0'; }
          @{ Name = 'xPSDesiredStateConfiguration'; MinimumVersion = '6.0.0.0'; }
          @{ Name = 'xAdcsDeployment'; MinimumVersion = '1.1.0.0'; }
      )

    } # lability'

  } # nonnodedate
}