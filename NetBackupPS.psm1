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
	
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01	Initial Version
	1.1 2014/09/20	Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
#>
	[CmdletBinding(DefaultParameterSetName = "AllPolicies")]
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
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupPolicy - bppllist.exe"}
	PROCESS
	{
		TRY
		{
			IF ($PSboundparameters['AllPolicies'])
			{
				# List the Policies
				Write-Verbose -Message "[PROCESS] PARAM: AllPolicies"
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
				Write-Verbose -Message "[PROCESS] NO PARAM"
				$bppllist = bppllist
				FOREACH ($policy in $bppllist)
				{
					New-Object -TypeName PSObject -Property @{
						PolicyName = $policy
					}
				}
			}
		}#TRY
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupPolicy" }
}#Get-NetBackupPolicy

Function Get-NetBackupClient
{
<#
.SYNOPSIS
   The function Get-NetbackupClient list all the client known from the Master Server
	
.DESCRIPTION
   The function Get-NetbackupClient list all the client known from the Master Server
	
.EXAMPLE
	Get-NetBackupClient
	
	List all the clients registered in NetBackup Database
	
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01  Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
#>
	[CmdletBinding()]
	PARAM ()
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupClient - bpplclients.exe" }
	PROCESS
	{
		TRY
		{
			# Get the client list for the command bpplclients
			Write-Verbose -Message "[PROCESS] Querying Bpplclients..."
			$bpplclients = bpplclients.exe
			
			Write-Verbose -Message "[PROCESS] Formatting and Output result..."
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
		}#TRY
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupClient" }
}#Get-NetBackupClient

function Get-NetBackupGlobalConfiguration
{
<#
.SYNOPSIS
	Display global configuration attributes for NetBackup
.DESCRIPTION
	Display global configuration attributes for NetBackup
.PARAMETER DisplayFormat
	Use the user-friendly format from bpconfig.exe
.PARAMETER LongFormat
	Use the LongFormat format from bpconfig.exe
.PARAMETER ShortFormat
	Use the ShortFormat format from bpconfig.exe
.EXAMPLE
	Get-NetBackupGlobalConfiguration -DisplayFormat
.EXAMPLE
	Get-NetBackupGlobalConfiguration -LongFormat
.EXAMPLE
	Get-NetBackupGlobalConfiguration -ShortFormat
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01	Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
	
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
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupGlobalConfiguration - bpconfig.exe" }
	PROCESS
	{
		TRY
		{
			Write-Verbose -Message "[PROCESS] Display global configuration attributes for NetBackup"
			
			IF ($PSBoundParameters['DisplayFormat'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: DisplayFormat"
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
			IF ($PSBoundParameters['LongFormat'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: LongFormat"
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
			IF ($PSBoundParameters['ShortFormat'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: ShortFormat"
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
		}#TRY
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupGlobalConfiguration - bpconfig.exe" }
}#Get-NetBackupGlobalConfiguration

function Get-NetBackupTapeConfiguration
{
<#
.SYNOPSIS
    This function displays the Tape Configuration (tpconfig)
.DESCRIPTION
    This function displays the Tape Configuration (tpconfig)
.PARAMETER VirtualMachineCredential
    Display the Virtual Machine Credential(s) added to NetBackup
.EXAMPLE
    Get-NetBackupTapeConfiguration -VirtualMachineCredential
    
    Display the Virtual Machine Credential(s) added to NetBackup

SubType                : 1
SubTypeName            : VMware
VirtualMachineHostType : VMware Virtual Center Server
UserID                 : fx\vm_netbackup
RequiredPort           : 0
VirtualMachineHostName : fx-vcenter

SubType                : 1
SubTypeName            : VMware
VirtualMachineHostType : VMware Virtual Center Server
UserID                 : fx\vm_netbackup
RequiredPort           : 0
VirtualMachineHostName : fx-vcenter02

SubType                : 1
SubTypeName            : VMware
VirtualMachineHostType : VMware Virtual Center Server
UserID                 : fx\vm_netbackup
RequiredPort           : 0
VirtualMachineHostName : fx-vcenter03

.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01 Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END

#>
[CmdletBinding()]
PARAM(
    [Parameter(ParameterSetName="VMCred",Mandatory = $true)]
    [Switch]$VirtualMachineCredential
	)
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupTapeConfiguration - tpconfig.exe" }
	PROCESS
	{
		TRY
		{
			IF ($PSBoundParameters['VirtualMachineCredential'])
			{
				Write-Verbose -Message "[PROCESS] Getting VirtualMachine Credentials"
				$OutputInfo = (tpconfig -dvirtualmachines)
				
				# Get rid of empty spaces and replace by :
				$OutputInfo = $OutputInfo -replace ":\s+", ":"
				
				# Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
				$OutputInfo = $OutputInfo -replace "\Z", ","
				
				#Convert to [string]
				$OutputInfo = $OutputInfo -as [string]
				
				# Split each object
				$OutputInfo = $OutputInfo -split "==============================================================================,"
				
				
				$OutputInfo = ($OutputInfo[1..($OutputInfo.count - 1)])
				
				FOREACH ($obj in $OutputInfo)
				{
					$obj = $obj -split ","
					$SubTypeName = switch (($obj[2] -split ":")[1])
					{
						"(1)" { "VMware" }
						"(2)" { "VMware ESX Servers" }
						"(3)" { "VMware Converter Servers" }
					}
					New-Object -TypeName PSObject -Property @{
						VirtualMachineHostName = ($obj[0] -split ":")[1]
						VirtualMachineHostType = ($obj[1] -split ":")[1]
						SubType = ($obj[2] -split ":")[1][1]
						SubTypeName = $SubTypeName
						UserID = ($obj[3] -split ":")[1]
						RequiredPort = ($obj[4] -split ":")[1]
					} #NEW-OBJET
				} #FOREACH
			}#IF
		}
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupTapeConfiguration - tpconfig.exe" }
}#Get-NetBackupTapeConfiguration

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
    
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01	Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
#>

[CmdletBinding(DefaultParameterSetName = "StorageServer")]
PARAM(
    [Parameter(ParameterSetName="StorageServer",Mandatory = $true)]
    [Switch]$StorageServer,
    [Parameter(ParameterSetName="DiskPool",Mandatory = $true)]
    [Switch]$DiskPool,
    [Parameter(ParameterSetName="Mount",Mandatory = $true)]
    [Switch]$Mount
    )
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupDiskMedia - nbdevquery.exe" }
    PROCESS{
		TRY
		{
			IF ($PSBoundParameters['StorageServer'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: StorageServer"
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
			IF ($PSBoundParameters['DiskPool'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: DiskPool"
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
			IF ($PSBoundParameters['Mount'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: Mount"
				$nbdevquery = (nbdevquery -listmounts) -as [String]
				foreach ($obj in $nbdevquery -split '\)\s')
				{
					$obj = $obj -split '\s+'
					if ($obj[10] -like "*mounted*") { $mounted = $true }
					else { $mounted = $false }
					New-Object -TypeName PSObject -Property @{
						DiskPool = $obj[2]
						MountPointCount = $obj[4]
						SuRep = $obj[7]
						StorageServer = $obj[9]
						Mounted = $mounted
					}
				}
			}
		}#TRY
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupDiskMedia - nbdevquery.exe" }
}
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
    
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01	Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
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
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupJob - bpdbjobs.exe" }
	PROCESS
	{
		TRY
		{
			if ($PSBoundParameters['Summary'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: Summary"
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
			IF ($PSBoundParameters['Full'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: Full"
				
				IF ($PSBoundParameters['TimeStamp'])
				{
					Write-Verbose -Message "[PROCESS] PARAM: TimeStamp"
					$DateTime = $TimeStamp -f 'MM/dd/yyyy hh:mm:ss'
					(bpdbjobs -all_columns -t $DateTime) |
					ConvertFrom-Csv -Delimiter "," -header jobid, jobtype, state, status, policy, schedule, client, server, started, elapsed, ended, stunit, try, operation, kbytes, files, pathlastwritten, percent, jobpid, owner, subtype, classtype, schedule_type, priority, group, masterserver, retentionunits, retentionperiod, compression, kbyteslastwritten, fileslastwritten, filelistcount, [files], trycount, [trypid, trystunit, tryserver, trystarted, tryelapsed, tryended, trystatus, trystatusdescription, trystatuscount, [trystatuslines], trybyteswritten, tryfileswritten], parentjob, kbpersec, copy, robot, vault, profile, session, ejecttapes, srcstunit, srcserver, srcmedia, dstmedia, stream, suspendable, resumable, restartable, datamovement, snapshot, backupid, killable, controllinghost
				}
				ELSE
				{
					(bpdbjobs -all_columns) |
					ConvertFrom-Csv -Delimiter "," -header jobid, jobtype, state, status, policy, schedule, client, server, started, elapsed, ended, stunit, try, operation, kbytes, files, pathlastwritten, percent, jobpid, owner, subtype, classtype, schedule_type, priority, group, masterserver, retentionunits, retentionperiod, compression, kbyteslastwritten, fileslastwritten, filelistcount, [files], trycount, [trypid, trystunit, tryserver, trystarted, tryelapsed, tryended, trystatus, trystatusdescription, trystatuscount, [trystatuslines], trybyteswritten, tryfileswritten], parentjob, kbpersec, copy, robot, vault, profile, session, ejecttapes, srcstunit, srcserver, srcmedia, dstmedia, stream, suspendable, resumable, restartable, datamovement, snapshot, backupid, killable, controllinghost
				}
			}#IF $Full
			IF ($PSBoundParameters['JobId'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: JobID"
				FOREACH ($JobObj in $jobID)
				{
					Write-Verbose -Message "[PROCESS] JobID:$jobID"
					(bpdbjobs -jobid $JobObj -all_columns) |
					ConvertFrom-Csv -Delimiter "," -header jobid, jobtype, state, status, policy, schedule, client, server, started, elapsed, ended, stunit, try, operation, kbytes, files, pathlastwritten, percent, jobpid, owner, subtype, classtype, schedule_type, priority, group, masterserver, retentionunits, retentionperiod, compression, kbyteslastwritten, fileslastwritten, filelistcount, [files], trycount, [trypid, trystunit, tryserver, trystarted, tryelapsed, tryended, trystatus, trystatusdescription, trystatuscount, [trystatuslines], trybyteswritten, tryfileswritten], parentjob, kbpersec, copy, robot, vault, profile, session, ejecttapes, srcstunit, srcserver, srcmedia, dstmedia, stream, suspendable, resumable, restartable, datamovement, snapshot, backupid, killable, controllinghost
				}
			}
		}#TRY
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}#CATCH
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupJob - bpdbjobs.exe" }
}#function Get-NetBackupJob

function Get-NetBackupVolume
{
<#
.SYNOPSIS
   This function queries the EMM database for volume information (vmquery)
.DESCRIPTION
   This function queries the EMM database for volume information (vmquery)
.PARAMETER PoolName
    Specify the PoolName to query
.PARAMETER RobotNumber
    Specify the RobotNumber to query
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

.EXAMPLE
    Get-NetBackupVolume -RobotNumber 23 -Poolname Scratch

    This will return the volumes in the PoolName 'Scratch' for the RobotNumber 23.

.EXAMPLE
    Get-NetBackupVolume -RobotNumber 23,19 -Poolname Scratch -Verbose

    This will return the volumes in the PoolName 'Scratch' for the RobotNumber 23 and 19.
    It will additionally show the verbose messages/comments.
    
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01	Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
#>
[CmdletBinding(DefaultParametersetName="MediaID")]
PARAM(
    [Parameter(ParameterSetName="PoolName")]
    [String]$PoolName,
    [Parameter(ParameterSetName="PoolName")]
    [Int[]]$RobotNumber,
    [Parameter(ParameterSetName="MediaID",Mandatory = $true)]
    [ValidateLength(1,6)]
    [String[]]$MediaID
    )
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupJob - vmquery" }
	PROCESS
	{
		TRY
		{
			IF ($PSBoundParameters['RobotNumber'] -and $PSboundParameters['PoolName'])
			{
				FOREACH ($RobotNo in $RobotNumber)
				{
					Write-Verbose -Message "[PROCESS] vmquery on RobotNumber $RobotNo and PoolName $PoolName"
					$OutputInfo = (vmquery -rn $RobotNo)
					# Get rid of empty spaces and replace by :
					$OutputInfo = $OutputInfo -replace ":\s+", ":"
					
					# Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
					$OutputInfo = $OutputInfo -replace "\Z", ","
					
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
							RobotNumber = ($obj[6] -split ":")[1]
							RobotSlot = ($obj[7] -split ":")[1]
							RobotControlHost = ($obj[8] -split ":")[1]
							VolumeGroup = ($obj[9] -split ":")[1]
							VaultName = ($obj[10] -split ":")[1]
							VaultSentDate = ($obj[11] -split ":")[1]
							VaultReturnDate = ($obj[12] -split ":")[1]
							VaultSlot = ($obj[13] -split ":")[1]
							VaultSessionID = ($obj[14] -split ":")[1]
							VaultContainerID = ($obj[15] -split ":")[1]
							CreatedDate = ($obj[16] -split ":")[1]
							AssignedDate = ($obj[17] -split ":")[1]
							FirstMountDate = ($obj[18] -split ":")[1]
							ExpirationDate = ($obj[19] -split ":")[1]
							NumberOfMounts = ($obj[20] -split ":")[1]
							MacMountsAllowed = ($obj[21] -split ":")[1]
							Status = ($obj[22] -split ":")[1]
						} | Where-Object { $_.VolumePool -like "*$PoolName*" }
					}#foreach ($obj in $OutputInfo)
				}# FOREACH ($RobotNo in $RobotNumber)
			} #IF ($RobotNumber -and $PoolName)
			
			IF ($PSBoundParameters['RobotNumber'] -and -not ($PSboundParameters['PoolName']))
			{
				FOREACH ($RobotNo in $RobotNumber)
				{
					Write-Verbose -Message "[PROCESS] vmquery on RobotNumber $RobotNo"
					$OutputInfo = (vmquery -rn $RobotNo)
					# Get rid of empty spaces and replace by :
					$OutputInfo = $OutputInfo -replace ":\s+", ":"
					
					# Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
					$OutputInfo = $OutputInfo -replace "\Z", ","
					
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
							RobotNumber = ($obj[6] -split ":")[1]
							RobotSlot = ($obj[7] -split ":")[1]
							RobotControlHost = ($obj[8] -split ":")[1]
							VolumeGroup = ($obj[9] -split ":")[1]
							VaultName = ($obj[10] -split ":")[1]
							VaultSentDate = ($obj[11] -split ":")[1]
							VaultReturnDate = ($obj[12] -split ":")[1]
							VaultSlot = ($obj[13] -split ":")[1]
							VaultSessionID = ($obj[14] -split ":")[1]
							VaultContainerID = ($obj[15] -split ":")[1]
							CreatedDate = ($obj[16] -split ":")[1]
							AssignedDate = ($obj[17] -split ":")[1]
							FirstMountDate = ($obj[18] -split ":")[1]
							ExpirationDate = ($obj[19] -split ":")[1]
							NumberOfMounts = ($obj[20] -split ":")[1]
							MacMountsAllowed = ($obj[21] -split ":")[1]
							Status = ($obj[22] -split ":")[1]
						}#new-Object
					}#foreach
				}#FOREACH ($RobotNo in $RobotNumber)
			}# IF ($RobotNumber -and -not($PoolName))
			
			IF ($PSboundParameters['PoolName'] -and -not ($PSBoundParameters['RobotNumber']))
			{
				Write-Verbose -Message "PROCESS - vmquery on PoolName: $poolname"
				$OutputInfo = (vmquery -pn $PoolName)
				
				# Get rid of empty spaces and replace by :
				$OutputInfo = $OutputInfo -replace ":\s+", ":"
				
				# Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
				$OutputInfo = $OutputInfo -replace "\Z", ","
				
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
						CreatedDate = ($obj[13] -split ":")[1]
						AssignedDate = ($obj[14] -split ":")[1]
						LastMountedDate = ($obj[15] -split ":")[1]
						FirstMount = ($obj[16] -split ":")[1]
						ExpirationDate = ($obj[17] -split ":")[1]
						NumberOfMounts = ($obj[18] -split ":")[1]
						MacMountsAllowed = ($obj[19] -split ":")[1]
					}#new-Object
				}#foreach
			}#IF $Poolname
			
			IF ($PSboundParameters['MediaID'])
			{
				FOREACH ($Media in $MediaID)
				{
					TRY
					{
						Write-Verbose -Message "PROCESS - vmquery on MediaID: $Media"
						#$OutputInfo = Invoke-command -ScriptBlock {(vmquery -m $Media 2>"$env:temp\netuser.err")}
						$OutputInfo = vmquery -m $Media 2>"$env:temp\vmquery_media.err"
						# Remove first and last line
						$OutputInfo = $OutputInfo[1..($OutputInfo.count - 2)]
						
						# Get rid of empty spaces and replace by :
						$OutputInfo = $OutputInfo -replace ":\s+", ":"
						
						# Add a comma at the end of each line to delimit each object (this is needed when the object $outputinfo is converted to STRING)
						$OutputInfo = $OutputInfo -replace "\Z", ","
						
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
					CATCH
					{
						Write-Warning -Message "PROCESS - Error on MediaID: $Media"
					}
				}#FOREACH ($Media in $MediaID)
			}#IF $MediaID
		}
		CATCH
		{
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}#PROCESS
	END{Write-Verbose -Message "[END] Function Get-NetBackupJob - vmquery"}
}#function Get-NetBackupVolume

function Get-NetBackupProcess
{
<#
.SYNOPSIS
   This function list all processes and statistics for each process (bpps)
.DESCRIPTION
   This function list all processes and statistics for each process (bpps)
.PARAMETER ProcessGroup
    Specify the ProcessGroup to query, below are the ProcessGroups available:

MM_ALL
    All Media Manager processes.
MM_CLIS
    Media Manager command line programs.
MM_CORE
    Media Manager core processes.
MM_GUIS
    Media Manager GUI programs.
MM_SERVICES
    Media Manager services.
MM_UIS
    Media Manager user interface programs.
MM_WORKERS
    Media Manager worker processes.
NB_ALL
    All NetBackup, Media Manager, and ARO processes.
NB_ALL_CLIS
    All NetBackup and Media Manager command line programs.
NB_ALL_CORE
    All NetBackup, Media Manager, and ARO core processes.
NB_ALL_GUIS
    All NetBackup and Media Manager GUI programs.
NB_ALL_SERVICES
    All NetBackup and Media Manager Services.
NB_ALL_UIS
    All NetBackup and Media Manager user interface programs.
NB_ALL_WORKERS
    All NetBackup and Media Manager worker processes.
NB_CLIENT_ALL
    All NetBackup client processes.
NB_CLIENT_CLIS
    NetBackup client command line programs.
NB_CLIENT_CORE
    NetBackup client core processes.
NB_CLIENT_GUIS
    NetBackup client GUI programs.
NB_CLIENT_SERVICES
    NetBackup client services.
NB_CLIENT_UIS
    NetBackup client user interface p
NB_CLIENT_WORKERS
    NetBackup client worker processes.
NB_SERVER_ALL
    All NetBackup Server processes.
NB_SERVER_CLIS
    NetBackup Server command line programs.
NB_SERVER_CORE
    NetBackup Server core processes.
NB_SERVER_GUIS
    NetBackup Server GUI programs.
NB_SERVER_SERVICES
    NetBackup Server services.
NB_SERVER_UIS
    NetBackup Server user interface programs.
NB_SERVER_WORKERS
    NetBackup Server worker processes.
NBDB_SERVICES
    NetBackup Database services.
NBDB_CLIS
    NetBackup Database command line programs.
NBDB_ALL
    All NetBackup Database processes.
VLT_CORE
    Core Vault processes.
VLT_GUIS
    Vault GUI programs.
VLT_CLIS
    Vault command line programs.
VLT_UIS
    Vault user interface programs.
VLT_ALL
    All Vault processes.
OTHER_PROCESSES
    All processes not included in NB_ALL

.PARAMETER ComputerName
    Specify one or more NetBackup Server(s) to query

.EXAMPLE
    Get-NetBackupProcess -ProcessGroup MM_ALL -ComputerName Server01, Server02
    
.NOTES
	Francois-Xavier Cat
	LazyWinAdmin.com
	@Lazywinadm
	
	https://github.com/lazywinadmin/NetBackupPS
	
	HISTORY
	1.0 2014/06/01	Initial Version
	1.1 2014/09/20  Add Errors handling and Verbose
					Add Blocks BEGIN,PROCESS,END
#>
[CmdletBinding()]
PARAM(
    [Parameter()]
    [ValidateSet(
        "MM_ALL",
        "MM_CLIS",
        "MM_CORE",
        "MM_GUIS",
        "MM_SERVICES",
        "MM_UIS",
        "MM_WORKERS",
        "NB_ALL",
        "NB_ALL_CLIS",
        "NB_ALL_CORE",
        "NB_ALL_GUIS",
        "NB_ALL_SERVICES",
        "NB_ALL_UIS",
        "NB_ALL_WORKERS",
        "NB_CLIENT_ALL",
        "NB_CLIENT_CLIS",
        "NB_CLIENT_CORE",
        "NB_CLIENT_GUIS",
        "NB_CLIENT_SERVICES",
        "NB_CLIENT_UIS",
        "NB_CLIENT_WORKERS",
        "NB_SERVER_ALL",
        "NB_SERVER_CLIS",
        "NB_SERVER_CORE",
        "NB_SERVER_GUIS",
        "NB_SERVER_SERVICES",
        "NB_SERVER_UIS",
        "NB_SERVER_WORKERS",
        "NBDB_SERVICES",
        "NBDB_CLIS",
        "NBDB_ALL",
        "VLT_CORE",
        "VLT_GUIS",
        "VLT_CLIS",
        "VLT_UIS",
        "VLT_ALL",
        "OTHER_PROCESSES")]
    [String]$ProcessGroup,
    [String[]]$ComputerName
	)
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupProcess - bpps.exe" }
    PROCESS{
        TRY {
            IF ($PSBoundParameters['ProcessGroup'] -and $PSBoundParameters['ComputerName'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: ProcessGroup and $ComputerName"
                FOREACH ($Computer in $ComputerName)
				{
					Write-Verbose -Message "[PROCESS] Working on $Computer"
                    $bpps = bpps -i $ProcessGroup $Computer
                    $bpps_server = ($bpps[0] -split "\s")[1]
                    $bpps = $bpps[2..$bpps.count]
                    foreach ($obj in $bpps)
                    {
                        $obj = $obj -split "\s{2,}"
                        New-Object -TypeName PSObject -Property @{
                            ComputerName = $bpps_server
                            Name = $obj[0]
                            Pid = $obj[1]
                            Load = $obj[2]
                            Time = $obj[3]
                            MemMB = $obj[4] -replace "M",""
                            Start = $obj[5]
                        }#New-Object
                    }#Foreach
                }#FOREACH ($Computer in $ComputerName)
            }#IF ($ProcessGroup -and $ComputerName)

            IF ($PSBoundParameters['ProcessGroup'] -and -not($PSBoundParameters['ComputerName']))
			{
				Write-Verbose -Message "[PROCESS] PARAM: ProcessGroup"
                $bpps = bpps -i $ProcessGroup
                $bpps_server = ($bpps[0] -split "\s")[1]
                $bpps = $bpps[2..$bpps.count]
                foreach ($obj in $bpps)
                {
                    $obj = $obj -split "\s{2,}"
                    New-Object -TypeName PSObject -Property @{
                        ComputerName = $bpps_server
                        Name = $obj[0]
                        Pid = $obj[1]
                        Load = $obj[2]
                        Time = $obj[3]
                        MemMB = $obj[4] -replace "M",""
                        Start = $obj[5]
                    }#New-Object
                }#Foreach
            }#IF ($ProcessGroup -and -not$ComputerName)

            IF (-not($PSBoundParameters['ProcessGroup']) -and $PSBoundParameters['ComputerName'])
			{
				Write-Verbose -Message "[PROCESS] PARAM: ComputerName"
                FOREACH ($Computer in $ComputerName)
				{
					Write-Verbose -Message "[PROCESS] Working on $Computer"
                    $bpps = bpps $Computer
                    $bpps_server = ($bpps[0] -split "\s")[1]
                    $bpps = $bpps[2..$bpps.count]
                    foreach ($obj in $bpps)
                    {
                        $obj = $obj -split "\s{2,}"
                        New-Object -TypeName PSObject -Property @{
                            ComputerName = $bpps_server
                            Name = $obj[0]
                            Pid = $obj[1]
                            Load = $obj[2]
                            Time = $obj[3]
                            MemMB = $obj[4] -replace "M",""
                            Start = $obj[5]
                        }#New-Object
                    }#Foreach
                }#FOREACH ($Computer in $ComputerName)
            }#IF (-not$ProcessGroup -and $ComputerName)

            ELSE
			{
				Write-Verbose -Message "[PROCESS] No PARAM"
                $bpps = bpps
                $bpps_server = ($bpps[0] -split "\s")[1]
                $bpps = $bpps[2..$bpps.count]

                foreach ($obj in $bpps)
                {
                    $obj = $obj -split "\s{2,}"
                    New-Object -TypeName PSObject -Property @{
                        ComputerName = $bpps_server
                        Name = $obj[0]
                        Pid = $obj[1]
                        Load = $obj[2]
                        Time = $obj[3]
                        MemMB = $obj[4] -replace "M",""
                        Start = $obj[5]
            
                    }#New-Object
                }#Foreach
            } #ELSE
        }#TRY
        CATCH
        {
			Write-Warning -Message "[PROCESS] Something wrong happened"
			Write-Warning -Message $Error[0].Exception.Message
        }#CATCH
	}#PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupProcess - bpps.exe" }
}#function Get-NetBackupProcess

function Get-NetBackupStatusCode
{
<#
.SYNOPSIS
	Return the clear text of Status Codes for troubleshooting
.DESCRIPTION
	Return the clear text of Status Codes for troubleshooting.
	
	The list of status codes is statically defined in the module
.PARAMETER StatusCode
	Status code number you wish to lookup
.EXAMPLE
	Get-NetBackupStatusCode -StatusCode 2
	
	C:\ > Get-NetBackupStatusCode -StatusCode 2
		None of the requested files were backed up
.NOTES
	Kevin M. Kirkpatrick
	https://github.com/vN3rd
	www.vmotioned.com
	@vN3rd
	
	HISTORY
	1.0 2014/08/22	Initial Version
	1.1	2014/09/21	Add Mandatory, Remove ParameterSetName
#>
	
	[cmdletbinding()]
	param (
		[parameter(Mandatory = $true,
				   HelpMessage = "Enter status code number (ex: 15) ",
				   ValueFromPipeline = $true,
			 	   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[ValidateRange(0,255)]
		[int]$StatusCode
	)
	BEGIN { Write-Verbose -Message "[BEGIN] Function Get-NetBackupStatusCode" }
	PROCESS
	{
		Write-Verbose -Message "[PROCESS] StatusCode: $StatusCode"
		Switch ($StatusCode)
		{
			0 { "The requested operation was successfully completed" }
			1 { "The requested operation was partially successful" }
			2 { "None of the requested files were backed up" }
			3 { "Valid archive image produced, but no files deleted due to non-fatal problems" }
			4 { "Archive file removal failed" }
			5 { "The restore failed to recover the requested files" }
			6 { "The backup failed to back up the requested files" }
			7 { "The archive failed to back up the requested files" }
			8 { "Unable to determine the status of rbak" }
			9 { "An extension package is needed, but was not installed" }
			10 { "Allocation failed" }
			11 { "System call failed" }
			12 { "File open failed" }
			13 { "File read failed" }
			14 { "File write failed" }
			15 { "File close failed" }
			16 { "Unimplemented feature" }
			17 { "Pipe open failed" }
			18 { "Pipe close failed" }
			19 { "Getservbyname failed" }
			20 { "Invalid command parameter" }
			21 { "Socket open failed" }
			22 { "Socket close failed" }
			23 { "Socket read failed" }
			24 { "Socket write failed" }
			25 { "Cannot connect on socket" }
			26 { "Client/server handshaking failed" }
			27 { "Child process killed by signal" }
			28 { "Failed trying to fork a process" }
			29 { "Failed trying to exec a command" }
			30 { "Could not get passwd information" }
			31 { "Could not set user id for process" }
			32 { "Could not set group id for process" }
			33 { "Failed while trying to send mail" }
			34 { "Failed waiting for child process" }
			35 { "Cannot make required directory" }
			36 { "Failed trying to allocate memory" }
			37 { "Operation requested by an invalid server" }
			38 { "Could not get group information" }
			39 { "Client name mismatch" }
			40 { "Network connection broken" }
			41 { "Network connection timed out" }
			42 { "Network read failed" }
			43 { "Unexpected message received" }
			44 { "Network write failed" }
			45 { "Request attempted on a non reserved port" }
			46 { "Server not allowed access" }
			47 { "Host is unreachable" }
			48 { "Client hostname could not be found" }
			49 { "Client did not start" }
			50 { "Client process aborted" }
			51 { "Timed out waiting for database information" }
			52 { "Timed out waiting for media manager to mount volume" }
			53 { "Backup restore manager failed to read the file list" }
			54 { "Timed out connecting to client" }
			55 { "Permission denied by client during rcmd" }
			56 { "Clients network is unreachable" }
			57 { "Client connection refused" }
			58 { "Cant connect to client" }
			59 { "Access to the client was not allowed" }
			60 { "Client cannot read the mount table" }
			61 { "Wbak was killed" }
			62 { "Wbak exited abnormally" }
			63 { "Process was killed by a signal" }
			64 { "Timed out waiting for the client backup to start" }
			65 { "Client timed out waiting for the continue message from the media manager" }
			66 { "Client backup failed to receive the CONTINUE BACKUP message" }
			67 { "Client backup failed to read the file list" }
			68 { "Client timed out waiting for the file list" }
			69 { "Invalid filelist specification" }
			70 { "An entry in the filelist expanded to too many characters" }
			71 { "None of the files in the file list exist" }
			72 { "The client type is incorrect in the configuration database" }
			73 { "Bpstart_notify failed" }
			74 { "Client timed out waiting for bpstart_notify to complete" }
			75 { "Client timed out waiting for bpend_notify to complete" }
			76 { "Client timed out reading file" }
			77 { "Execution of the specified system command returned a nonzero status" }
			78 { "Afs/dfs command failed" }
			79 { "Unimplemented error code 79" }
			80 { "Media Manager device daemon (ltid) is not active" }
			81 { "Media Manager volume daemon (vmd) is not active" }
			82 { "Media manager killed by signal" }
			83 { "Media open error" }
			84 { "Media write error" }
			85 { "Media read error" }
			86 { "Media position error" }
			87 { "Media close error" }
			88 { "Auspex SP/Backup failure" }
			89 { "Fatal error in Unitree file system" }
			90 { "Media manager received no data for backup image" }
			91 { "Fatal NB media database error" }
			92 { "Media manager detected image that was not in tar format" }
			93 { "Media manager found wrong tape in drive" }
			94 { "Cannot position to correct image" }
			95 { "Requested media id was not found in NB media database and/or MM volume database" }
			96 { "Unable to allocate new media for backup, storage unit has none available" }
			97 { "Requested media id is in use, cannot process request" }
			98 { "Error requesting media (tpreq)" }
			99 { "NDMP backup failure" }
			100 { "System error occurred while processing user command" }
			101 { "Failed opening mail pipe" }
			102 { "Failed closing mail pipe" }
			103 { "Error occurred during initialization, check configuration file" }
			104 { "Invalid file pathname" }
			105 { "File pathname exceeds the maximum length allowed" }
			106 { "Invalid file pathname found, cannot process request" }
			107 { "Too many arguments specified" }
			108 { "Invalid date format specified" }
			109 { "Invalid date specified" }
			110 { "Cannot find the NetBackup configuration information" }
			111 { "No entry was found in the server list" }
			112 { "No files specified in the file list" }
			113 { "Unimplemented error code 113" }
			114 { "Unimplemented error code 114" }
			115 { "Unimplemented error code 115" }
			116 { "Unimplemented error code 116" }
			117 { "Unimplemented error code 117" }
			118 { "Unimplemented error code 118" }
			119 { "Unimplemented error code 119" }
			120 { "Cannot find configuration database record for requested NB database backup" }
			121 { "No media is defined for the requested NB database backup" }
			122 { "Specified device path does not exist" }
			123 { "Specified disk path is not a directory" }
			124 { "NB database backup failed, a path was not found or is inaccessable" }
			125 { "Another NB database backup is already in progress" }
			126 { "NB database backup header is too large, too many paths specified" }
			127 { "Specified media or path does not contain a valid NB database backup header" }
			128 { "Unimplemented error code 128" }
			129 { "Unimplemented error code 129" }
			130 { "System error occurred" }
			131 { "Client is not validated to use the server" }
			132 { "User is not validated to use the server from this client" }
			133 { "Invalid request" }
			134 { "Unable to process request because the server resources are busy" }
			135 { "Client is not validated to perform the requested operation" }
			136 { "Unimplemented error code 136" }
			137 { "Unimplemented error code 137" }
			138 { "Unimplemented error code 138" }
			139 { "Unimplemented error code 139" }
			140 { "User id was not superuser" }
			141 { "File path specified is not absolute" }
			142 { "File does not exist" }
			143 { "Invalid command protocol" }
			144 { "Invalid command usage" }
			145 { "Daemon is already running" }
			146 { "Cannot get a bound socket" }
			147 { "Required or specified copy was not found" }
			148 { "Daemon fork failed" }
			149 { "Master server request failed" }
			150 { "Termination requested by administrator" }
			151 { "Backup Exec operation failed" }
			152 { "Required value not set" }
			153 { "Server is not the master server" }
			154 { "Storage unit characteristics mismatched to request" }
			155 { "Unused b" }
			156 { "Unused f" }
			157 { "Unused d" }
			158 { "Failed accessing daemon lock file" }
			159 { "Licensed use has been exceeded" }
			160 { "Authentication failed" }
			161 { "Evaluation software has expired. See www.veritas.com for ordering information" }
			162 { "Unimplemented error code 162" }
			163 { "Unimplemented error code 163" }
			164 { "Unable to mount media because its in a DOWN drive or misplaced" }
			165 { "NB image database contains no image fragments for requested backup id/copy number" }
			166 { "Backups are not allowed to span media" }
			167 { "Cannot find requested volume pool in Media Manager volume database" }
			168 { "Cannot overwrite media, data on it is protected" }
			169 { "Media id is either expired or will exceed maximum mounts" }
			170 { "Unimplemented error code 170" }
			171 { "Media id must be 6 or less characters" }
			172 { "Cannot read media header, may not be NetBackup media or is corrupted" }
			173 { "Cannot read backup header, media may be corrupted" }
			174 { "Media manager - system error occurred" }
			175 { "Not all requested files were restored" }
			176 { "Cannot perform specified media import operation" }
			177 { "Could not deassign media due to Media Manager error" }
			178 { "Media id is not in NetBackup volume pool" }
			179 { "Density is incorrect for the media id" }
			180 { "Tar was successful" }
			181 { "Tar received an invalid argument" }
			182 { "Tar received an invalid file name" }
			183 { "Tar received an invalid archive" }
			184 { "Tar had an unexpected error" }
			185 { "Tar did not find all the files to be restored" }
			186 { "Tar received no data" }
			187 { "Unimplemented error code 187" }
			188 { "Unimplemented error code 188" }
			189 { "The server is not allowed to write to the clients filesystems" }
			190 { "Found no images or media matching the selection criteria" }
			191 { "No images were successfully processed" }
			192 { "Unimplemented error code 192" }
			193 { "Unimplemented error code 193" }
			194 { "The maximum number of jobs per client is set to 0" }
			195 { "Client backup was not attempted" }
			196 { "Client backup was not attempted because backup window closed" }
			197 { "The specified schedule does not exist in the specified class" }
			198 { "No active classes contain schedules of the requested type for this client" }
			199 { "Operation not allowed during this time period" }
			200 { "Scheduler found no backups due to run" }
			201 { "Handshaking failed with server backup restore manager" }
			202 { "Timed out connecting to server backup restore manager" }
			203 { "Server backup restore managers network is unreachable" }
			204 { "Connection refused by server backup restore manager" }
			205 { "Cannot connect to server backup restore manager" }
			206 { "Access to server backup restore manager denied" }
			207 { "Error obtaining date of last backup for client" }
			208 { "Failed reading user directed filelist" }
			209 { "Error creating or getting message queue" }
			210 { "Error receiving information on message queue" }
			211 { "Scheduler child killed by signal" }
			212 { "Error sending information on message queue" }
			213 { "No storage units available for use" }
			214 { "Regular bpsched is already running" }
			215 { "Failed reading global config database information" }
			216 { "Failed reading retention database information" }
			217 { "Failed reading storage unit database information" }
			218 { "Failed reading class database information" }
			219 { "The required storage unit is unavailable" }
			220 { "Database system error" }
			221 { "Continue" }
			222 { "Done" }
			223 { "An invalid entry was encountered" }
			224 { "There was a conflicting specification" }
			225 { "Text exceeded allowed length" }
			226 { "The entity already exists" }
			227 { "No entity was found" }
			228 { "Unable to process request" }
			229 { "Events out of sequence - image inconsistency" }
			230 { "The specified class does not exist in the configuration database" }
			231 { "Schedule windows overlap" }
			232 { "A protocol error has occurred" }
			233 { "Premature eof encountered" }
			234 { "Communication interrupted" }
			235 { "Inadequate buffer space" }
			236 { "The specified client does not exist in an active class within the configuration database" }
			237 { "The specified schedule does not exist in an active class in the configuration database" }
			238 { "The database contains conflicting or erroneous entries" }
			239 { "The specified client does not exist in the specified class" }
			240 { "No schedules of the correct type exist in this class" }
			241 { "The specified schedule is the wrong type for this request" }
			242 { "Operation would cause an illegal duplication" }
			243 { "The client is not in the configuration" }
			244 { "Main bpsched is already running" }
			245 { "The specified class is not of the correct client type" }
			246 { "No active classes in the configuration database are of the correct client type" }
			247 { "The specified class is not active" }
			248 { "There are no active classes in the configuration database" }
			249 { "The file list is incomplete" }
			250 { "The image was not created with TIR information" }
			251 { "The tir information is zero length" }
			252 { "Unused TIR error 2" }
			253 { "Unused TIR error 1" }
			254 { "Server name not found in the bp.conf file" }
			255 { "Unimplemented error code 255" }
		}# end Switch
	}# PROCESS
	END { Write-Verbose -Message "[END] Function Get-NetBackupStatusCode" }
}# Function Get-NetBackupStatusCode


Export-ModuleMember -Function *
