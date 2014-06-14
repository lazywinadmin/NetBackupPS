NetBackupPS
===========

PowerShell module for Symantec NetBackup

The goal of this module is to create Cmdlets around the available Cli tools made available by Symantec NetBackup.

# TODO
 * NetBackup Client - Agent
  * Function Get-NetBackupAgent { }
  * Function Get-NetBackupAgentLogs { }
  * Function Install-NetBackupAgent { }
 * NetBackup Server - Logs
  * Function Get-NetBackupServerLogs { }
 * NetBackup Server - Policy
  * Function Add-NetBackupClientToPolicy { }
  * Function Get-NetBackupPolicyQueries #/usr/openv/netbackup/logs/PolicyQueries.log
 * NetBackup Server - Clients Management
  * Function Refresh-NetBackupClientsList {}
 * NetBackup Server - Backups/Restore
  * Function Get-NetBackupBackupJob {PARAM($Backup,$Restore)}
 * NetBackup Server - Services
  * Function Restart-NetBackupServices {}
 * Troubleshooting
  * bpclntcmd -ip $destination  #test connectivity between client and bckserver
  * bpclntcmd -hn $hostname
 * Disk media status
  * nbdevquery
 * Processes
  * bpps

 * See also
  * http://www.storagetutorials.com/most-used-netbackup-commands/
  * http://www.symantec.com/connect/blogs/netbackup-processes-and-commands
