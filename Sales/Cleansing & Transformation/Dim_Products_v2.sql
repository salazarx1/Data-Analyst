--Cleansed Dim_Products Table--
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode, 
  -- ,[ProductSubcategoryKey]
  -- ,[WeightUnitMeasureCode]
  -- ,[SizeUnitMeasureCode]
  p.[EnglishProductName] AS [Product Name], 
  ps.EnglishProductSubcategoryName AS [Sub Category],  -- Joined in from Sub category Table
  pc.EnglishProductCategoryName AS [Product Category],  --Joined in from Category Table
  --,[SpanishProductName]
  --  ,[FrenchProductName]
  --  ,[StandardCost]
  --   ,[FinishedGoodsFlag]
  p.[Color] AS [Product Color], 
  --,[SafetyStockLevel]
  --  ,[ReorderPoint]
  -- ,[ListPrice]
  p.[Size] AS [Product Size], 
  -- ,[SizeRange]
  --   ,[Weight]
  --  ,[DaysToManufacture]
  p.[ProductLine] AS [Product Line], 
  --   ,[DealerPrice]
  --    ,[Class]
  --  ,[Style]
  p.[ModelName] AS [Model Name], 
  --,[LargePhoto]
  p.[EnglishDescription] AS [Product Despription], 
  --  ,[FrenchDescription]
  --  ,[ChineseDescription]
  --  ,[ArabicDescription]
  --  ,[HebrewDescription]
  -- ,[ThaiDescription]
  --  ,[GermanDescription]
  --  ,[JapaneseDescription]
  -- ,[TurkishDescription]
  --   ,[StartDate]
  ISNULL (p.Status, 'Outdated') AS [Product Status] -- replacing Null to outdated 
FROM 
  [dbo].[DimProduct] AS p 
  LEFT JOIN dbo.DimProductSubcategory AS ps 
           ON ps.ProductSubcategoryKey = p.ProductSubcategorykey 
  LEFT JOIN dbo.DimProductCategory AS pc 
          ON ps.ProductCategoryKey = pc.ProductCategoryKey 
ORDER BY 
  p.ProductKey ASC
