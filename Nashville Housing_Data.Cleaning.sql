/*
Cleaning DATA in SQL Queries

*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



select* 
from [Housing Project]..[Nashville Housing]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format


select SaleDate 
from [Housing Project]..[Nashville Housing]


select SalesDateConverted, CONVERT(date,SaleDate)
from [Housing Project]..[Nashville Housing]


UPDATE [Nashville Housing]
set SaleDate = CONVERT(date,SaleDate)


ALTER TABLE [Nashville Housing]
ADD salesDateConverted DATE;

UPDATE [Nashville Housing]
set salesDateConverted = CONVERT(date,SaleDate)



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data


select * 
from [Housing Project]..[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from [Housing Project]..[Nashville Housing] a
join [Housing Project]..[Nashville Housing] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Housing Project]..[Nashville Housing] a
join [Housing Project]..[Nashville Housing] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Housing Project]..[Nashville Housing] a
join [Housing Project]..[Nashville Housing] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into individual Columms (Address, City, state)


select PropertyAddress
from [Housing Project]..[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1 , LEN(PropertyAddress)) as Address

from [Housing Project]..[Nashville Housing]



ALTER TABLE [Nashville Housing]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Nashville Housing]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE [Nashville Housing]
ADD PropertySplitCity Nvarchar(255);

UPDATE [Nashville Housing]
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1 , LEN(PropertyAddress))



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--OWNERSADDRESS -- PARSENAME looks for comas in Dilimited Dataset --- AND works BACKwards


select OwnerAddress
from [Housing Project]..[Nashville Housing]



Select
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),3)
from [Housing Project]..[Nashville Housing]

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [Housing Project]..[Nashville Housing]


ALTER TABLE [Nashville Housing]
ADD OwnerSplitAddress Nvarchar(255);

UPDATE [Nashville Housing]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE [Nashville Housing]
ADD OwnerSplitCity Nvarchar(255);

UPDATE [Nashville Housing]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE [Nashville Housing]
ADD OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Change Y and N Yes and No in "Sold AS Vacant" Field



select Distinct (SoldAsVacant), count(SoldAsVacant)
from [Housing Project]..[Nashville Housing]
group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant  = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from [Housing Project]..[Nashville Housing]

UPDATE [Nashville Housing]
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant  = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Dublicate



WITH RowNumCTE AS(
Select*,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			  UniqueID
			  ) row_num
			   

from [Housing Project]..[Nashville Housing]
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
order by PropertyAddress



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns



select *
from [Housing Project]..[Nashville Housing]

ALTER TABLE [Housing Project]..[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDIstrict, PRopertyAddress

ALTER TABLE [Housing Project]..[Nashville Housing]
DROP COLUMN SaleDate




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------