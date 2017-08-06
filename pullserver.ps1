# https://docs.microsoft.com/en-us/powershell/dsc/pullserver

Register-PSrepository -Name "psgallery" -SourceLocation "https://www.powershellgallery.com/api/v2/"
Install-Module -Name xPSDesiredStateConfiguration -Verbose -Force -AllowClobber