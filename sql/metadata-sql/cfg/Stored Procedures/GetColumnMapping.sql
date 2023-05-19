CREATE PROCEDURE [cfg].[GetColumnMapping]
  @DataFeedStageId int
AS
BEGIN
  DECLARE @json_construct varchar(MAX) = '{"type": "TabularTranslator", "mappings": {X}}';
  DECLARE @json VARCHAR(MAX);
    
  SET @json = (
    SELECT
        c.[SourceColumn] AS 'source.name', 
        c.[TargetColumn] AS 'sink.name' 
    FROM [cfg].[ColumnMetadata] as c
  WHERE c.DataFeedStageId = @DataFeedStageId and c.Enabled <> 0
    FOR JSON PATH );
 
    SELECT REPLACE(@json_construct,'{X}', @json) AS json_output;
END