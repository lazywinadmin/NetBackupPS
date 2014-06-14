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
		$bppllist = (bppllist -allpolicies) -as [String]
		
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
	Display global configuration attributes for NetBackup
.DESCRIPTION
	Display global configuration attributes for NetBackup
.PARAMETER DisplayFormat
.PARAMETER LongFormat
.PARAMETER ShortFormat
.EXAMPLE
	Get-NetBackupConfiguration -DisplayFormat
.EXAMPLE
	Get-NetBackupConfiguration -LongFormat
.EXAMPLE
	Get-NetBackupConfiguration -ShortFormat
	
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
    Output a summary line for all the jobs that are stored in NBU/jobs.
.PARAMETER Full
    Output a full report of all the jobs in the last three days
.PARAMETER TimeStamp
    Fetches the job records based on the timestamp. Only the job records modified
    since this timestamp are displayed. The timestamp is specified in the following
    Must be a DateTime object or can be specified using "mm/dd/yyyy HH:MM:SS" format
.PARAMETER JobId
    Reports on one or multiple job IDs
.EXAMPLE
    Get-NetBackupDBjob -Summary
    
    Prints a summary line for all the jobs that are stored in NBU/jobs.
.EXAMPLE
    Get-NetBackupJob -Full
    
    Show all the job in the last three days (default is 3 days)
.EXAMPLE
    Get-NetBackupJob -Full -TimeStamp ((Get-Date).AddMinutes(-2)
    
    Show all the job from the last two minutes
    
.EXAMPLE
    Get-NetBackupJob -JobId 7149678
    
    Reports information for the job 7149678
    
.EXAMPLE
    Get-NetBackupJob -JobId 7149678, 7149679
    
    Reports information for the job 7149678 and 7149679
#>
[CmdletBinding()]
PARAM(
    [Parameter(ParameterSetName="Summary",Mandatory = $true)]
    [Switch]$Summary,
    [Parameter(ParameterSetName="Full",Mandatory = $true)]
    [Switch]$Full,
    [Parameter(ParameterSetName="Full")]
    [DateTime]$TimeStamp,
    [Parameter(ParameterSetName="JobID",Mandatory = $true)]
    [String[]]$JobId
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
            FOREACH ($JobObj in $jobID)
            {
                Write-Verbose -Message "PROCESS - bpdbjobs - JOBID:$jobID"
                (bpdbjobs -jobid $JobObj -all_columns) | 
                        ConvertFrom-Csv -Delimiter "," -header jobid,jobtype,state,status,policy,schedule,client,server,started,elapsed,ended,stunit,try,operation,kbytes,files,pathlastwritten,percent,jobpid,owner,subtype,classtype,schedule_type,priority,group,masterserver,retentionunits,retentionperiod,compression,kbyteslastwritten,fileslastwritten,filelistcount,[files],trycount,[trypid,trystunit,tryserver,trystarted,tryelapsed,tryended,trystatus,trystatusdescription,trystatuscount,[trystatuslines],trybyteswritten,tryfileswritten],parentjob,kbpersec,copy,robot,vault,profile,session,ejecttapes,srcstunit,srcserver,srcmedia,dstmedia,stream,suspendable,resumable,restartable,datamovement,snapshot,backupid,killable,controllinghost
            }
        }
    }#PROCESS
}#function Get-NetBackupJob

function Get-NetBackupVolume
{
<#
.SYNOPSIS
   This function queries the EMM database for volume information (vmquery)
.DESCRIPTION
   This function queries the EMM database for volume information (vmquery)
.PARAMETER PoolName
    Specify the PoolName you want to query
.EXAMPLE
    Get-NetBackupVolume -PoolName Scratch
    
    This will return all the volumes in the Pool named Scratch
#>
[CmdletBinding()]
PARAM($PoolName)
    PROCESS
    {
        IF($PoolName)
        {
            Write-Verbose -Message "PROCESS - vmquery on $poolname"
            $OutputInfo = (vmquery -pn $PoolName)
            
            # Get rid of empty spaces and replace by :
            $OutputInfo = $OutputInfo -replace ":\s+",":"

            # Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
            $OutputInfo = $OutputInfo -replace "\Z",","

            # Convert to [string]
            $OutputInfo = ($OutputInfo -split "================================================================================,") -as [String]
     
            foreach ($obj in $OutputInfo)
            {
                $obj = $obj -split ","
                New-Object -TypeName PSObject -Property @{
                    MediaID = ($obj[0] -split ":")[1]
                    MediaType = ($obj[1] -split ":")[1]
                    Barcode = ($obj[2] -split ":")[1]
                    MediaDescription = ($obj[3] -split ":")[1]
                    VolumePool = ($obj[4] -split ":")[1]
                    RobotType = ($obj[5] -split ":")[1]
                    VolumeGroup = ($obj[6] -split ":")[1]
                    VaultName = ($obj[7] -split ":")[1]
                    VaultSent = ($obj[8] -split ":")[1]
                    VaultReturn = ($obj[9] -split ":")[1]
                    VaultSlot = ($obj[10] -split ":")[1]
                    VaultSession = ($obj[11] -split ":")[1]
                    VaultContainer = ($obj[12] -split ":")[1]
                    Created = ($obj[13] -split ":")[1]
                    Assigned = ($obj[14] -split ":")[1]
                    LastMounted = ($obj[15] -split ":")[1]
                    FirstMount = ($obj[16] -split ":")[1]
                    ExpirationDate = ($obj[17] -split ":")[1]
                    NumberOfMounts = ($obj[18] -split ":")[1]
                    MacMountsAllowed = ($obj[19] -split ":")[1]
                }#new-Object
            
                #$obj = $obj -replace "\s\s+","" 
                #$obj = $obj -split "`n" -replace ":\s+","=" | ConvertFrom-StringData
                #$obj = ($obj -replace ":\s+","=" | ConvertFrom-StringData)
                #New-Object -TypeName PSObject -Property @{
                #    MediaID = $obj["media ID"]
                #    MediaType = $obj["media type"]
                #    BarCode = $obj["barcode"]
            }#foreach
        }#IF $Poolname
    }#process
}#function Get-NetBackupVolume

Export-ModuleMember -Function *
