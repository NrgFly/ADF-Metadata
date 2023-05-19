CREATE TABLE [edw].[DimDate] (
    [DateKey]                INT           NOT NULL,
    [CalendarDate]           DATETIME2 (7) NOT NULL,
    [CalendarDay]            NUMERIC (3)   NOT NULL,
    [DayofWeekName]          VARCHAR (9)   NOT NULL,
    [CalendarYear]           NUMERIC (4)   NOT NULL,
    [CalendarYearName]       CHAR (4)      NOT NULL,
    [CalendarYearStartDate]  DATETIME2 (7) NOT NULL,
    [CalendarYearEndDate]    DATETIME2 (7) NOT NULL,
    [CalendarYearDaysCnt]    NUMERIC (3)   NOT NULL,
    [CalendarQtr]            NUMERIC (5)   NOT NULL,
    [CalendarQtrNo]          NUMERIC (1)   NOT NULL,
    [CalendarQtrStartDate]   DATETIME2 (7) NOT NULL,
    [CalendarQtrEndDate]     DATETIME2 (7) NOT NULL,
    [CalendarQtrDaysCnt]     NUMERIC (2)   NOT NULL,
    [CalendarMonth]          NUMERIC (6)   NOT NULL,
    [CalendarMonthNo]        NUMERIC (2)   NOT NULL,
    [CalendarMonthName]      VARCHAR (9)   NOT NULL,
    [CalendarMonthStartDate] DATETIME2 (7) NOT NULL,
    [CalendarMonthEndDate]   DATETIME2 (7) NOT NULL,
    [CalendarMonthDaysCnt]   NUMERIC (2)   NOT NULL,
    [CalendarWeekNo]         NUMERIC (2)   NOT NULL,
    [CalendarWeekStartDate]  DATETIME2 (7) NOT NULL,
    [CalendarWeekEndDate]    DATETIME2 (7) NOT NULL,
    [WorkDayInd]             VARCHAR (3)   NOT NULL,
    [StatHolidayInd]         VARCHAR (3)   NOT NULL,
    [BankingHolidayInd]      VARCHAR (3)   NULL,
    [Timestamp]              DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED ([DateKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_edw_DimDate_CalDate]
    ON [edw].[DimDate]([CalendarDate] ASC)
    INCLUDE([CalendarWeekNo], [CalendarYear], [DayofWeekName]);

