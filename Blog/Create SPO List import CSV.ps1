#Specify tenant admin and site URL
$User = "rgottwald@aloesolutions.co.za"
$SiteURL = "https://aloeeastlondon.sharepoint.com/sites/og_ict"
$ListTitle = "Test List 13"

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
$schemaLAST_VISIT = "<Field Type='DateTime' Name='LAST_VISIT' StaticName='LAST_VISIT' DisplayName='Last Visit' Format='DateOnly' ><Default>[Today]</Default></Field>"
$List.Fields.AddFieldAsXml($schemaLAST_VISIT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaHOD = "<Field Type='Text' Name='HOD' StaticName='HOD' DisplayName='HOD' />"
$List.Fields.AddFieldAsXml($schemaHOD ,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaDEPARTMENT = "<Field Type='Text' Name='DEPARTMENT' StaticName='DEPARTMENT' DisplayName='Department' />"
$List.Fields.AddFieldAsXml($schemaDEPARTMENT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaLOCATION = "<Field Type='Text' Name='LOCATION' StaticName='LOCATION' DisplayName='Location' />"
$List.Fields.AddFieldAsXml($schemaLOCATION,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaROOM_NR = "<Field Type='Text' Name='ROOM_NR' StaticName='ROOM_NR' DisplayName='Room Nr.' />"
$List.Fields.AddFieldAsXml($schemaROOM_NR,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaRM_BARCODE = "<Field Type='Text' Name='RM_BARCODE' StaticName='RM_BARCODE' DisplayName='Room Barcode' />"
$List.Fields.AddFieldAsXml($schemaRM_BARCODE,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaCONTACT = "<Field Type='Text' Name='CONTACT' StaticName='CONTACT' DisplayName='Contact Name' />"
$List.Fields.AddFieldAsXml($schemaCONTACT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaUrlEMAIL = "<Field Type='Text' Name='EMAIL' StaticName='EMAIL' DisplayName='eMail' />"
$List.Fields.AddFieldAsXml($schemaUrlEMAIL,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaCELLPHONE = "<Field Type='Text' Name='CELLPHONE' StaticName='CELLPHONE' DisplayName='Cellphone Number' />"
$List.Fields.AddFieldAsXml($schemaCELLPHONE,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaTELPHONE = "<Field Type='Text' Name='TELPHONE' StaticName='TELPHONE' DisplayName='Telephone' />"
$List.Fields.AddFieldAsXml($schemaTELPHONE,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaFAX = "<Field Type='Text' Name='FAX' StaticName='FAX' DisplayName='Fax' />"
$List.Fields.AddFieldAsXml($schemaFAX,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaPRINTER_IP = "<Field Type='Text' Name='PRINTER_IP' StaticName='PRINTER_IP' DisplayName='Printer IP' />"
$List.Fields.AddFieldAsXml($schemaPRINTER_IP,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaVCC_MAC = "<Field Type='Text' Name='VCC_MAC' StaticName='VCC_MAC' DisplayName='VCC MAC Address' />"
$List.Fields.AddFieldAsXml($schemaVCC_MAC,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaVCC_IP = "<Field Type='Text' Name='VCC_IP' StaticName='VCC_IP' DisplayName='VCC IP Address' />"
$List.Fields.AddFieldAsXml($schemaVCC_IP,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaFDI_SERIAL = "<Field Type='Text' Name='FDI_SERIAL' StaticName='FDI_SERIAL' DisplayName='FDI Serial' />"
$List.Fields.AddFieldAsXml($schemaFDI_SERIAL,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaPRINTER_MAC_ADDRESS = "<Field Type='Text' Name='PRINTER_MAC_ADDRESS' StaticName='PRINTER_MAC_ADDRESS' DisplayName='Printer MAC Address' />"
$List.Fields.AddFieldAsXml($schemaPRINTER_MAC_ADDRESS,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaSUPPLIER = "<Field Type='Choice' Name='SUPPLIER' StaticName='SUPPLIER' DisplayName='Supplier'><CHOICES><CHOICE>HP</CHOICE><CHOICE>ITEC</CHOICE><CHOICE>NASHUA</CHOICE><CHOICE>XEROX</CHOICE></CHOICES></Field>"
$List.Fields.AddFieldAsXml($schemaSUPPLIER,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaSTATUS = "<Field Type='Choice' Name='STATUS' StaticName='STATUS' DisplayName='Status'><CHOICES><CHOICE>PURCHASED</CHOICE><CHOICE>CONTRACT</CHOICE></CHOICES></Field>"
$List.Fields.AddFieldAsXml($schemaSTATUS,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaMODEL = "<Field Type='Text' Name='MODEL' StaticName='MODEL' DisplayName='Model' />"
$List.Fields.AddFieldAsXml($schemaMODEL,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaASSET_NUMBER = "<Field Type='Text' Name='ASSET_NUMBER' StaticName='ASSET_NUMBER' DisplayName='Asset Number' />"
$List.Fields.AddFieldAsXml($schemaASSET_NUMBER,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaSTAPLER = "<Field Type='Boolean' Name='STAPLER' StaticName='STAPLER' DisplayName='Stapler'><Default>0</Default></Field>"
$List.Fields.AddFieldAsXml($schemaSTAPLER,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaNET_POINT = "<Field Type='Choice' Name='NET_POINT' StaticName='NET_POINT' DisplayName='Network Point'><CHOICES><CHOICE>N</CHOICE><CHOICE>Y1</CHOICE><CHOICE>Y2</CHOICE></CHOICES></Field>"
$List.Fields.AddFieldAsXml($schemaNET_POINT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaFAX_PORT = "<Field Type='Boolean' Name='FAX_PORT' StaticName='FAX_PORT' DisplayName='Fax Port'><Default>0</Default></Field>"
$List.Fields.AddFieldAsXml($schemaFAX_PORT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaFAX_UNIT = "<Field Type='Boolean' Name='FAX_UNIT' StaticName='FAX_UNIT' DisplayName='Fax Unit'><Default>0</Default></Field>"
$List.Fields.AddFieldAsXml($schemaFAX_UNIT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaPOWER = "<Field Type='Choice' Name='POWER' StaticName='POWER' DisplayName='Power Point'><CHOICES><CHOICE>N</CHOICE><CHOICE>Y1</CHOICE><CHOICE>Y2</CHOICE></CHOICES></Field>"
$List.Fields.AddFieldAsXml($schemaPOWER,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaSURGE_PROTECTOR = "<Field Type='Boolean' Name='SURGE_PROTECTOR' StaticName='SURGE_PROTECTOR' DisplayName='Surge Protector'><Default>0</Default></Field>"
$List.Fields.AddFieldAsXml($schemaSURGE_PROTECTOR,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaCAMPUS = "<Field Type='Choice' Name='CAMPUS' StaticName='CAMPUS' DisplayName='Campus'><CHOICES><CHOICE>ABSA</CHOICE><CHOICE>CAMBRIDGE</CHOICE><CHOICE>CHISELHURST</CHOICE><CHOICE>COLLEGE</CHOICE><CHOICE>EDC</CHOICE><CHOICE>EUKULUKEKWENI</CHOICE><CHOICE>GREY STREET</CHOICE><CHOICE>HERITAGE</CHOICE><CHOICE>IBIKA</CHOICE><CHOICE>JMO</CHOICE><CHOICE>NMD</CHOICE><CHOICE>POTSDAM</CHOICE><CHOICE>TAXI CITY</CHOICE><CHOICE>TECOMA</CHOICE><CHOICE>WHITTLESEA</CHOICE><CHOICE>ZAMUKULUNGISA</CHOICE></CHOICES></Field>"
$List.Fields.AddFieldAsXml($schemaCAMPUS,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$schemaCOMMENT = "<Field Type='Note' Name='COMMENT' StaticName='COMMENT' DisplayName='Comment' NumLines='6' RichText='FALSE' Sortable='FALSE' />" 
$List.Fields.AddFieldAsXml($schemaCOMMENT,$true,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldToDefaultView)
$List.Update()
$Context.ExecuteQuery()

#Import CSV
$ExcelItems = Import-Csv -Path C:\Users\adm-rgottwald\Desktop\WSU_MFP_INVENTORY_CSV.csv

#Adds an item to the list
foreach ($ExcelItem in $ExcelItems) {
    $ListItemInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $Item = $List.AddItem($ListItemInfo)
    $Item["Title"] = $ExcelItem.SERIAL_NUMBER
    $Item["HOD"] = $ExcelItem.HOD
    $Item["Department"] = $ExcelItem.DEPARTMENT
    $Item["Location"] = $ExcelItem.LOCATION
    $Item["Room_x0020_Nr_x002e_"] = $ExcelItem.ROOM_NR
    $Item["Room_x0020_Barcode"] = $ExcelItem.RM_BARCODE
    $Item["Contact_x0020_Name"] = $ExcelItem.CONTACT
    $Item["eMail"] = $ExcelItem.EMAIL
    $Item["Cellphone_x0020_Number"] = $ExcelItem.CELLPHONE
    $Item["Telephone"] = $ExcelItem.TELPHONE
    $Item["Fax"] = $ExcelItem.FAX
    $Item["Printer_x0020_IP"] = $ExcelItem.PRINTER_IP
    $Item["VCC_x0020_MAC_x0020_Address"] = $ExcelItem.VCC_SERIAL
    $Item["VCC_x0020_IP_x0020_Address"] = $ExcelItem.VCC_IP
    $Item["FDI_x0020_Serial"] = $ExcelItem.FDI_SERIAL
    $Item["Printer_x0020_MAC_x0020_Address"] = $ExcelItem.PRINTER_MAC_ADDRESS
    $Item["Supplier"] = $ExcelItem.SUPPLIER
    $Item["Status"] = $ExcelItem.STATUS
    $Item["Model"] =  $ExcelItem.MODEL
    $Item["Asset_x0020_Number"] = $ExcelItem.ASSET_NUMBER
    $Item["Stapler"] = $ExcelItem.STAPLER
    $Item["Network_x0020_Point"] = $ExcelItem.NET_POINT
    $Item["Fax_x0020_Port"] = $ExcelItem.FAX_PORT
    $Item["Fax_x0020_Unit"] = $ExcelItem.FAX_UNIT
    $Item["Power_x0020_Point"] = $ExcelItem.POWER
    $Item["Surge_x0020_Protector"] = $ExcelItem.SURGE_PROTECTOR
    $Item["Campus"] = $ExcelItem.CAMPUS
    $Item["Comment"] = $ExcelItem.COMMENT


    $Item.Update()
    $Context.ExecuteQuery()
}
