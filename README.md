Manage-Az-VMs
The Manage-Az-VMs PowerShell module simplifies the provisioning and management of Azure Virtual Machines (VMs). It allows users to create, configure, and manage Azure VMs using parameterized templates for efficient automation.

Table of Contents
Features
Prerequisites
Installation
Usage
Example Scenarios
Remove Module


Features
1. Provision Azure VMs using pre-defined ARM templates.
2. Customizable parameters for VM configuration.
3. Override default template parameters at runtime.
4. Streamlined management with a single module.

Prerequisites
1. Azure PowerShell Module: Ensure you have the Azure PowerShell Module installed.
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
2. Azure Subscription: An active Azure subscription with sufficient permissions to create resources.
3. Execution Policy: The script must be signed or the execution policy set to RemoteSigned or Unrestricted.
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
4. Template Files:
    An ARM template file (e.g., template.json) defining the VM configuration.
    A parameter file (e.g., parameters.json) specifying VM parameters.

Installation
1. cd <<folder>>
2. Import the module:
    Import-Module .\Az.MyVM.psd1 -Force
3. Verify the module is imported and details of module
    Get-Module -Name Az.MyVM

Usage
0. Connect to Azure
    Connect-AzAccount
1. Provision a Virtual Machine
    New-MyAzVM -ResourceGroupName "TestRG"
2. Stop VM
    Stop-MyAzVM -ResourceGroupName "TestRG" -VMName "myVM"
3. Start VM
    Start-MyAzVM -ResourceGroupName "TestRG" -VMName "myVM"
4. Delete VM
    Delete-MyAzVM -ResourceGroupName "TestRG" -VMName "myVM"
5. Parameters:
    -ResourceGroupName: The name of the Azure resource group.
    -ResourceTemplate: Path to the ARM template file.
    -ParameterFile: Path to the parameter file.

Example Scenarios
    New-MyAzVM -ResourceGroupName "TestRG" -TemplateFile .\template.json -TemplateParameterFile .\parameters.json -virtualMachineName "myVM" -adminUsername "student" -adminPassword "StudentPass@123456789" -Verbose

Remove Module
    Remove-Module Az.MyVM
