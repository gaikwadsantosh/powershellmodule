function New-MyAzVM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [string]$ResourceGroupName,
        [Parameter(Position=1)]
        [string]$TemplateFile,
        [Parameter(Position=2)]
        [string]$TemplateParameterFile,
        [Parameter(Position=3)]
        [string]$virtualMachineName,
        [Parameter(Position=4)]
        [string]$adminUsername,
        [Parameter(Position=5)]
        [string]$adminPassword
    )

    if (!$TemplateFile) {
        $TemplateFile = ".\template.json"
    }
    if (!$TemplateParameterFile) {
        $TemplateParameterFile = ".\parameters.json"
    }

    if ($virtualMachineName) {
        $params += "-virtualMachineName $virtualMachineName"
    }
    if ($adminUsername) {
        $params += "-adminUsername $adminUsername"
    }
    if ($adminPassword) {
        $params += "-adminPassword $adminPassword"
    }

    if($params) {
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFile `
        -TemplateParameterFile $TemplateParameterFile `
        $params `
        -mode Incremental
    }else{
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFile `
        -TemplateParameterFile $TemplateParameterFile `
        -mode Incremental
    }
}