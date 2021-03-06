USE master
GO
--backup OCM
BACKUP DATABASE [OCM_Live] TO  DISK = N'D:\Backups\OCM_Live.bak' WITH NOFORMAT, INIT,  NAME = N'OCM_Live-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'OCM_Live' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'OCM_Live' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''OCM_Live'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'D:\Backups\OCM_Live.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO


--restore to OCM_Export
RESTORE DATABASE [OCM_Export] FROM  DISK = N'D:\Backups\OCM_Live.bak' WITH  FILE = 1,  MOVE N'OpenChargeMap' TO N'd:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\OCM_Export.mdf',  MOVE N'OpenChargeMap_log' TO N'd:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\DATA\OCM_Export_1.LDF',  NOUNLOAD,  REPLACE,  STATS = 10
GO

--set OCM_Export to simple recovery mode
USE [master]
GO
ALTER DATABASE [OCM_Export] SET RECOVERY SIMPLE WITH NO_WAIT
GO

--remove unnecessary or sensitive data for distribution of database to interested parties
USE OCM_Export
DECLARE @OpenDataOnly bit =1
DECLARE @DBName nvarchar(100)='OCM_Export'

TRUNCATE TABLE AuditLog
TRUNCATE TABLE EditQueueItem

UPDATE [User] SET Identifier=SUBSTRING(HASHBYTES('SHA1', Identifier),0,16), Username=SUBSTRING(HASHBYTES('SHA1', Username),0,16), CurrentSessionToken='****Anon****', DateLastLogin=NULL,EmailAddress='anon@openchargemap.org', Location=NULL, APIKey=NULL, Latitude=NULL, Longitude=NULL

IF @OpenDataOnly=1 
BEGIN
	--delete data not yet deemed as 'Open' where sharing may be subject to external license or agreement
	DELETE FROM UserComment
	DELETE FROM [MediaItem]
	DELETE FROM [User]
	
	DECLARE @POIList TABLE (ID int)
	INSERT INTO @POIList SELECT ID FROM ChargePoint where DataProviderID!=1 OR SubmissionStatusTypeID=1010 --delisted not public
	UPDATE ChargePoint SET ParentChargePointID=NULL WHERE ParentChargePointID IN (SELECT ID FROM @POIList)
	DELETE FROM ConnectionInfo WHERE ChargePointID IN (SELECT ID FROM @POIList)
	DELETE FROM MetadataValue WHERE ChargePointID IN (SELECT ID FROM @POIList)
	DELETE FROM AddressInfo WHERE ID IN (SELECT AddressInfoID FROM ChargePoint WHERE ID IN(SELECT ID FROM @POIList))
	DELETE FROM ChargePoint WHERE ID IN (SELECT ID FROM @POIList)
	DELETE FROM ChargePoint WHERE AddressInfoID IS NULL
	DELETE FROM AddressInfo where NOT EXISTS (
		SELECT 1 FROM ChargePoint WHERE AddressInfoID=AddressInfo.ID
	)

END

DROP TABLE tmp_bulkimport
--shrink log etc
CHECKPOINT

USE master
DBCC SHRINKDATABASE('OCM_Export')

--backup exported db
BACKUP DATABASE [OCM_Export] TO  DISK = N'D:\Backups\OCM_OpenExport.bak' WITH NOFORMAT, INIT,  NAME = N'OCM - Open Data Export', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


SELECT * FROM  ViewAllLocations