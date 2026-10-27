<html>
<!--#include file ="nohack.asp"-->
<!--#include file ="adovbs.inc"-->
<head>

<meta name="viewport" content="width=device-width, initial-scale=1">

<style>

@media screen and (max-width: 699px)
{
a { font-size: 16px; font-family: "Open Sans",sans-serif }
p { font-size: 16px; font-family: "Open Sans",sans-serif }
td { font-size: 16px; font-family: "Open Sans",sans-serif }
li { font-family: "Open Sans",sans-serif; font-size: 16px }
select { font-family: "Open Sans",sans-serif; font-size: 16px }
option { font-family: "Open Sans",sans-serif; font-size: 16px }
input { font-family: "Open Sans",sans-serif; font-size: 16px }
body { font-family: "Open Sans",sans-serif; font-size: 16px }
div { font-family: "Open Sans",sans-serif; font-size: 16px }
}

@media screen and (min-width: 700px)
{
a { font-size: 13px; font-family: "Open Sans",sans-serif }
p { font-size: 13px; font-family: "Open Sans",sans-serif }
td { font-size: 13px; font-family: "Open Sans",sans-serif }
li { font-family: "Open Sans",sans-serif; font-size: 13px }
select { font-family: "Open Sans",sans-serif; font-size: 13px }
option { font-family: "Open Sans",sans-serif; font-size: 13px }
input { font-family: "Open Sans",sans-serif; font-size: 13px }
body { font-family: "Open Sans",sans-serif; font-size: 13px }
div { font-family: "Open Sans",sans-serif; font-size: 13px }
}

</style>

<script language="Javascript">

function resetit()
{
// document.getElementById("w1").value = "";
// document.getElementById("date1").value = "";
// document.getElementById("date2").value = "";

document.location = 'journal2024.asp';
}

</script>

</head>

<%
w1 = request("w1")
date1 = request("date1")
date2 = request("date2")
p = request("p")

if request("doit") = "y" and p <> "yabba" then
response.end
end if

if request.querystring("y") <> "" then
xyear = request.querystring("y")
w1 = session("w1")
date1 = xyear & "-01-01"
date2 = xyear & "-12-31"

end if

%>

<body>

<table width="80%" align="center" border="0">
<tr><td>
<form method="POST" name="zabba" ID="zabba" action="journal2024.asp">
	<table border="1" cellpadding="5" style="border-collapse: collapse" width="100%" bordercolor="#BFDFFF">
		<tr>
			<td>Word</td>
			<td><input type="text" ID="w1" name="w1" size="20" value="<%=w1%>">&nbsp;&nbsp;
			<input type="checkbox" name="chart" value="ON">
			</td>
		</tr>
		<tr>
			<td>Date</td>
			<td><input type="text" ID="date1" name="date1" size="20" value="<%=date1%>"> to
			<input type="text" ID="date2" name="date2" size="20" value="<%=date2%>"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="text" name="p" size="15"></td>
		</tr>
	</table>
	<p><input type="submit" value="Submit" name="B1">&nbsp;
	<input type="reset" onClick="javascript:resetit()" value="Reset" name="B2"></p>
	<input type="hidden" name="doit" value="y">
</form>

<%

set conn = server.CreateObject("ADODB.Connection")
conn.Open("Provider=SQLNCLI11;Server=(local);Initial Catalog=journal;Trusted_Connection=yes")

' ------------------- start chart

if (request("doit") = "y" or request.querystring("y") <> "") and w1 <> "" then
%>
<table border="1" width="100%" cellpadding="8" style="border-collapse: collapse" bordercolor="#5B92C8">
<tr>
<%
for y = 2006 to 2025
%>
<td align="center"><%=y%>
<%
next
%>
</tr>

<%

session("w1") = w1

if xyear = "" and w1 <> "" then

sql = "delete from chart_pre"
conn.execute(sql)

sql = "insert into chart_pre(freq,xyear) select count(*),left(dater,4) from x where lower(info) like '%" & lcase(w1) & "%' group by left(dater,4) order by left(dater,4)"
conn.execute(sql)

sql = "update chart set freq = 0"
conn.execute(sql)

sql = "update b set b.freq = a.freq from chart_pre as a, chart as b where a.xyear = b.xyear"
conn.execute(sql)

end if

Set rs = Server.CreateObject("ADODB.Recordset")
sql = "select max(freq) as maxo from chart"
rs.Open sql, conn

maxo = rs("maxo")

if maxo > 0 and w1 <> "" then

Set rs = Server.CreateObject("ADODB.Recordset")
sql = "select * from chart order by xyear"
rs.Open sql, conn

dim year(30)
dim perc(30)

do while not rs.eof
yy = yy + 1
year(yy) = rs("freq")
perc(yy) = year(yy) / maxo

' response.write 2005+yy & ": " & rs("freq") & ": " & perc(yy) & "<br>"

rs.movenext
loop

' response.write "Max: " & maxo & "<br>"
%>

<tr>
<%
for yy = 1 to 21
%>
<td align="center"><%=year(yy)%></td>
<%next%>
</tr>

<tr>
<%
for yy = 1 to 21
%>
<td valign="bottom" align="center">
<a href="journal2024.asp?y=<%=yy+2005%>">
<img src="images/k.jpg" width="25" height="<%=100*perc(yy)%>"></a>
</td>
<%next%>
</tr>

<%else%>

No entries

<%

if date1 = "" and date2 = "" then
end if

end if
%>

</table>

<%
end if

' ------------------- end chart

if request("doit") = "y" or xyear <> "" then

Set rs = Server.CreateObject("ADODB.Recordset")

if xyear = "" then
sql = "select top 200 * from x where "
else
sql = "select * from x where "
end if

if w1 <> "" then
sql = sql & "lower(info) like '%" & lcase(w1) & "%' and "
end if

if date1 <> "" then
sql = sql & "dater between '" & date1 & "' and '" & date2 & "' and "
end if

if right(sql,5) = " and " then
sql = left(sql,len(sql)-4)
end if

sql = sql & "order by dater"

rs.Open sql, conn

else

response.end

end if
%>

<p>&nbsp;</p>
<table border="1" width="100%" cellpadding="8" style="border-collapse: collapse" bordercolor="#5B92C8">

<%
do while not rs.eof
xx = xx + 1
info = rs("info")
aa = "<span style='background-color: #FFFF00'>" & w1 & "</span>"
info = replace(info,w1,aa)
%>
<tr>
<td valign="top" nowrap><a href="journal_add.asp?d=<%=rs("dater")%>"><%=xx%></a></td>
<td valign="top" nowrap><%=rs("dater")%></td>
<td valign="top" nowrap><%=rs("dayWeek")%></td>
<td valign="top"><%=info%></td>
</tr>
<%
rs.movenext
loop
%>
</table>
</td></tr></table>
<%
for gg = 1 to 20
%>
<p>&nbsp;</p>
<%
next
%>
</html>
