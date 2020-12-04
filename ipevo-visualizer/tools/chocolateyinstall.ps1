
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$win10version = [System.Version]::Parse("10.0.10240")
$win7sp1version = [System.Version]::Parse("6.1.7601")
$version = [System.Version]$env:OS_VERSION
Write-Output($version)
#url for Windows 10+
if ($version.Build -ge $win10version.Build) { 
  Write-Output("Windows 10+")
  $url        = 'https://ipevo-api-cms.s3-us-west-1.amazonaws.com/software/visualizer/download/Windows_10/Visualizer_win10_v2.1.373.0.msi.zip'
  $checksum   = 'C22336B8630257FCEA0AE1AB0CCFF03B5E7B1C69F1688D0BDA1D1FD46B2E6CB2'
  $fileLocation = Join-Path $toolsDir 'Visualizer_win10_v2.1.373.0.msi'
} 
#if Windows 7-8
elseif ($version.Build -ge $win7sp1version.Build -and $version.Build -lt $win10version.Build) {
  Write-Output("Windows 7-8")
  $url        = 'https://ipevo-api-cms.s3-us-west-1.amazonaws.com/software/visualizer/download/Windows_7-10/Visualizer_win7-10_v1.14.289.0.msi.zip'
  $checksum   = '9B42BDF1C65336378280173F7439A2972AE8A9E74F7BECA6810F225C1FAA98D3'
  $fileLocation = Join-Path $toolsDir 'Visualizer_win7-10_v1.14.289.0.msi'
} else {
  Write-Output("NOT a supported OS version")
  return
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file          = $fileLocation

  softwareName  = 'Visualizer*'

  checksum      = $checksum
  checksumType  = 'sha256'


  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}


Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs
