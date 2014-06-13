# NetBackup Server - Policy
Function Get-NetBackupPolicy
{
<#
.SYNOPSIS
   The function Get-NetBackupPolicy list all the policies from the Master Server
.DESCRIPTION
   The function Get-NetBackupPolicy list all the policies from the Master Server
.PARAMETER AllPolicies
	List all the Policies with all properties
.EXAMPLE
	Get-NetBackupPolicy
	
	List all the policies name
.EXAMPLE
	Get-NetBackupPolicy -AllPolicies
	
	List all the Policies with all properties
#>

	[CmdletBinding()]
	PARAM (
		[parameter(ParameterSetName = "AllPolicies")]
		[switch]$AllPolicies
	<#	[parameter(ParameterSetName = "hwos")]
		[switch]$HardwareAndOS,
		[parameter(ParameterSetName = "FullListing")]
		[switch]$FullListing,
		[parameter(ParameterSetName = "Raw")]
		[switch]$RawOutputMode,
		[parameter(ParameterSetName = "byclient", Mandatory)]
		[Switch]$ByClient,
		[parameter(ParameterSetName = "byclient", Mandatory)]
		[String]$ClientName
	#>
		)
	
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

Function Get-NetBackupClient
{
<#
.Synopsis
   The function Get-NetbackupClient list all the client known from the Master Server
.DESCRIPTION
   The function Get-NetbackupClient list all the client known from the Master Server
.EXAMPLE
	Get-NetBackupClient
	
	List all the clients registered in NetBackup Database
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
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
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

# NetBackup Server - Disk Media Status

function Get-NetBackupDiskMedia
{
<#
.SYNOPSIS
   The function Get-NetbackupDiskMedia list information related to the Disk Media
.DESCRIPTION
   The function Get-NetbackupDiskMedia list information related to the Disk Media
.PARAMETER StorageServer
    Lists all servers that host storage. These include Symantec provided storage.
.PARAMETER DiskPool
    Lists all imported disk pools in the NetBackup database.
.PARAMETER Mount
    Lists the disk mount points for the disk pool.
.EXAMPLE
    Get-NetBackupDiskMedia -StorageServer
    
    Lists all servers that host storage. These include Symantec provided storage
.EXAMPLE
    Get-NetBackupDiskMedia -DiskPool
    
    Lists all imported disk pools in the NetBackup database.
    
.EXAMPLE
    Get-NetBackupDiskMedia -Mount
    
    Lists the disk mount points for the disk pool.
#>

[CmdletBinding()]
PARAM(
    [Parameter(ParameterSetName="StorageServer",Mandatory = $true)]
    [Switch]$StorageServer,
    [Parameter(ParameterSetName="DiskPool",Mandatory = $true)]
    [Switch]$DiskPool,
    [Parameter(ParameterSetName="Mount",Mandatory = $true)]
    [Switch]$Mount
    )
    
    PROCESS{
        IF ($StorageServer)
        {
            $nbdevquery = nbdevquery -liststs
            Foreach ($Obj in $nbdevquery)
            {
                $obj = $obj -split "\s"
                New-Object -TypeName PSObject -Property @{
                    Version = $Obj[0]
                    StorageServer = $Obj[1]
                    ServerType = $Obj[2]
                    StorageType = $Obj[3]
                }
            }
        }
        IF ($DiskPool)
        {
            $nbdevquery = nbdevquery -listdp
            Foreach ($Obj in $nbdevquery)
            {
                $obj = $obj -split "\s"
                New-Object -TypeName PSObject -Property @{
                    Version = $Obj[0]
                    DiskPool = $Obj[1]
                    Flag1 = $Obj[2]
                    Flag2 = $Obj[3]
                    Flag3 = $Obj[4]
                    Flag4 = $Obj[5]
                    Flag5 = $Obj[6]
                    Flag6 = $Obj[7]
                    Flag7 = $Obj[8]
                    StorageServer = $Obj[9]
                }
            }
        }
        IF ($Mount)
        {
            $nbdevquery = (nbdevquery -listmounts) -as [String]
            foreach ($obj in $nbdevquery -split '\)\s')
            {
                $obj = $obj -split '\s+'
                if ($obj[10] -like "*mounted*"){$mounted = $true}
                else{$mounted = $false}
                New-Object -TypeName PSObject -Property @{
                    DiskPool = $obj[2]
                    MountPointCount= $obj[4]
                    SuRep = $obj[7]
                    StorageServer = $obj[9]
                    Mounted = $mounted
                }
            }
        }
    }
}

# NetBackup Server - Jobs

function Get-NetBackupJob
{
<#
.SYNOPSIS
   This function interacts with NetBackup jobs database (bpdbjobs)
.DESCRIPTION
   This function interacts with NetBackup jobs database
.PARAMETER Summary
    Prints a summary line for all the jobs that are stored in NBU/jobs.
.PARAMETER Full
.PARAMETER TimeStamp
.EXAMPLE
    Get-NetBackupDBjob -Summary
    
    Prints a summary line for all the jobs that are stored in NBU/jobs.
    
.EXAMPLE
    Get-NetBackupJob -Full -TimeStamp ((Get-Date).AddMinutes(-2)
#>
[CmdletBinding()]
PARAM(
    [Parameter(ParameterSetName="Summary",Mandatory = $true)]
    [Switch]$Summary,
    [Parameter(ParameterSetName="Full",Mandatory = $true)]
    [Switch]$Full,
    [Parameter(ParameterSetName="Full")]
    [DateTime]$TimeStamp
    #[Array]$JobId
    )
    PROCESS{
        if ($Summary)
        {
            $bpdpjobs = bpdbjobs -summary
            $obj = $bpdpjobs[1] -split '\s+'
            New-Object -TypeName PSObject -Property @{
                MasterServer = $obj[0]
                Queued = $obj[1]
                Requeued = $obj[2]
                Active = $obj[3]
                Success = $obj[4]
                PartSucc = $obj[5]
                Failed = $obj[6]
                Incomplete = $obj[7]
                Suspended = $obj[8]
                WaitingRetry = $obj[9]
                Total = $obj[10]
            }
        }
        IF ($Full)
        {
            IF ($TimeStamp)
            {
                $DateTime = $TimeStamp -f 'MM/dd/yyyy hh:mm:ss'
                (bpdbjobs -all_columns -t $DateTime) | 
                    ConvertFrom-Csv -Delimiter "," -header jobid,jobtype,state,status,policy,schedule,client,server,started,elapsed,ended,stunit,try,operation,kbytes,files,pathlastwritten,percent,jobpid,owner,subtype,classtype,schedule_type,priority,group,masterserver,retentionunits,retentionperiod,compression,kbyteslastwritten,fileslastwritten,filelistcount,[files],trycount,[trypid,trystunit,tryserver,trystarted,tryelapsed,tryended,trystatus,trystatusdescription,trystatuscount,[trystatuslines],trybyteswritten,tryfileswritten],parentjob,kbpersec,copy,robot,vault,profile,session,ejecttapes,srcstunit,srcserver,srcmedia,dstmedia,stream,suspendable,resumable,restartable,datamovement,snapshot,backupid,killable,controllinghost    
            }
            ELSE
            {
                (bpdbjobs -all_columns) | 
                    ConvertFrom-Csv -Delimiter "," -header jobid,jobtype,state,status,policy,schedule,client,server,started,elapsed,ended,stunit,try,operation,kbytes,files,pathlastwritten,percent,jobpid,owner,subtype,classtype,schedule_type,priority,group,masterserver,retentionunits,retentionperiod,compression,kbyteslastwritten,fileslastwritten,filelistcount,[files],trycount,[trypid,trystunit,tryserver,trystarted,tryelapsed,tryended,trystatus,trystatusdescription,trystatuscount,[trystatuslines],trybyteswritten,tryfileswritten],parentjob,kbpersec,copy,robot,vault,profile,session,ejecttapes,srcstunit,srcserver,srcmedia,dstmedia,stream,suspendable,resumable,restartable,datamovement,snapshot,backupid,killable,controllinghost
            }
        }#IF $Full
        IF ($JobId)
        {
            #$bpdpjobs = bpdbjobs -jobid 
        }
    }#PROCESS
}#function

Export-ModuleMember -Function *
