/*

Cleaning Data 

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--------- Standard Date

SELECT SaleDateConverted, Convert(Date,SaleDate) AS SaleDate
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-------Populate Property Address Data
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT nash1.ParcelID, nash1.PropertyAddress, nash2.ParcelID
, nash2.PropertyAddress, ISNULL(nash1.PropertyAddress,nash2.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing nash1	
JOIN PortfolioProject.dbo.NashvilleHousing nash2
  ON
   Nash1.ParcelID = Nash2.ParcelID
   AND nash1.[UniqueID ] <> nash2.[UniqueID ]
   WHERE nash1.PropertyAddress IS NULL
    
UPDATE nash1
SET PropertyAddress = ISNULL(nash1.PropertyAddress,nash2.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing nash1	
JOIN PortfolioProject.dbo.NashvilleHousing nash2
  ON
   Nash1.ParcelID = Nash2.ParcelID
   AND nash1.[UniqueID ] <> nash2.[UniqueID ]
WHERE nash1.PropertyAddress IS NULL
    

--Address (Address,City, State)
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

-- Removes the Comma and Start after the comma disappear
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))
AS Address
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar (255);

UPDATE NashvilleHousing
SET PropertySplitAddress = 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar (255);

UPDATE NashvilleHousing
SET PropertySplitCity = 
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = 
  PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitCity = 
  PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
 
 ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitState = 
  PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
  
  
  SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM PortfolioProject.dbo.NashvilleHousing
  GROUP BY SoldAsVacant
  ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant 
	 END
    FROM PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant 
	 END


 -- CTE Removing Duplicates
 
 WITH RowNumCTE AS(
 select *, 
 ROW_NUMBER()OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY 
			    UniqueID
				) row_num

 FROM PortfolioProject.dbo.NashvilleHousing
 --ORDER BY ParcelID
 )
SELECT *
 FROM RowNumCTE
 WHERE row_num > 1
 ORDER BY PropertyAddress


 --Deleting Unsued Coulmns
 SELECT *
 FROM PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashVilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

  ALTER TABLE PortfolioProject.dbo.NashVilleHousing
 DROP COLUMN SaleDate