If WScript.Arguments.Count = 0 Then
    WScript.Quit
End If

Dim WshShell, Wait
If WScript.Arguments(3) = "" Then
    Wait = False
Else
    Wait = True
End If
Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = WScript.Arguments(0)
WshShell.Run chr(34) & WScript.Arguments(1) & chr(34) & " -home " & chr(34) & WScript.Arguments(2) & chr(34), 1, Wait
If Wait Then
    WshShell.CurrentDirectory = WScript.Arguments(3)
    WshShell.Run "finish.cmd 1"
End If
