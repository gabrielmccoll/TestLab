# https://docs.microsoft.com/en-us/powershell/dsc/pullserver
#https://blogs.msdn.microsoft.com/powershell/2015/10/01/powershell-dsc-faq-sorting-out-certificates/
#http://blog.superautomation.co.uk/2016/12/how-to-create-certificate-template-for.html
#you'll need to install the dsc modules to set this up
#the standard ps respository should already be set up but in case it isn't 
Register-PSrepository -default #thi should error in most cases saying it already exists

#you'll need to be running this as admin to install a module
Install-Module -Name xPSDesiredStateConfiguration -Verbose -Force -AllowClobber

