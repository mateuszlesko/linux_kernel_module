*** Settings ***
Documentation   A test suite for valid module loading
...
...             Valid loading and unloading hello Module
...             by reading output from command demsg 

Default Tags    positive

Library         SSHLibrary
Suite Setup     Open Connection Login And Build Module
Suite Teardown  Close Connection

*** Variables ***
${VM_IP}     192.168.121.11
${VM_USER}     vagrant  
${SSH_KEY_PATH}     /home/kali/linux_kernel_module/hello/infra/.vagrant/machines/node1/libvirt/private_key
${PROGRAM_FILES_PATH}     kernel_module/program
${MODULE_NAME}     hello.ko

*** Test Cases ***
Load Hello Module
    BuiltIn.Set Local Variable     $expected_msg     Hello, world
    SSHLibrary.Write     sudo insmod ${MODULE_NAME}
    SSHLibrary.Write     sudo dmesg | tail -1
    ${output}=     SSHLibrary.Read     delay=2s
    Should Contain     ${output}     ${expected_msg} 

Unload Hello Module
    BuiltIn.Set Local Variable     $expected_msg     Goodbye, cruel world
    SSHLibrary.Write     sudo rmmod ${MODULE_NAME}
    SSHLibrary.Write     sudo dmesg | tail -1
    ${output}=     SSHLibrary.Read     delay=2s
    Should Contain     ${output}     ${expected_msg}


*** Keywords ***
Open Connection Login And Build Module
    Open Connection     ${VM_IP}
    ${output}=     Login With Public Key     ${VM_USER}     ${SSH_KEY_PATH}
    SSHLibrary.Write     cd kernel_module/program && make all
