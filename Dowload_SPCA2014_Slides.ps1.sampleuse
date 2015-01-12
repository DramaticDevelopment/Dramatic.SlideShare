# Dowload_SPCA2014_Slides.ps1
# Dec 2014
# If this works, this was written by Victor Vogelpoel (victor@victorvogelpoel.nl)
# If it doesn't work, I don't know who wrote this.

Remove-Module 'Dramatic.SlideShare' -force -ErrorAction SilentlyContinue

import-module (Join-Path $PSScriptRoot '.\SlideShare\Dramatic.SlideShare.psd1')

$downloadfolder = 'C:\Users\victorv\Documents\WindowsPowerShell\SPCA2014Data'
if (!(Test-Path $downloadfolder))
{
    throw "Folder `"$downloadFolder`" does not exist. Please create it first."
}

# Set the api key and secrets for all commands
# Request your SlideShare API key at http://www.slideshare.net/developers/applyforapi
Use-SSApiKey -APIKey 'YOUR_APIKEY' -SharedSecret 'YOUR_SHAREDSECRET'

# Find the slide decks by user NCCOMMS which title starts with 'Spca2014'
$allSlideData       = Get-SlideShareUserSlideShow -UserNameFor 'nccomms' -Limit 9999
$spca2014SlideDecks = $allSlideData.Where{$_.title -like 'Spca2014*'}

Write-Host "Found $(@($spca2014SlideDecks).Count) slide decks; downloading to `"$downloadfolder`"..."

foreach ($slideDeck in $spca2014SlideDecks)
{
    # Now process each slideshow entry

    # Get the SlideShare PDF download url (which points to Amazon S3)
    $sourceFile = $slideDeck.DownloadUrl

    # Extract the filename 
    $filename = (New-Object Uri($sourceFile)).Segments | select -last 1 # get filename part of the url
    # Create a destination file path in the download folder
    $destFilePath = Join-Path $downloadfolder $filename

    Write-Host "From `"$SourceFile`"`nTo `"$destFilePath`""

    # And download the deck file to the specified download folder
    Invoke-WebRequest -Uri $sourceFile -OutFile $destFilePath
}
