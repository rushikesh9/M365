# 1. Connect if you haven't already
# Connect-ExchangeOnline

# 2. Get only standard Distribution Groups to avoid "invalid mailbox" errors
$Groups = Get-DistributionGroup -ResultSize Unlimited -ErrorAction SilentlyContinue

$Results = foreach ($Group in $Groups) {
    try {
        # Fetch members for the current group
        $Members = Get-DistributionGroupMember -Identity $Group.ExternalDirectoryObjectId -ResultSize Unlimited -ErrorAction Stop
        
        foreach ($Member in $Members) {
            [PSCustomObject]@{
                GroupName   = $Group.DisplayName
                GroupEmail  = $Group.PrimarySmtpAddress
                MemberName  = $Member.DisplayName
                MemberEmail = $Member.PrimarySmtpAddress
                MemberType  = $Member.RecipientType
            }
        }
    }
    catch {
        # This catches groups that throw the "not a valid mailbox" error
        Write-Warning "Skipping $($Group.DisplayName): $($_.Exception.Message)"
    }
}

# 3. Export to your desktop
$Results | Export-Csv -Path "$home\Desktop\M365_DL_Members.csv" -NoTypeInformation
Write-Host "Report generated at $home\Desktop\M365_DL_Members.csv" -ForegroundColor Green
