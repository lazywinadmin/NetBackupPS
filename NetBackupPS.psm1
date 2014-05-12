function Get-NetBackupClient
{
<#
.Synopsis
   The function Get-Netbackup
.DESCRIPTION
   Long description
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

function Get-NetBackupPolicy
{

    # List the Policies
    $bppllist = bppllist
    foreach ($policy in $bppllist)
    {
        New-Object -TypeName PSObject -Property @{
            PolicyName = $policy
        }
    }
}
