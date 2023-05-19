CREATE TABLE [cfg].[ColumnMetadata] (
    [ColumnMetadataId] INT            NOT NULL,
    [DataFeedStageId]  INT            NOT NULL,
    [SourceColumn]     NVARCHAR (100) NOT NULL,
    [TargetColumn]     NVARCHAR (100) NOT NULL,
    [Created]          DATETIME       CONSTRAINT [DF_ColumnMetadata_Created] DEFAULT (getutcdate()) NOT NULL,
    [Updated]          DATETIME       NULL,
    [Enabled]          BIT            CONSTRAINT [DF_ColumnMetadata_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ColumnMetadata] PRIMARY KEY CLUSTERED ([ColumnMetadataId] ASC)
);


GO
CREATE TRIGGER cfg.trg_update_ColumnMetadata
   ON  cfg.ColumnMetadata
   AFTER UPDATE
AS UPDATE cfg.ColumnMetadata SET Updated = getutcdate() FROM inserted WHERE inserted.ColumnMetadataId = cfg.ColumnMetadata.ColumnMetadataId