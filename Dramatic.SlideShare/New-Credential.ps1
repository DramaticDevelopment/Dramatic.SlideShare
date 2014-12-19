# New-Credential.ps1
# Create a new PSCredential
#
# Dec 2014
# If this works, this was written by Victor Vogelpoel (victor@victorvogelpoel.nl)
# If it doesn't work, I don't know who wrote this.


function New-Credential
{ 
	[CmdletBinding()]
	param
	( 
		[Parameter(Position=0, Mandatory=$true, HelpMessage="User name (in format DOMAIN\USER)")]
        [ValidateNotNullOrEmpty()]
		[string]$UserName, 
		
		[Parameter(Position=1, Mandatory=$true, HelpMessage="Password, cannot be empty")]
        [ValidateNotNullOrEmpty()]
		[string]$Password
	) 
	
	# Create the credential 
	return New-Object System.Management.Automation.PSCredential $UserName, (ConvertTo-SecureString -AsPlainText $Password -Force) 
	
<# 
    .SYNOPSIS 
       A function to create a credential object from script. 
    .DESCRIPTION 
       Enables you to create a credential objects from stored details. 
    .PARAMETER UserId 
       The userid in the form of "domain\user" 
    .PARAMETER Password 
       The password for this user 
    .EXAMPLE 
       New-Credential DOMAIN\user the_password 
#> 
} 
