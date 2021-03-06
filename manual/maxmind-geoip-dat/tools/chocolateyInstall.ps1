#Using personal website, because codeplex doesn't allow do download without registration (is there a way?)
$packageName = 'maxmind-geoip-dat'


if ([string]::IsNullOrEmpty($env:chocolateyPackageParameters))
{
	#Write-ChocolateyFailure 'Path parameter not found. Please specify -params "path=c:\\package-path\\directory"'
	Write-Error "No parameters found. Please specify at least one using -params 'name=value'"
	throw
}
else
{
	if (!$env:chocolateyPackageParameters.ToLower().Contains("path"))
	{
		Write-Error "Path parameter not found. Please specify at least one using -params 'path=c:\test\'"
		throw
	}
}

$rawTxt =  [regex]::escape($env:chocolateyPackageParameters)
$params = $($rawTxt -split ';' | ForEach-Object {
   $temp= $_ -split '='
   "{0}={1}" -f $temp[0].Substring(0,$temp[0].Length),$temp[1]
} | ConvertFrom-StringData)

if ($params.path -ne $null){	
	
	foreach( $path in $params.path)
	{
		$MaxMindDBLocation = $params.path
		$MaxMindGeoIP = @(
	        'http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz',
	        'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz',
	        'http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz'
	    )
		
		
		$MaxMindGeoIPTargetFiles = @(
	        'GeoIP.dat',
	        'GeoLiteCity.dat',
	        'GeoIPASNum.dat'
	    )
	
	    
	    if (!(Test-Path -Path $MaxMindDBLocation)) {
	        if ($pscmdlet.ShouldProcess("Create MAxMind Database Directory @ $MaxMindDBLocation")) {
	            New-Item -ItemType Directory -Path $MaxMindDBLocation | Out-Null
	        }
	    }
		
		
		foreach ($file in $MaxMindGeoIPTargetFiles)
		{
			$strFileName = "${MaxMindDBLocation}\\${file}"
			If (Test-Path $strFileName)
			{
				$oFile = New-Object System.IO.FileInfo $strFileName
				try
				{	
					$oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
                	$oStream.Close()
					
					
				}
				catch
				{
					Write-ChocolateyFailure 'Error' "$($_.Exception.Message)"
					throw
				}
				Remove-Item $strFileName
			}
		}
	    if ($pscmdlet.ShouldProcess("Connect to MaxMind Webiste")) {
	        ForEach ($url in $MaxMindGeoIP) {
	            if ($pscmdlet.ShouldProcess("Download : $url")) {
					Install-ChocolateyZipPackage $packageName $url $MaxMindDBLocation
	            }
	        }	       
	    }	
	}
	Write-ChocolateySuccess $packageName
}
else
{
	Write-Error "Path parameter not found. Please specify -params 'path=c:\test\'"
	throw
}