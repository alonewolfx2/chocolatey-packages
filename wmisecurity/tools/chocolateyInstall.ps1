#Using personal website, because codeplex doesn't allow do download without registration (is there a way?)
$url='http://blog.kireev.co/wp-content/uploads/wmisecurity.zip'
$packageName = 'wmisecurity'

Install-ChocolateyZipPackage $packageName $url "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 