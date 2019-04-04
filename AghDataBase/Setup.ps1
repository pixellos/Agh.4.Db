IF (!(Get-Module -Name sqlps)) {
    Write-Host 'Loading SQLPS Module' -ForegroundColor DarkYellow
    Push-Location
    Import-Module sqlps -DisableNameChecking
    Pop-Location
}
  
$localScriptRoot = Get-Location;
$Server = "POPIELARZM\SQLEXPRESS"
$scripts = Get-ChildItem $localScriptRoot -Recurse  | Where-Object { $_.Extension -eq ".sql" }
  
foreach ($s in $scripts) {
    Write-Host "Running Script : " $s.Name -BackgroundColor DarkGreen -ForegroundColor White
    $script = $s.FullName
    Invoke-Sqlcmd -ServerInstance $Server -InputFile $script -Database AghDataBase
}