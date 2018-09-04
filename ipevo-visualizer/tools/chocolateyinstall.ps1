
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$win7sp1version = [System.Version]::Parse("6.1.7601")
$version = [System.Version]$env:OS_VERSION
Write-Output($version)
#url for Windows 8+
if ($version.Build -gt $win7sp1version.Build) { 
  Write-Output("Windows 8+")
  $url        = 'https://s3-us-west-1.amazonaws.com/files.ipevo.com/download/driver/Visualizer/Visualizer_win8-10_1.5.0.5.msi.zip'
  $checksum   = 'CAB1996A326E053AAB44ECEA8EC0D11B9B4877945D2DFBF4B3B1C175E0823900'
  $fileLocation = Join-Path $toolsDir 'Visualizer_win8-10_1.5.0.5.msi'
} 
#if Windows 7 SP1
elseif ($version.Build -eq $win7sp1version.Build -and $version.Major -eq $win7sp1version.Major) {
  Write-Output("Windows 7 SP1")
  $url        = 'https://s3-us-west-1.amazonaws.com/files.ipevo.com/download/driver/Visualizer/Visualizer_win7_1.5.0.5.msi.zip'
  $checksum   = '63909A497DD684A790082E3A4C9206A23AD5AB09C16478FE29BE3F79BE53942C'
  $fileLocation = Join-Path $toolsDir 'Visualizer_win7_1.5.0.5.msi'
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
