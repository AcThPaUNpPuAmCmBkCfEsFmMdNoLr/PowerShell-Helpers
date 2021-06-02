$Path = Read-Host -Prompt 'Input Path to Folder'
$Save_Path = Read-Host -Prompt 'Set output file save path'
$Replace_path = $Path.Replace("\","_") 
$Replace_path = $Replace_Path.Replace(":","_")
$Date = Get-Date
$Save_String = $Replace_Path + "_" + "ACL_Audit" + "_" + $Date + ".csv"
$Save_String = $Save_String.Replace("/","_")
$Save_String = $Save_String.Replace(":","_")
$Save_String = $Save_path + "\" + $Save_String
Write-Host "Output will be saved to  '$Save_String'"   
$FolderPath = Get-ChildItem -File -Path $Path -Recurse -Force
$Output = @()
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
$Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Control Type'=$Access.AccessControlType;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
$Output += New-Object -TypeName PSObject -Property $Properties            
}
}
$Output | Out-GridView -PassThru | Export-CSV -Path $Save_String
    