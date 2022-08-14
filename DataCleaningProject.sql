/*

Cleaning Data in SQL Queries

*/


Select *
from PortfolioProject.dbo.NashvilleHousing





-- Standardize Date Format

Select SaleDateConverted,CONVERT(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)


Alter table NashvilleHousing
add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)



-- Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City)


Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing


Alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Select *
from PortfolioProject.dbo.NashvilleHousing

-- also
-- Breaking out Address into Individual Columns (Address, City, State)

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing



Alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


Alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select *
from PortfolioProject.dbo.NashvilleHousing





-- Change Y and N to Yes and No in "Sold as Vacant" field



Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  ELSE SoldAsVacant
	  END
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  ELSE SoldAsVacant
	  END







-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num

from PortfolioProject.dbo.NashvilleHousing
)
Select *                    --DELETE is used here instead of Select to remove all duplicates
From RowNumCTE
where row_num>1
Order by PropertyAddress




Select *
from PortfolioProject.dbo.NashvilleHousing





-- Delete Unused Columns (usually done on Views)



Select *
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict,SaleDate 































