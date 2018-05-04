$ErrorActionPreference = 'Stop'; # stop on all errors
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'MimioStudio'  #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  fileType      = 'MSI' #only one of these: MSI or EXE (ignore MSU for now)
  # MSI
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1605, 1614, 1641) # https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
}

$uninstalled = $false

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % { 
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    }

    $mimiosys = Get-Process -Name "mimiosys" -ErrorAction SilentlyContinue
    $mimiotools = Get-Process -Name "tools" -ErrorAction SilentlyContinue
    $mimionotebook = Get-Process -Name "notebook" -ErrorAction SilentlyContinue
    $mimiogradebook = Get-Process -Name "gradebook" -ErrorAction SilentlyContinue 

    if ($mimiosys) {
      Stop-Process -Name "mimiosys"
    }
    if ($mimiotools) {
      Stop-Process -Name "tools"
    }
    if ($mimionotebook) {
      Stop-Process -Name "notebook"
    }
    if ($mimiogradebook) {
      Stop-Process -Name "gradebook"
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}

