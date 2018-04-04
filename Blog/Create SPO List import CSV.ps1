#Specify tenant admin and site URL
$User = "your username"
$SiteURL = "https://tenant.sharepoint.com/sites/site"
$ListTitle = "Test List"

#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
$Password = Read-Host -Prompt "Please enter your password" -AsSecureString
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)

#Bind to site collection
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)
$Context.Credentials = $Creds

#Retrieve lists
$Lists = $Context.Web.Lists
$Context.Load($Lists)
$Context.ExecuteQuery()

#Create list with "custom" list template
$ListInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$ListInfo.Title = $ListTitle
$ListInfo.TemplateType = "100"
$List = $Context.Web.Lists.Add($ListInfo)
$List.Description = $ListTitle
$List.Update()
$Context.ExecuteQuery()

#Retrieve List
$List = $Context.Web.Lists.GetByTitle($ListTitle)
$Context.Load($List)
$Context.ExecuteQuery()

#Add new field to the list
$schemaEGDATE = "<Field Type='DateTime' Name='EGDATE' StaticName='EGDATE' DisplayName='E.G. Date' Format='DateOnly' ><Default>[Today]</Default></Field>"
$List.Fields.AddFieldAsXml($schemaEGDATE,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaEGTEXT = "<Field Type='Text' Name='EGTEXT' StaticName='EGTEXT' DisplayName='E.G. Text' />"
$List.Fields.AddFieldAsXml($schemaEGTEXT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaEGCHOICE = "<Field Type='Choice' Name='EGCHOICE' StaticName='EGCHOICE' DisplayName=E.G. Choice'><CHOICES><CHOICE>HP</CHOICE><CHOICE>ITEC</CHOICE><CHOICE>NASHUA</CHOICE><CHOICE>XEROX</CHOICE></CHOICES></Field>"
$List.Fields.AddFieldAsXml($schemaSUPPLIER,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaEGBOO = "<Field Type='Boolean' Name='EGBOO' StaticName='EGBOO' DisplayName='E.G. BOO'><Default>0</Default></Field>"
$List.Fields.AddFieldAsXml($schemaEGBOO,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaEGNOTE = "<Field Type='Note' Name='NOTE' StaticName='NOTE' DisplayName='E.G. Note' NumLines='6' RichText='FALSE' Sortable='FALSE' />" 
$List.Fields.AddFieldAsXml($schemaEGNOTE,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$List.Update()
$Context.ExecuteQuery()

#Import CSV
$ExcelItems = Import-Csv -Path C:\Users\user\Desktop\WSU_MFP_INVENTORY_CSV.csv

#Adds an item to the list
foreach ($ExcelItem in $ExcelItems) {
    $ListItemInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $Item = $List.AddItem($ListItemInfo)
    $Item["E_x002e_G_x002e__x0020Date] = $ExcelItem.EGDATE
    $Item["E_x002e_G_x002e__x0020Text"] = $ExcelItem.EGTEXT
    $Item["E_x002e_G_x002e__x0020Choice"] = $ExcelItem.EGCHOICE
    $Item["E_x002e_G_x002e__x0020Boo"] = $ExcelItem.EGBOO
    $Item["E_x002e_G_x002e__x0020Note"] = $ExcelItem.EGNOTE
    
    $Item.Update()
    $Context.ExecuteQuery()
}
