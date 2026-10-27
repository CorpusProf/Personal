<%

' set db = server.CreateObject("ADODB.Connection")
' db.Open("Provider=sqloledb;Data Source=(local);Initial Catalog=logFiles;Integrated Security=SSPI")

set db = server.CreateObject("ADODB.Connection")
db.Open("Provider=SQLNCLI11;Server=(local);Initial Catalog=logfiles;Trusted_Connection=yes")

'  str="DSN=logFiles"
'  Set db = Server.CreateObject("ADODB.Connection")
'  db.Open str

  DottedIP = Request.ServerVariables("REMOTE_ADDR")
  Dim i, pos
  Dim PrevPos, num
  If DottedIP = "" Then
      Dot2LongIP = 0
  Else
      For i = 1 To 4
          pos = InStr(PrevPos + 1, DottedIP, ".", 1)
          If i = 4 Then
              pos = Len(DottedIP) + 1
          End If
          num = Int(Mid(DottedIP, PrevPos + 1, pos - PrevPos - 1))
          PrevPos = pos
          Dot2LongIP = ((num Mod 256) * (256 ^ (4 - i))) + Dot2LongIP
      Next
  End If

' set connloc = server.CreateObject("ADODB.Connection")
' connloc.Open("Provider=sqloledb;Data Source=(local);Initial Catalog=ip2loc;Integrated Security=SSPI")

set connloc = server.CreateObject("ADODB.Connection")
connloc.Open("Provider=SQLNCLI11;Server=(local);Initial Catalog=logfiles;Trusted_Connection=yes")

'  strDSN  = "DSN=IP2LOC"
'  Set connloc = Server.CreateObject("ADODB.Connection")
'  connloc.Open strDSN

  Set rs = Server.CreateObject("ADODB.Recordset")
  sql = "select top 1 * from ipLOC where ipFROM < " & Dot2LongIP & " order by ipFROM desc"
  rs.Open sql, connloc

  IPfrom = rs("ipfrom")

  rs.close
  set rs = nothing


xtarget = left(session("target"),29)
referrer = request.servervariables("http_referer")
if instr(referrer,"google.com") <> 0 then
tx = instr(referrer,"q=")
rx = right(referrer,len(referrer)-tx-1)
referrer = "GOOGLE: " & rx
end if
referrer = left(referrer,99)

  Set rs = Server.CreateObject("ADODB.Recordset")
  strSQL = "insert into " & session("databaser") & "(whendo, target, IP, IPnum, ipFROM, referrer) values (current_timestamp, '" & xtarget & "', '" & DottedIP & "','" & dot2LongIP & "','" & ipFROM & "', '" & referrer & "')"
  rs.Open  strSQL, db
%>
