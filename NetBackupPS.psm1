# NetBackup Client - Agent
Function Get-NetBackupAgent {}
Function Get-NetBackupAgentLogs {}
Function Install-NetBackupAgent {}


# NetBackup Server - Logs
Function Get-NetBackupServerLogs {}

# NetBackup Server - Policy
Function Add-NetBackupClientToPolicy {}
Function Get-NetBackupPolicy
{
<#
.Synopsis
   The function Get-NetBackupPolicy list all the policies from the Master Server
.DESCRIPTION
   The function Get-NetBackupPolicy list all the policies from the Master Server
#>

PARAM($AllPolicies)    
    IF ($AllPolicies)
    {
        # List the Policies
        $bppllist = bppllist -allpolicies
        FOREACH ($policy in $bppllist)
        {
            New-Object -TypeName PSObject -Property @{
                PolicyName = $policy
            }
        }
        
    }
    
    ELSE {
        # List the Policies
        $bppllist = bppllist
        FOREACH ($policy in $bppllist)
        {
            New-Object -TypeName PSObject -Property @{
                PolicyName = $policy
            }
        }
    }
}


# NetBackup Server - Clients Management
Function Get-NetBackupClients
{
<#
.Synopsis
   The function Get-NetbackupClients list all the client known from the Master Server
.DESCRIPTION
   The function Get-NetbackupClients list all the client known from the Master Server
#>


    # Get the client list for the command bpplclients
    Write-Verbose -Message "Querying Bpplclients..."
    $bpplclients = bpplclients.exe
    
    Write-Verbose -Message "Formatting and Output result..."
    Foreach ($client in (($bpplclients)[2..($bpplclients.count)])){
        
        # Remove the white spaces, replace by space character
        $client = $client -replace '\s+',' '
        
        # Split on space character
        $client = $client -split ' '
    
        New-Object -TypeName PSobject -Property @{
            Hardware = $client[0]
            OS = $client[1]
            Client = $client[2]
        }
    }#Foreach
}

Function Refresh-NetBackupClientsList {}

# NetBackup Server - Backups/Restore
Function Get-NetBackupBackupJob {PARAM($Backup,$Restore)}

# NetBackup Server - Services
Function Restart-NetBackupServices {}
