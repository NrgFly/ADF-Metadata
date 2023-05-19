



CREATE PROCEDURE [cfg].[UpdateTableTimestamp]
(
    @TargetTable varchar(75),
    @DataFeedId int,
	@TimestampColumn varchar(50)='TIMESTAMP'
)
AS
BEGIN
    SET NOCOUNT ON

	DECLARE @sqlCommand nvarchar(1000)

	SET @sqlCommand = 'update [cfg].[DataFeed] set [TimestampValue] = (select max('+@TimestampColumn+') as LatestTimestamp from '+@TargetTable+') where (select count(*) from '+@TargetTable+') > 0 and [DataFeedId] = ' + cast(@DataFeedId as varchar(10))

	EXEC sp_executesql @sqlCommand

	SELECT [DataFeedId], [DataFeedName], [TimestampValue] from [cfg].[DataFeed] where DataFeedId = @DataFeedId

END