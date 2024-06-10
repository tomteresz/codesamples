function psinfo {

$psmodule = "AWSPowerShell"
$psmodulever = "4.1.0"
$version = (Get-InstalledModule | Where-Object {$_.Name -eq "AWSPowerSHell"}).version

if (Get-InstalledModule | Where-Object {$_.Name -eq "$psmodule"}) {
    try {
        $check = Get-Item -path env:psmodule -ErrorAction stop
    }
    catch [System.Management.Automation.RuntimeException] {
        Write-Host "Environment variable not defined."
    }        
}
else {
    Write-Host "$psmodule Module not installed. Installing..."
    Install-Module -Name $psmodule -MinimumVersion $psmodulever
}

if (Get-Module | Where-Object {$_.Name -eq "$psmodule"}) {
    Write-Host "$psmodule Module is already imported."
}
else {
    Write-Host "Importing $psmodule Module..."
    Import-Module -Name $psmodule
}
Set-Item -Path Env:psmodule -Value "AWSPowerShell"
}

psinfo;