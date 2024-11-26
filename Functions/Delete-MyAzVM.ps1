function Delete-MyAzVM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory, Position=1)]
        [string]$VMName
    )

    # Get the VM object
    $vm = Get-AzVm -Name $VMName -ResourceGroupName $ResourceGroupName
    if (-not $vm) {
        Write-Error "Virtual machine '$VMName' not found in resource group '$ResourceGroupName'."
        return
    }

    # Retrieve related resource IDs
    $nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id
    $nic = Get-AzNetworkInterface -ResourceId $nicId
    $pipId = $nic.IpConfigurations[0].PublicIpAddress.Id
    $vnetId = $nic.IpConfigurations[0].Subnet.Id -replace '/subnets/.*'

    # Delete the VM
    Write-Output "Deleting VM '$VMName'..."
    Remove-AzVm -Name $VMName -ResourceGroupName $ResourceGroupName -Force

    # Delete the network interface
    if ($nic) {
        Write-Output "Deleting Network Interface '$($nic.Name)'..."
        Remove-AzNetworkInterface -Name $nic.Name -ResourceGroupName $nic.ResourceGroupName -Force
    }

    # Delete the virtual network (if not shared)
    if ($vnetId) {
        $vnetName = ($vnetId -split '/')[8]
        if ($vnetName) {
            # Confirm no resources are using the VNet
            $dependencies = Get-AzResource -ResourceGroupName $ResourceGroupName | Where-Object { $_.ResourceId -like "*$VMName*" }

            if ($dependencies) {
                Write-Host "The VNet has the following dependencies and cannot be deleted:" -ForegroundColor Yellow
                $dependencies
                foreach ($dependency in $dependencies) {
                    Remove-Dependency -Name $dependency.Name -ResourceGroupName $dependency.ResourceGroupName -ResourceType $dependency.ResourceType
                }
                Remove-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Force
                Write-Host "VNet $vnetName has been deleted successfully." -ForegroundColor Green
            } else {
                # Remove the VNet
                Remove-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Force
                Write-Host "VNet $vnetName has been deleted successfully." -ForegroundColor Green
            }
        }
    }

    # Delete the public IP address
    if ($pipId) {
        $publicIpName = ($pipId -split '/')[8]
        if ($publicIpName) {
            Write-Output "Deleting Public IP Address '$($publicIpName)'..."
            Remove-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $ResourceGroupName -Force
        }
    }

    Write-Output "All specified resources related to VM '$VMName' have been processed."
}

# Function to delete a resource based on its type
function Remove-Dependency {
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory)]
        [string]$ResourceType
    )

    switch ($ResourceType) {
        "Microsoft.Network/networkInterfaces" {
            Write-Host "Deleting Virtual Network: $Name in Resource Group: $ResourceGroupName" -ForegroundColor Yellow
            Remove-AzVirtualNetwork -Name $Name -ResourceGroupName $ResourceGroupName -Force
        }
        "Microsoft.Network/virtualNetworks" {
            Write-Host "Deleting Virtual Network: $Name in Resource Group: $ResourceGroupName" -ForegroundColor Yellow
            Remove-AzVirtualNetwork -Name $Name -ResourceGroupName $ResourceGroupName -Force
        }
        "Microsoft.Network/networkSecurityGroups" {
            Write-Host "Deleting Network Security Group: $Name in Resource Group: $ResourceGroupName" -ForegroundColor Yellow
            Remove-AzNetworkSecurityGroup -Name $Name -ResourceGroupName $ResourceGroupName -Force
        }
        "Microsoft.Network/publicIPAddresses" {
            Write-Host "Deleting Virtual Network: $Name in Resource Group: $ResourceGroupName" -ForegroundColor Yellow
            Remove-AzVirtualNetwork -Name $Name -ResourceGroupName $ResourceGroupName -Force
        }
        default {
            Write-Host "Resource type $ResourceType is not handled by this script." -ForegroundColor Red
        }
    }
}

