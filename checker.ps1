param([string]$IP="127.0.0.1")

class CsvRow {
  [object] ${name}
  [object] ${WeakPassword}
  [object] ${EmptyPassword}
  [object] ${DuplicatePasswordGroups}
  [object] ${ClearTextPassword}
  [object] ${PasswordNeverExpires}
  [object] ${PasswordNotRequired}
  [object] ${LMHash}
  [object] ${DefaultComputerPassword}
  [object] ${DelegatableAdmins}
  [object] ${DESEncryptionOnly}
}

Function WriteColumn ($column){
    foreach ($name2 in $result.$column){
        if ( $name2 -eq $rowObj.name){
            $rowObj.$column = "True"
        }}
    if ($rowObj.$column -eq $null){
        $rowObj.$column = "False"
    }
}

$field = @("WeakPassword", "EmptyPassword", "DuplicatePasswordGroups", "ClearTextPassword", "PasswordNeverExpires", "PasswordNotRequired" , "LMHash",  "DefaultComputerPassword", "DelegatableAdmins", "DESEncryptionOnly")
$adInfo = Get-ADReplAccount -All -Server $IP
$result = $adInfo | Test-PasswordQuality -WeakPasswordHashesSortedFile wordlist.txt
$names = $adInfo | select-object logonname
$newnames = $adInfo | select-object  SamAccountName
$array = @()

foreach( $name in $names){
    $rowObj = [CsvRow]::new()
    $rowObj.name = $name | select-object -expandproperty logonname
    WriteColumn -column "WeakPassword"
    WriteColumn -column "EmptyPassword"
    WriteColumn -column "DuplicatePasswordGroups"
    WriteColumn -column "ClearTextPassword"
    WriteColumn -column "PasswordNeverExpires"
    WriteColumn -column "PasswordNotRequired"
    WriteColumn -column "LMHash"
    WriteColumn -column "DefaultComputerPassword"
    WriteColumn -column "DelegatableAdmins"
    WriteColumn -column "DESEncryptionOnly"
    $rowObj.name = $rowObj.name.ToString().Split('\')[1]
    $array += $rowObj
}

$array
$array | export-csv report.csv -force -notypeinformation