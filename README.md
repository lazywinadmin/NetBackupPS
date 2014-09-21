NetBackupPS
===========

PowerShell module for Symantec NetBackup

This module contains PowerShell Cmdlets built around the Symantec NetBackup CLI tools


ToDo
=====
- [x] Get-NetBackupClient
- [x] Get-NetBackupDiskMedia
- [x] Get-NetBackupGlobalConfiguration
- [x] Get-NetBackupJob
- [x] Get-NetBackupPolicy
- [x] Get-NetBackupProcess
- [x] Get-NetBackupStatusCode - Thanks vN3rd
- [x] Get-NetBackupTapeConfiguration
- [x] Get-NetBackupVolume
- [ ] Get-NetBackupAgent
- [ ] Get-NetBackupAgentLogs
- [ ] Install-NetBackupAgent
- [ ] Get-NetBackupServerLogs
- [ ] Add-NetBackupClientToPolicy
- [ ] Get-NetBackupPolicyQueries #/usr/openv/netbackup/logs/PolicyQueries.log
- [ ] Refresh-NetBackupClientsList
- [ ] Get-NetBackupBackupJob {PARAM($Backup,$Restore)}
- [ ] Restart-NetBackupServices
- [ ] Troubleshooting - bpclntcmd -ip $destination #test connectivity between client and bckserver
- [ ] Troubleshooting - bpclntcmd -hn $hostname
- [ ] Disk media status - nbdevquery.exe
- [ ] Disk media status - Processes
