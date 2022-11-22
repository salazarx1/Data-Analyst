-- Cleansed DIM_DateTable --
SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date,
  --  ,[DayNumberOfWeek],
  [EnglishDayNameOfWeek] AS Day,
  --   ,[SpanishDayNameOfWeek]
  --    ,[FrenchDayNameOfWeek]
  --    ,[DayNumberOfMonth]
  --  ,[DayNumberOfYear]
  [WeekNumberOfYear] AS WeekNum, 
  [EnglishMonthName] AS Month,
  Left([EnglishMonthName],3) AS MonthShort,
  --    ,[SpanishMonthName]
  [MonthNumberOfYear] AS MonthNum,
  [CalendarQuarter] AS Quarter,
  [CalendarYear] AS Year
  --  ,[CalendarSemester]
  --    ,[FiscalQuarter]
  --    ,[FiscalYear]
  --  ,[FiscalSemester]
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate]
  WHERE 
  CalendarYear >= 2019
