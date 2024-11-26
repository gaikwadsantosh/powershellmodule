function Stop-MyAzVM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory, Position=1)]
        [string]$VMName
    )

    Stop-AzVm -ResourceGroupName $ResourceGroupName -Name $VMName -Force

}