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


# NetBackup Server - Volume
function Get-NetBackupVolume
{
<#
.SYNOPSIS
   This function queries the EMM database for volume information (vmquery)
.DESCRIPTION
   This function queries the EMM database for volume information (vmquery)
.PARAMETER PoolName
    Specify the PoolName you want to query
.PARAMETER MediaID
    Specify the MediaID(s) to display
.EXAMPLE
    Get-NetBackupVolume -PoolName Scratch
    
    This will return all the volumes in the Pool named Scratch
    
VaultName        : ---
VaultSessionID   : ---
MacMountsAllowed : ---
AssignedDate     : ---
LastMountedDate  : ---
FirstMount       : ---
VolumePool       : Scratch (4)
MediaDescription : ---
VaultSlot        : ---
ExpirationDate   : ---
NumberOfMounts   : 0
VaultContainerID : -
Created          : 18/12/2012 4
Barcode          : WT0161L3
VaultSentDate    : ---
RobotType        : NONE - Not Robotic (0)
VaultReturnDate  : ---
VolumeGroup      : ---
MediaType        : 1/2" cartridge tape 3 (24)
MediaID          : WT0161

VaultName        : ---
VaultSessionID   : ---
MacMountsAllowed : ---
AssignedDate     : ---
LastMountedDate  : ---
FirstMount       : ---
VolumePool       : Scratch (4)
MediaDescription : ---
VaultSlot        : ---
ExpirationDate   : ---
NumberOfMounts   : 0
VaultContainerID : -
Created          : 19/12/2012 4
Barcode          : WT0166L3
VaultSentDate    : ---
RobotType        : NONE - Not Robotic (0)
VaultReturnDate  : ---
VolumeGroup      : ---
MediaType        : 1/2" cartridge tape 3 (24)
MediaID          : WT0166

VaultName        : ---
VaultSessionID   : ---
MacMountsAllowed : ---
AssignedDate     : ---
LastMountedDate  : ---
FirstMount       : ---
VolumePool       : Scratch (4)
MediaDescription : ---
VaultSlot        : ---
ExpirationDate   : ---
NumberOfMounts   : 0
VaultContainerID : -
Created          : 16/04/2013 3
Barcode          : WT0191L3
VaultSentDate    : ---
RobotType        : NONE - Not Robotic (0)
VaultReturnDate  : ---
VolumeGroup      : ---
MediaType        : 1/2" cartridge tape 3 (24)
MediaID          : WT0191
    
.EXAMPLE
    Get-NetBackupVolume -MediaID CC0002,DD0005
    
    This will display information for the tapes CC0002,DD0005

VaultName        : fx1
VaultSessionID   : 169
MacMountsAllowed : ---
AssignedDate     : ---
LastMounted      : 30/03/2013 4
VolumePool       : Scratch (4)
MediaDescription : ---
VaultSlot        : 34
ExpirationDate   : ---
NumberOfMounts   : 17
VaultContainerID : -
CreatedDate      : 10/01/2013 1
Barcode          : CC0002L5
VaultSentDate    : 02/04/2013 12
RobotType        : NONE - Not Robotic (0)
VaultReturnDate  : ---
VolumeGroup      : fx1_offsite
MediaType        : 1/2" cartridge tape 3 (24)
FirstMount       : 15/01/2013 6
MediaID          : CC0002

VaultName        : tapedepot
VaultSessionID   : 497
MacMountsAllowed : ---
AssignedDate     : ---
LastMounted      : 08/01/2014 2
VolumePool       : Scratch (4)
MediaDescription : ---
VaultSlot        : 341
ExpirationDate   : ---
NumberOfMounts   : 11
VaultContainerID : -
CreatedDate      : 09/10/2013 8
Barcode          : DD0005L3
VaultSentDate    : 08/01/2014 4
RobotType        : NONE - Not Robotic (0)
VaultReturnDate  : 22/02/2014 6
VolumeGroup      : fx1_offsite
MediaType        : 1/2" cartridge tape 3 (24)
FirstMount       : 14/10/2013 2
MediaID          : DD0005
#>
[CmdletBinding()]
PARAM(
    [Parameter(ParameterSetName="PoolName",Mandatory = $true)]
    [String]$PoolName,
    [Parameter(ParameterSetName="MediaID",Mandatory = $true)]
    [ValidateLength(1,6)]
    [String[]]$MediaID
    )
    PROCESS
    {
        IF ($PoolName)
        {
            Write-Verbose -Message "PROCESS - vmquery on PoolName: $poolname"
            $OutputInfo = (vmquery -pn $PoolName)
            
            # Get rid of empty spaces and replace by :
            $OutputInfo = $OutputInfo -replace ":\s+",":"

            # Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
            $OutputInfo = $OutputInfo -replace "\Z",","

            #Convert to [string]
            $OutputInfo = $OutputInfo -as [string]

            # Split each object
            $OutputInfo = $OutputInfo -split "================================================================================,"

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
                    VaultSentDate = ($obj[8] -split ":")[1]
                    VaultReturnDate = ($obj[9] -split ":")[1]
                    VaultSlot = ($obj[10] -split ":")[1]
                    VaultSessionID = ($obj[11] -split ":")[1]
                    VaultContainerID = ($obj[12] -split ":")[1]
                    Created = ($obj[13] -split ":")[1]
                    AssignedDate = ($obj[14] -split ":")[1]
                    LastMountedDate = ($obj[15] -split ":")[1]
                    FirstMount = ($obj[16] -split ":")[1]
                    ExpirationDate = ($obj[17] -split ":")[1]
                    NumberOfMounts = ($obj[18] -split ":")[1]
                    MacMountsAllowed = ($obj[19] -split ":")[1]
                }#new-Object
            }#foreach
        }#IF $Poolname

        IF ($MediaID)
        {
            FOREACH ($Media in $MediaID)
            {
                TRY{
                    Write-Verbose -Message "PROCESS - vmquery on MediaID: $Media"
                    #$OutputInfo = Invoke-command -ScriptBlock {(vmquery -m $Media 2>"$env:temp\netuser.err")}
                    $OutputInfo = vmquery -m $Media 2>"$env:temp\vmquery_media.err"
                    # Remove first and last line
                    $OutputInfo = $OutputInfo[1..($OutputInfo.count - 2)]
                
                    # Get rid of empty spaces and replace by :
                    $OutputInfo = $OutputInfo -replace ":\s+",":"

                    # Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
                    $OutputInfo = $OutputInfo -replace "\Z",","

                    # Convert to String
                    $OutputInfo = $OutputInfo -as [String]

                    # Split on comma
                    $OutputInfo = $OutputInfo -split ","

                    New-Object -TypeName PSObject -Property @{
                        MediaID = ($OutputInfo[0] -split ":")[1]
                        MediaType = ($OutputInfo[1] -split ":")[1]
                        Barcode = ($OutputInfo[2] -split ":")[1]
                        MediaDescription = ($OutputInfo[3] -split ":")[1]
                        VolumePool = ($OutputInfo[4] -split ":")[1]
                        RobotType = ($OutputInfo[5] -split ":")[1]
                        VolumeGroup = ($OutputInfo[6] -split ":")[1]
                        VaultName = ($OutputInfo[7] -split ":")[1]
                        VaultSentDate = ($OutputInfo[8] -split ":")[1]
                        VaultReturnDate = ($OutputInfo[9] -split ":")[1]
                        VaultSlot = ($OutputInfo[10] -split ":")[1]
                        VaultSessionID = ($OutputInfo[11] -split ":")[1]
                        VaultContainerID = ($OutputInfo[12] -split ":")[1]
                        CreatedDate = ($OutputInfo[13] -split ":")[1]
                        AssignedDate = ($OutputInfo[14] -split ":")[1]
                        LastMounted = ($OutputInfo[15] -split ":")[1]
                        FirstMount = ($OutputInfo[16] -split ":")[1]
                        ExpirationDate = ($OutputInfo[17] -split ":")[1]
                        NumberOfMounts = ($OutputInfo[18] -split ":")[1]
                        MacMountsAllowed = ($OutputInfo[19] -split ":")[1]
                    }#new-Object
                }
                CATCH{
                    Write-Warning -Message "PROCESS - Error on MediaID: $Media"
                }
            }#FOREACH ($Media in $MediaID)
        }#IF $MediaID
    }#process
}#function Get-NetBackupVolume
Export-ModuleMember -Function *
