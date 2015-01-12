# Get-SlideShareUserSlideShow.ps1
# Get the Slideshows by the specified user
#
# Dec 2014
# If this works, this was written by Victor Vogelpoel (victor@victorvogelpoel.nl)
# If it doesn't work, I don't know who wrote this.

function Get-SlideShareUserSlideShow
{
	[CmdletBinding()]
	param
	( 
        [Parameter(Position=0, Mandatory=$true, HelpMessage="Username of owner of slideshows")]
        [ValidateNotNullOrEmpty()]
        [string]$UserNameFor,

        [Parameter(Position=1, Mandatory=$false, HelpMessage="Credential (username, password) of requesting user")]
        [PSCredential]$RequestingUser,

        [Parameter(Position=2, Mandatory=$false, HelpMessage="Specify the number of slideshows to return")]
        [int]$Limit = 10,

        [Parameter(Mandatory=$false, HelpMessage="Specify offset")]
        [int]$Offset = 0,

        [Parameter(Mandatory=$false, HelpMessage="Return a detailed response")]
        [switch]$Detailed,

        [Parameter(Mandatory=$false, HelpMessage="Whether or not to include unconverted slideshows")]
        [switch]$GetUnconverted
	) 

    # Get the validation data for the API call
    $APIValidation = Get-SSAPIValidation

    # Construct the query url
    $slideshareAPIGetSlideShowsForUserUri = "https://www.slideshare.net/api/2/get_slideshows_by_user?username_for=$UserNameFor&limit=$Limit&api_key=$($APIValidation.APIKey)&hash=$($APIValidation.Hash)&ts=$($APIValidation.TimeStamp)"

    # Now query the SlideShare API for user user slides
    Write-Verbose "Query SlideShare API: $slideshareAPIGetSlideShowsForUserUri"
    $slideShareData = Invoke-RestMethod -uri $slideshareAPIGetSlideShowsForUserUri
    
    if ($slideShareData.SelectSingleNode('SlideShareServiceError'))
    {
        # ERROR
        throw ( $slideShareData.SlideShareServiceError.Message | foreach { $_.'#text' } )
    }
    elseif ([int]($slideShareData.SelectSingleNode('User/Count').'#text') -gt 0)
    {
        # TODO Convert XML to objects
        Write-Output $slideShareData.User.Slideshow
    }
}