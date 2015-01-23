# Dramatic.SlideShare.psm1
# Module to talk to the SlideShare API
# Dec 2014
# If this works, this was written by Victor Vogelpoel (victor@victorvogelpoel.nl)
# If it doesn't work, I don't know who wrote this.


#requires -version 3.0 
Set-PSDebug -Strict
Set-StrictMode -Version Latest


# Allways stop at an error
$global:ErrorActionPreference 	= "Stop"


#----------------------------------------------------------------------------------------------------------------------
# Set variables
$script:thisModuleDirectory			= $PSScriptRoot								# Directory path\Dramatic.SlideShare\


#----------------------------------------------------------------------------------------------------------------------
# Storage for the SlideShare API key
[string]$script:APIKey              = ""
[string]$script:SharedSecret        = ""


#----------------------------------------------------------------------------------------------------------------------
# Store the personal SlideShare API Key information in the module with script scope.
function Use-SSApiKey
{
	[CmdletBinding()]
	param
	( 
        [Parameter(Position=0, Mandatory=$true, HelpMessage="SlideShare API private key")]
        [ValidateNotNullOrEmpty()]
        [string]$APIKey,

        [Parameter(Position=1, Mandatory=$false, HelpMessage="SlideShare API shared secret")]
        [ValidateNotNullOrEmpty()]
        [string]$SharedSecret
    )

    $script:APIKey       = $APIKey
    $script:SharedSecret = $SharedSecret
}


#----------------------------------------------------------------------------------------------------------------------
# Construct a custom object with API key and the hash to use in the API calls.
function Get-SSAPIValidation
{
    # Unix timestamp
    $timestamp = [int][double]::Parse($(Get-Date -date (Get-Date).ToUniversalTime()-uformat %s));

    return [PSCustomObject]@{

        APIKey = $script:APIKey

        timestamp = $timestamp

        # Create an SHA1 hash from the concatenation of the shared secret and the timestamp
        hash = ([System.Security.Cryptography.HashAlgorithm]::Create('SHA1').ComputeHash((New-Object System.Text.UTF8Encoding).GetBytes("$($script:SharedSecret)$timestamp")) | foreach { $_.ToString("x2") }) -join ''
    }
}

#----------------------------------------------------------------------------------------------------------------------
# Dot source any related scripts and functions in the same directory as this module
$ignoreCommandsForDotSourcing = @(
)

Get-ChildItem $script:thisModuleDirectory\*.ps1 | foreach { 

	if ($ignoreCommandsForDotSourcing -notcontains $_.Name)
	{
		Write-Verbose "Importing functions from file '$($_.Name)' by dotsourcing `"$($_.Fullname)`""
		. $_.Fullname
	}
	else
	{
		Write-Verbose "Ignoring file '$($_.Name)'"
	}
}
