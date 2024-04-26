#REM v0.2
#Register and deregister ec2 instance from load balancer target group
# de-register-ec2-tg.ps1 -ec2id <instanceid> -command <register/deregister>

#parameters-from-commandline #instanceid #command
param(
     [Parameter(Mandatory=$false)]
     [string]$ec2id,
	 [Parameter(Mandatory=$false)]
     [string]$command
	 )

#import-modules
$psmodule = "AWSPowershell"
Import-Module -name $psmodule

#set-default-AWS-region
$region = "eu-central-1"
Set-DefaultAWSRegion $region

#tg ports
$port = "80"

#tg arns
$arn80 = "arn:aws:elasticloadbalancing:eu-central-1:651629222667:targetgroup/test123/f3f807963789f1e4"

#targetgroup-80
$TargetGroupArn = $arn80
$targetDescription = New-Object Amazon.ElasticLoadBalancingV2.Model.TargetDescription
$targetDescription.Id = $ec2id
$targetDescription.port = $port

try {
    $instance = Get-EC2Instance -InstanceId $ec2id -ErrorAction stop
    } 
catch {
    Write-host ""  
    Write-host -ForegroundColor Red "Incorrect or empty instanceid."
    Write-host ""  
    Write-host "USAGE:"
    Write-Host ".\de-register-ec2-tg.ps1 -ec2id <instanceid> -command register -- to register instance in tg"
    Write-Host ".\de-register-ec2-tg.ps1 -ec2id <instanceid> -command deregister  -- to deregister instance in tg"
    break
}

if ($command -eq "register") {
    try {
        Register-ELB2Target -TargetGroupArn $TargetGroupArn -Target @{port = $port; id = $ec2id}
        Write-Host -ForegroundColor Green "Instance $ec2id has been registered to target group."
    }
    catch {
        Write-Host -ForegroundColor Red "Instance is not in running state so cannot be register in target group."
        break
    }
} 
elseif ($command -eq "deregister") {
    Unregister-ELB2Target -TargetGroupArn $TargetGroupArn -Target $targetDescription
    Write-Host -ForegroundColor blue "Instance $ec2id has been deregistered from target group."
}
else {
    Write-host ""    
    Write-Host -ForegroundColor Red "Incorrect command."
    Write-host ""
    Write-host "USAGE:"
    Write-Host ".\de-register-ec2-tg.ps1 -ec2id <instanceid> -command register -- to register instance in tg"
    Write-Host ".\de-register-ec2-tg.ps1 -ec2id <instanceid> -command deregister  -- to deregister instance in tg"
}

