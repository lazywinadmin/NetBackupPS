# NetBackup Server - Policy
Function Get-NetBackupPolicy
{
<#
.Synopsis
   The function Get-NetBackupPolicy list all the policies from the Master Server
.DESCRIPTION
   The function Get-NetBackupPolicy list all the policies from the Master Server
#>
	[CmdletBinding()]
	PARAM (
		[parameter(ParameterSetName = "AllPolicies")]
		[switch]$AllPolicies,
		[parameter(ParameterSetName = "hwos")]
		[switch]$HardwareAndOS,
		[parameter(ParameterSetName = "FullListing")]
		[switch]$FullListing,
		[parameter(ParameterSetName = "Raw")]
		[switch]$RawOutputMode,
		[parameter(ParameterSetName = "byclient", Mandatory)]
		[Switch]$ByClient,
		[parameter(ParameterSetName = "byclient", Mandatory)]
		[String]$ClientName)
	
	Write-Verbose -Message "NetBackup - BPPLLIST - List policy information"
	IF ($AllPolicies)
	{
		# List the Policies
		$bppllist = bppllist -allpolicies
		
		# Split the Policies
		$bppllist = $bppllist -split "CLASS\s"
		
		FOREACH ($policy in $bppllist)
		{
			#http://www.symantec.com/business/support/index?page=content&id=HOWTO90333
			New-Object -TypeName PSObject -Property @{
				PolicyName = ($policy[0] -split " ")[0]
				CLASS = ($policy[0] -split " ")
				NAMES = ($policy[1] -split " ")
				INFO = ($policy[2])[5..($policy[2].count)] -split " "
				KEY = ($policy[3])[4..($policy[3].count)] -split " "
				BCMD = ($policy[4])[5..($policy[4].count)] -split " "
				RCMD = ($policy[5])[5..($policy[5].count)] -split " "
				RES = ($policy[6])
				POOL = ($policy[7])[5..($policy[7].count)] -split " "
			}
		}
		
	}
	
	ELSE
	{
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
	Foreach ($client in (($bpplclients)[2..($bpplclients.count)]))
	{
		
		# Remove the white spaces, replace by space character
		$client = $client -replace '\s+', ' '
		
		# Split on space character
		$client = $client -split ' '
		
		New-Object -TypeName PSobject -Property @{
			Hardware = $client[0]
			OS = $client[1]
			Client = $client[2]
		}
	}#Foreach
}

# NetBackup Server - Global Configuration
function Get-NetBackupConfiguration
{
<#
	
#>
	[CmdletBinding()]
	PARAM (
		[Parameter(ParameterSetName="DisplayFormat",Mandatory=$true)]
		[switch]$DisplayFormat,
		[Parameter(ParameterSetName = "LongFormat", Mandatory = $true)]
		[switch]$LongFormat,
		[Parameter(ParameterSetName = "ShortFormat", Mandatory = $true)]
		[switch]$ShortFormat
	)
	
	Write-Verbose -Message "NetBackup - BPCONFIG - Display global configuration attributes for NetBackup"
	
	IF ($DisplayFormat)
	{
		$bpconfig = bpconfig -U
		New-Object -TypeName PSObject -Property @{
			AdministratorEmailAddress = ($bpconfig[1] -split ":\s+")[1]
			JobRetryDelay = ($bpconfig[2] -split ":\s+")[1]
			MaximumSimultaneousJobsPerClient = ($bpconfig[3] -split ":\s+")[1]
			BackupTries = ($bpconfig[4] -split ":\s+")[1]
			KeepErrorsDebugLogs = ($bpconfig[5] -split ":\s+")[1]
			MaxDrivesThisMaster = ($bpconfig[6] -split ":\s+")[1]
			KeepTrueImageRecoveryInfo = ($bpconfig[7] -split ":\s+")[1]
			CompressImageDBFiles = ($bpconfig[8] -split ":\s+")[1]
			MediaMountTimeout = ($bpconfig[9] -split ":\s+")[1]
			SharedMediaMountTimeout = ($bpconfig[10] -split ":\s+")[1]
			DisplayReports = ($bpconfig[11] -split ":\s+")[1]
			PreprocessInterval = ($bpconfig[12] -split ":\s+")[1]
			MaximumBackupCopies = ($bpconfig[13] -split ":\s+")[1]
			ImageDBCleanupInterval = ($bpconfig[14] -split ":\s+")[1]
			ImageDBCleanupWaitTime = ($bpconfig[15] -split ":\s+")[1]
			PolicyUpdateInterval = ($bpconfig[16] -split ":\s+")[1]
		}
		
	}
	IF ($LongFormat)
	{
		$bpconfig = bpconfig -L
		New-Object -TypeName PSObject -Property @{
			AdministratorEmailAddress = ($bpconfig[1] -split ":\s+")[1]
			JobRetryDelay = ($bpconfig[2] -split ":\s+")[1]
			MaximumSimultaneousJobsPerClient = ($bpconfig[3] -split ":\s+")[1]
			BackupTries = ($bpconfig[4] -split ":\s+")[1]
			KeepErrorsDebugLogs = ($bpconfig[5] -split ":\s+")[1]
			MaxDrivesThisMaster = ($bpconfig[6] -split ":\s+")[1]
			CompressImageDBFiles = ($bpconfig[7] -split ":\s+")[1]
			MediaMountTimeout = ($bpconfig[8] -split ":\s+")[1]
			SharedMediaMountTimeout = ($bpconfig[9] -split ":\s+")[1]
			DisplayReports = ($bpconfig[10] -split ":\s+")[1]
			KeepTIRinfo = ($bpconfig[11] -split ":\s+")[1]
			PreprocessInterval = ($bpconfig[12] -split ":\s+")[1]
			MaximumBackupCopies = ($bpconfig[13] -split ":\s+")[1]
			ImageDBCleanupInterval = ($bpconfig[14] -split ":\s+")[1]
			ImageDBCleanupWaitTime = ($bpconfig[15] -split ":\s+")[1]
			PolicyUpdateInterval = ($bpconfig[16] -split ":\s+")[1]
		}
		
	}
	IF ($ShortFormat)
	{
		$bpconfig = bpconfig -l
		$bpconfig = $bpconfig -split " "
		New-Object -TypeName PSObject -Property @{
			AdministratorEmailAddress = $bpconfig[0]
			JobRetryDelay = $bpconfig[1]
			BackupTimePeriod = $bpconfig[2]
			MaximumSimultaneousJobsPerClient = $bpconfig[3]
			BackupTries = $bpconfig[4]
			KeepErrorsDebugLogs = $bpconfig[5]
			MaxDrivesThisMaster = $bpconfig[6]
			CompressImageDBFiles = $bpconfig[7] 	# 0 denotes no compression
			MediaMountTimeout = $bpconfig[8] 		# 0 denotes unlimited
			SharedMediaMountTimeout = $bpconfig[9] 	# Multihosted-media-mount timeout is 0 seconds; 0 denotes unlimited.
			PostProcessImagesFlag = $bpconfig[10]	# 1 is immediate
			DisplayReports = $bpconfig[11] 			#Display reports from x hours ago
			KeepTIRinfo = $bpconfig[12] 			#Keep TIR information for one x day.
			PreprocessInterval = $bpconfig[13]
			ImageDBCleanupInterval = $bpconfig[14]
			ImageDBCleanupWaitTime = $bpconfig[15]
			PolicyUpdateInterval = $bpconfig[16]
		}
	}
}



Export-ModuleMember -Function *

<#
#TODO

# NetBackup Client - Agent
Function Get-NetBackupAgent { }
Function Get-NetBackupAgentLogs { }
Function Install-NetBackupAgent { }


# NetBackup Server - Logs
Function Get-NetBackupServerLogs { }

# NetBackup Server - Policy
Function Add-NetBackupClientToPolicy { }
Function Get-NetBackupPolicyQueries #/usr/openv/netbackup/logs/PolicyQueries.log

# NetBackup Server - Clients Management
Function Refresh-NetBackupClientsList {}

# NetBackup Server - Backups/Restore
Function Get-NetBackupBackupJob {PARAM($Backup,$Restore)}

# NetBackup Server - Services
Function Restart-NetBackupServices {}



#>
