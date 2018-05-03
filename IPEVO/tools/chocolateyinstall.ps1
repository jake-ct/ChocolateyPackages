
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://s3-us-west-1.amazonaws.com/files.ipevo.com/download/driver/ipevo_presenter/Presenter_win_6.8.1.1.msi.zip'
$fileLocation = Join-Path $toolsDir 'Presenter_win_6.8.1.1.msi'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file          = $fileLocation

  softwareName  = 'Presentor_win_*'

  checksum      = '51CA765B84418ECBF7DC4F07DF94D4BEFA673F7BE0BC9A3193C5DB5E33D9A3F6'
  checksumType  = 'sha256'


  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs









    








