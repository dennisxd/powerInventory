#$ErrorActionPreference = "SilentlyContinue"

  PARAM (
    [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [String[]]$CsvPath = $env:ComputerName
  )
  

#define Host and unreachable hostfile here  
$OutputFile = "\\chzuprena003\group\Transfer\IT\dstore\monitors.txt"
$UTRHosts = "\\chzuprena003\group\Transfer\IT\dstore\UTRHosts.txt"
$InputFile = "H:\01 Tools\02 Scripts\test.csv"

$UTRHostCnt = 0
$ATRHostCnt = 0
$TotalHosts = 0

"Username,Hostname,Serial" | Out-File $OutputFile

$ComputerList = import-csv $InputFile | Select -ExpandProperty hostname #| ForEach-Object {Write-Host "Hostname=" + $_.EmpID}
echo $ComputerList

 ForEach ($Computer in $ComputerList) {
    $User = $env:UserName
  
        $Users = Get-WmiObject –ComputerName $Computer –Class Win32_ComputerSystem | Select-Object UserName 
    

    echo $Users

        $Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi -computername $Computer 
        ForEach ($Monitor in $Monitors)
        {
	    
	    
	        $Serial = ($Monitor.SerialNumberID -ne 0 | ForEach{[char]$_}) -join ""
	
	        "$Users,$Computer,$Serial" | Out-File $OutputFile -append
            echo "$Users,$Computer,$Serial"
        }


    
    echo "Hosts unable to reach: $UTRHostCnt"

    
 }