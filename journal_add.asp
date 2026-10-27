<html>
<!--#include file ="nohack_j.asp"-->
<!--#include file ="adovbs.inc"-->
<head>

<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
<!--
p { font-size: 13px; font-family: "Open Sans",sans-serif }
td { font-size: 13px; font-family: "Open Sans",sans-serif }
li { font-family: "Open Sans",sans-serif; font-size: 13px }
select { font-family: "Open Sans",sans-serif; font-size: 9px }
option { font-family: "Open Sans",sans-serif; font-size: 9px }
input { font-family: "Open Sans",sans-serif; font-size: 9px }
body { font-family: "Open Sans",sans-serif; font-size: 11px }
div { font-family: "Open Sans",sans-serif; font-size: 11px }
-->
</style>

</head>

<%

info = request("info")
dater = request("dater")
dayWeek = request("dayWeek")

set conn = server.CreateObject("ADODB.Connection")
conn.Open("Provider=SQLNCLI11;Server=(local);Initial Catalog=journal;Trusted_Connection=yes")

if request("doit") = "" then

sql = "select top 1 dater, dayweek from x order by dater desc"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, conn

do while not rs.eof
dater = rs("dater")
dayWeek = rs("dayWeek")
rs.movenext
loop

select case dayWeek
case "Mon"
x2 = "selected"
case "Tue"
x3 = "selected"
case "Wed"
x4 = "selected"
case "Thu"
x5 = "selected"
case "Fri"
x6 = "selected"
case "Sat"
x7 = "selected"
case "Sun"
x1 = "selected"
end select

end if

if request.querystring("d") <> "" then

dater = request.querystring("d")

sql = "select * from x where dater = '" & dater & "'"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, conn

do while not rs.eof

dayWeek = rs("dayWeek")
info = rs("info")

rs.movenext
loop

end if

if request("doit") = "y" or request.querystring("d") <> "" then

sql = "delete from x where dater = '" & dater & "'"
conn.execute(sql)

end if

%>

<body>

<form method="POST" action="journal_add.asp">
	<input type="hidden" name="doit" value="y">
	<table border="1" cellpadding="5" style="border-collapse: collapse" width="100%" bordercolor="#BFDFFF">
		<tr>
			<td align="left" valign="top">Date</td>
			<td align="left" valign="top">
			<input type="text" name="dater" size="20" value="<%=dater%>">&nbsp;&nbsp;

<%
if request("doit") = "y" or request.querystring("d") <> "" then

if request("doit") <> "" then
dayWeek = request("dayWeek")
end if

select case dayWeek
case "Mon"
x1 = "selected"
case "Tue"
x2 = "selected"
case "Wed"
x3 = "selected"
case "Thu"
x4 = "selected"
case "Fri"
x5 = "selected"
case "Sat"
x6 = "selected"
case "Sun"
x7 = "selected"
end select

end if

%>
			<select size="1" name="DayWeek">
			<option value="Mon" <%=x1%>>Monday</option>
			<option value="Tue" <%=x2%>>Tuesday</option>
			<option value="Wed" <%=x3%>>Wednesday</option>
			<option value="Thu" <%=x4%>>Thursday</option>
			<option value="Fri" <%=x5%>>Friday</option>
			<option value="Sat" <%=x6%>>Saturday</option>
			<option value="Sun" <%=x7%>>Sunday</option>
			</select></td>
		</tr>
		<tr>
			<td align="left" valign="top">Content</td>
			<td align="left" valign="top">
			<textarea rows="16" name="info" cols="86"><%=info%></textarea></td>
		</tr>
		<tr>
			<td align="left" valign="top">&nbsp;</td>
			<td align="left" valign="top">
			<input type="text" name="p" size="20">
		</td></tr>
	</table>
	<p><input type="submit" value="Submit" name="B1">&nbsp;
	<input type="reset" value="Reset" name="B2"></p>
	<p>&nbsp;</p>
</form>

<%
if request("doit") = "y" then

if request("p") <> "yabba" then
response.write "baddo"
response.end
end if

Set rs1 = Server.CreateObject("ADODB.Recordset")
rs1.Open "x", conn, adOpenForwardOnly, adLockOptimistic

    rs1.AddNew
	rs1("info") = info
	rs1("dater") = dater
	rs1("dayWeek") = dayWeek
	rs1.Update

sql = "update b set b.ID = a.ID from dates as a, x as b where a.dater = b.dater"
conn.execute sql

end if

sql = "select top 3 * from x order by dater desc"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, conn

%>

<table border="1" width="100%" cellpadding="8" style="border-collapse: collapse" bordercolor="#5B92C8">

<%
do while not rs.eof
xx = xx + 1
info = rs("info")
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


</body>

</html>
