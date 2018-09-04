
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = [System.Version](Get-CimInstance Win32_OperatingSystem).version
$win7sp1version = [System.Version]::Parse("6.1.7601")
Write-Output($version)
#url for Windows 8+
if ($version -gt $win7sp1version) { 
  Write-Output("Windows 8+")
  $url        = 'https://s3-us-west-1.amazonaws.com/files.ipevo.com/download/driver/Visualizer/Visualizer_win8-10_1.5.0.5.msi.zip'
  $checksum   = 'CAB1996A326E053AAB44ECEA8EC0D11B9B4877945D2DFBF4B3B1C175E0823900'
} 
#if Windows 7 SP1
elseif ($version -eq $win7sp1version) {
  Write-Output("Windows 7 SP1")
  $url        = 'https://s3-us-west-1.amazonaws.com/files.ipevo.com/download/driver/Visualizer/Visualizer_win8-10_1.5.0.5.msi.zip'
  $checksum   = 'CAB1996A326E053AAB44ECEA8EC0D11B9B4877945D2DFBF4B3B1C175E0823900'
} else {
  Write-Output("NOT a supported OS version")
  return
}

$fileLocation = Join-Path $toolsDir 'Visualizer_win8-10_1.5.0.5.msi'
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
