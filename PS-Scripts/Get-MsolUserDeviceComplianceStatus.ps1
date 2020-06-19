param (
    [PSObject[]]$users = @(),
    [Switch]$export,
    [String]$exportFileName = "UserDeviceComplianceStatus_" + (Get-Date -Format "yyMMdd_HHMMss") + ".csv",
    [String]$exportPath = [Environment]::GetFolderPath("Desktop")
 )

[System.Collections.IDictionary]$script:schema = @{
    
    DisplayName = ''
    ApproximateLastLogonTimestamp = ''
    RegisteredOwnerDisplayName = ''
    
}

function createResultObject
{

    [PSObject]$resultObject = New-Object -TypeName PSObject -Property $script:schema

    return $resultObject
}

If ($users.Count -eq 0)
{
    $users = Get-MsolUser
}

[PSObject[]]$result = foreach ($u in $users)
{
    
    [PSObject]$devices = get-msoldevice -RegisteredOwnerUpn $u.UserPrincipalName
    foreach ($d in $devices)
    {
        [PSObject]$deviceResult = createResultObject
                
        $deviceResult.DisplayName = $d.DisplayName
        $deviceResult.RegisteredOwnerDisplayName = $u.DisplayName
        $deviceResult.ApproximateLastLogonTimestamp = $d.ApproximateLastLogonTimestamp

        $deviceResult 
    }

}

If ($export)
{
    $result | Export-Csv -path ($exportPath + "\" + $exportFileName) -NoTypeInformation
}
Else
{
    $result
}