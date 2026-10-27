<%
' =========================================================================
' English-Corpora.org Gateway Security Engine (Unified & Refined Edition)
' =========================================================================
' dim myPage, myIP, sItem, sValue, connhack, sql, sql_bad, cleanItem

myPage = Request.ServerVariables("URL")

If Request.ServerVariables("HTTP_CF_CONNECTING_IP") <> "" Then
    session("myIP") = Request.ServerVariables("HTTP_CF_CONNECTING_IP")
Else
    session("myIP") = Request.ServerVariables("REMOTE_ADDR")
End If

myIP = session("myIP")

' =========================================================================
' 1. Individual QueryString Processing Loop (GET Data)
' =========================================================================
For Each sItem In Request.QueryString
    sValue = Request.QueryString(sItem)
    If Len(sValue) > 0 Then

        cleanItem = LCase(sItem)

        ' Explicitly skip the security scan for these known safe parameters
        If cleanItem <> "lang" And cleanItem <> "country" And cleanItem <> "page" And Left(cleanItem, 6) <> "texto_" Then
            If CheckMaliciousPattern(sValue) Then
                Call BlockAndLog(sItem & "=" & sValue)
            End If
        End If

    End If
Next

' =========================================================================
' 2. Individual Form Processing Loop (POST Data)
' =========================================================================
For Each sItem In Request.Form
    sValue = Request.Form(sItem)
    If Len(sValue) > 0 Then

        cleanItem = LCase(sItem)

        ' Explicitly skip the security scan for these known safe parameters
        If cleanItem <> "lang" And cleanItem <> "country" And cleanItem <> "page" And Left(cleanItem, 6) <> "texto_" Then

            ' STEP A: Catch severe system/code exploits (SQL Injection, XSS, Shell commands)
            If CheckMaliciousPattern(sValue) Then
                Call BlockAndLog(sItem & "=" & sValue)
            End If

        End If

        ' STEP B: Handle links safely. Intercept "http/https" STRICTLY within user profile
        ' fields (info, comments) to block SEO spam while letting hidden system fields pass.
        If cleanItem = "info" Or cleanItem = "info1" Or cleanItem = "comments" Then
            If InStr(sValue, "http:") > 0 Or InStr(sValue, "https:") > 0 Then

                Response.Write "<html><body>"
                Response.Write "<h3>Registration / Profile Field Notice</h3>"
                Response.Write "Please do not include full web addresses starting with <b>http://</b> or <b>https://</b> in the info or profile fields.<br>"
                Response.Write "Instead of typing something like <i>https://myuniv.edu</i>, please just enter it as <b>myuniv.edu</b>.<br><br>"
                Response.Write "<button onclick='history.back()'>Go Back and Fix</button>"
                Response.Write "</body></html>"
                Response.End

            End If
        End If

    End If
Next

' =========================================================================
' Core Subroutines & Security Functions
' =========================================================================

Sub BlockAndLog(ByVal bad_payload)
    ' Truncate and sanitize payload context safe for the dynamic SQL query log
    sql_bad = Left(bad_payload, 255)
    sql_bad = Replace(sql_bad, "'", "''")

    ' Log attack payload straight to your primary [hacker] table for the 30-min IIS script task
    Set connhack = Server.CreateObject("ADODB.Connection")
    connhack.Open("Provider=SQLNCLI11;Server=(local);Database=logs;Trusted_Connection=yes")

    sql = "INSERT INTO hacker (IP, pager, whendo, numo, sql) VALUES ('" & myIP & "', '" & myPage & "', CURRENT_TIMESTAMP, 1, '" & sql_bad & "')"
    connhack.Execute(sql)

    connhack.Close
    Set connhack = Nothing

    ' Cut the execution stream dead immediately. The malicious actor gets nothing back.
    Response.Write "Access Denied."
    Response.End
End Sub

Function CheckMaliciousPattern(ByVal targetString)
    CheckMaliciousPattern = False
    If Len(targetString) = 0 Then Exit Function

' dim regEx
    Set regEx = New RegExp
    regEx.IgnoreCase = True
    regEx.Global = True

    ' Group 1: Technical System Executables (Safe for natural language, profiles, and passwords)
' dim pattern1
    pattern1 = "\b(exec|viewstate|xp_cmdshell|cmdshell|fputs|sysobjects|information_schema)\b"

    ' Group 2: SQL Injection syntax, structural breaks, and execution tokens
' dim pattern2
    pattern2 = "('\s*--|/\*|\.\./|\.\.\\|etc/passwd|char\(|chr\(|concat\(|extractvalue|need_fuck|echo copy|'?\s*or\s*'1'='1|<script|<html|onerror\s*=|javascript:|onload\s*=)"

    regEx.Pattern = pattern1 & "|" & pattern2

    If regEx.Test(targetString) Then
        CheckMaliciousPattern = True
    End If
    Set regEx = Nothing
End Function
%>