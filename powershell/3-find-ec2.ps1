#REM v0.1
#Find specific instance in AWS region.
# find-ec2.ps1 -ec2id <instanceid> 

param(
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$ec2id
)
Clear-Host

$region = "eu-central-1"
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


$ec2list = (Get-EC2Instance -Region $region).Instances.instanceid

Write-Host ""
Write-Host "Search all instances in region..." (Get-DefaultAWSRegion).name 
Write-Host ""

if ($ec2list -eq "$ec2id") {
        $ec2 = (Get-EC2Instance -Region $region -InstanceId $ec2id).Instances 
        write-Host "Instance exists." -Foreground green
        Write-Host "VPC ID:" $ec2.vpcid
        Write-Host "instance ID:" $ec2.instanceid
        Write-host "Instance name:" ($ec2.tags | Where-Object {$_.Key -eq "Name"}).value
        Write-host "Instance IP:" $ec2.privateipaddress
        Write-host "Instance state:" $ec2.state.name
}    
    
else 
    {
    write-host "Instance does not exist." -Foreground red
    Write-Host ""
    Write-host "USAGE:"
    Write-Host ".\find-ec2.ps1 -ec2id <instanceid>"
}