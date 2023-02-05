
--Cleaning Data in SQL Queries


select *
from [Portfolio Project].dbo.NashvilleHousing

----------------------------------------------------------------------------------------------

 --Standardisze date format

 select SaleDateConverted, CONVERT(date, saledate)
 from [Portfolio Project]..nashvillehousing

 update NashvilleHousing
 set SaleDate = CONVERT(date,saledate)

 alter table NashvilleHousing
 add SaleDateConverted date;

 update NashvilleHousing
 set SaleDateConverted = CONVERT(date,saledate)

 --Populate property address

 select *
 from [Portfolio Project]..NashvilleHousing
 --where PropertyAddress is null
 order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.propertyaddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--breaking address into individual columns (Address,City,State)

select PropertyAddress
 from [Portfolio Project]..NashvilleHousing

 select 
 SUBSTRING (propertyaddress, 1, charindex(',', propertyaddress)-1) as address, 
 SUBSTRING (propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress)) as address
 
 from [Portfolio Project]..NashvilleHousing

 ALTER TABLE NashvilleHousing
 add PropertySplitAddress Nvarchar(255);

 update NashvilleHousing
 set PropertySplitAddress = SUBSTRING (propertyaddress, 1, charindex(',', propertyaddress)-1)

 alter table NashvilleHousing
 add PropertySplitCity nvarchar(255);

 update NashvilleHousing
 set PropertySplitCity = SUBSTRING (propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))
 
 select *
  from [Portfolio Project]..NashvilleHousing


select OwnerAddress
  from [Portfolio Project]..NashvilleHousing
  --where OwnerAddress is not null


  --easy way
  select
  PARSENAME(replace(owneraddress,',','.'),3),
  PARSENAME(replace(owneraddress,',','.'),2),
  PARSENAME(replace(owneraddress,',','.'),1)

  from [Portfolio Project]..NashvilleHousing


  ALTER TABLE NashvilleHousing
 add OwnerSplitAddress Nvarchar(255);

 update NashvilleHousing
 set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3)

 alter table NashvilleHousing
 add OwnerSplitCity nvarchar(255);

 update NashvilleHousing
 set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2)

 ALTER TABLE NashvilleHousing
 add OwnerSplitState Nvarchar(255);

 update NashvilleHousing
 set OwnerSplitState =PARSENAME(replace(owneraddress,',','.'),1)

 select *
  from [Portfolio Project]..NashvilleHousing

  --change y and n to yes and no in soldasvacant

  select distinct (SoldAsVacant), count(soldasvacant)
  from [Portfolio Project]..NashvilleHousing
  group by SoldAsVacant
  order by 2

  select SoldAsVacant
  , case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  end
  from [Portfolio Project]..NashvilleHousing

  update NashvilleHousing
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  end


  --remove duplicates

  with rownumCTE as(
  select *,
  row_number () over (
  partition by parcelID, propertyaddress, saleprice, saledate, legalreference
  order by uniqueID) row_num


  from [Portfolio Project]..NashvilleHousing
  --order by ParcelID
)
   SELECT *
   from rownumCTE
   where row_num > 1
   
   

   ---delete unused columns


   select *
   from [Portfolio Project]..NashvilleHousing

   alter table [Portfolio Project]..NashvilleHousing
   drop column OwnerAddress, TaxDistrict, PropertyAddress

    alter table [Portfolio Project]..NashvilleHousing
   drop column SaleDate
   
