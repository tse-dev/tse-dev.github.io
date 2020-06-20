# The following single-line comment enforces use of PowerShell Core.
#requires -PSEdition Core

Remove-Item -Path .\public -Force -Recurse
Remove-Item -Path .\.cache -Force -Recurse
