Install-Module -Name AzureAD
Connect-MsolService
cd C:\PS-Scripts
$u = Get-MsolUser -All 
.\Get-MsolUserDeviceComplianceStatus.ps1 -User $u -Export