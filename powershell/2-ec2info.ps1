#REM v0.1
#Gather some useful information about EC2 instance.
# ec2info.ps1 -ec2id <instanceid> 

#parameters-from-commandline #instanceid #command
param(
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$ec2id
)
Clear-Host

$psmodule = "AWSPowerShell"
$psmodulever = "4.1.0"

if (Get-InstalledModule | Where-Object {$_.Name -eq "$psmodule"}) {
    Write-Host "$psmodule Module is already installed."
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

try {
    $instance = Get-EC2Instance -InstanceId $ec2id -ErrorAction stop
    } 
catch {
    Write-host ""  
    Write-host -ForegroundColor Red "Incorrect or empty instanceid."
    Write-host ""  
    Write-host "USAGE:"
    Write-Host ".\ec2info.ps1 -ec2id <instanceid>"
    break
}

Write-Host ""
Write-Host "Instance details:"
Write-Host ""
Write-Host "Instance ID:" $instance.instances.InstanceId
Write-Host "Instance Name:" ($instance.instances.tags | Where-Object {$_.Key -eq "Name"}).value
Write-Host "Launch time:" $instance.instances.LaunchTime
Write-Host "AMI ID:" $instance.instances.ImageId
Write-Host "Instance type:" $instance.instances.InstanceType
Write-Host "Instance VPC:" $instance.instances.VpcId
Write-Host "SubnetID" $instance.instances.SubnetId
Write-Host "IP Address:" $instance.instances.NetworkInterfaces.privateipaddress
Write-Host "Security groups:" $instance.instances.SecurityGroups.groupname
