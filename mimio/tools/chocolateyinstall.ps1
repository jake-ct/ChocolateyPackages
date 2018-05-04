
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://s3.amazonaws.com/mimiostudio11.5/mimio-studio-11.54-en.msi'
$fileLocation = Join-Path $toolsDir 'mimio-studio-11.54-en.msi'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  file          = $fileLocation

  softwareName  = 'Mimio*'

  checksum      = '73AC44C2DDC47CA7D74E6113ACB437D4AEB2838AD734E59F65DC0A4C1E8BC787'
  checksumType  = 'sha256'


  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs