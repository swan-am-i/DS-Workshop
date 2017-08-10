# create a new storage context
$context = New-AzureStorageContext -StorageAccountName 'xx' -StorageAccountKey 'xxxx'

# create the two containers
New-AzureStorageContainer -Name 'churndata' -Permission Container -Context $context
New-AzureStorageContainer -Name 'churnhql' -Permission Container -Context $context

# upload the data to blob storage
$myFile = "PATH_TO\AALAB09 - ADF and AML\Data\cdr2015.csv"
$myBlobName = "genrawdata/2015/4/cdr2015_4.csv"
Set-AzureStorageBlobContent -File $myFile -Container 'churndata' -Blob $myBlobName -Context $context

$myFile = "PATH_TO\AALAB09 - ADF and AML\Data\CustomerInfo.csv"
$myBlobName = "dimcustomer/CustomerInfo.csv"
Set-AzureStorageBlobContent -File $myFile -Container 'churndata' -Blob $myBlobName -Context $context