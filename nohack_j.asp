<%

myPage = Request.ServerVariables("URL")
myIP = Request.ServerVariables("REMOTE_ADDR")

if myIP <> "136.36.39.114" then

' response.write "@" & Request.ServerVariables("QUERY_STRING") & "@"
' response.end

if myIP = "209.90.108.234" or myIP = "209.90.108.237" or myIP = "136.36.172.52" then
' ignoreIt = "y"
end if

' response.write "@" & myPage & "@"
' response.end

refer = request.servervariables("http_referer")

' response.write "@" & Request.ServerVariables("URL") & "@"
' response.end

if instr(Request.ServerVariables("QUERY_STRING"),"utm_campaign") >= 1 then
ignoreit = "y"
tempok = "y"
end if

dim dox, doy, myPage

' ================================================

if instr(myPage,"vil.php") > 0 then
session("stage1") = "y"
end if

if instr(myPage,"ode/4") > 0 and session("stage1") = "y" then
stage2 = "y"
session("hack") = 999
end if

' 	/node/4

if ignoreIt = "" and session("hack") >= 3 then

' response.redirect "https://dumps.wikimedia.org/enwiki/20210201/enwiki-20210201-pages-articles-multistream.xml.bz2"
' response.redirect "https://dumps.wikimedia.org/other/static_html_dumps/current/en/wikipedia-en-html.tar.7z"
response.write "root/1"
response.end

end if

if (session("hack") > 0 or session("stage2") = "y") and ignoreIt = "" then

set connhack = server.CreateObject("ADODB.Connection")
connhack.Open("Provider=SQLNCLI11;Server=(local);Database=logs;Trusted_Connection=yes")

Set rs_hack = Server.CreateObject("ADODB.Recordset")

sql = "insert into hacker(IP,pager,whendo,numo) values ('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Request.ServerVariables("URL") & "',current_timestamp," & session("hack") & ")"
connhack.execute (sql)

session("hack") = session("hack") + 1

response.write "root/2"

response.end

end if

' ================================================

qs_orig = Request.QueryString
qs_orig = lcase(qs_orig)

if instr(qs_orig,"concat(") > 0 or instr(qs_orig,"extractvalue") > 0 or instr(qs_orig,"fputs") > 0 or instr(qs_orig,"xbshell") > 0 or instr(qs_orig,"cmdshell") > 0 or instr(qs_orig,"cachefile") > 0 or instr(qs_orig,"cscript") > 0 or instr(qs_orig,"fscript") > 0 or instr(qs_orig,".tables") > 0 or instr(qs_orig,"+or+") > 0 or instr(qs_orig,"ch[") > 0 or instr(qs_orig,"union%20") > 0 or instr(qs_orig,"cnull") > 0 or instr(qs_orig,"char%") > 0 or instr(qs_orig,"char(") > 0 or instr(qs_orig,"char+") > 0 or instr(qs_orig,"chr%") > 0 or instr(qs_orig,"chr(") > 0 or instr(qs_orig,"chr+") > 0 or instr(qs_orig,"concat%") > 0 or instr(qs_orig,"concat(") > 0 or instr(qs_orig,"concat+") > 0 or instr(qs_orig,"declare%") > 0 or instr(qs_orig,"declare(") > 0 or instr(qs_orig,"declare+") > 0 or instr(qs_orig,"delete%") > 0 or instr(qs_orig,"delete(") > 0 or instr(qs_orig,"delete+") > 0 or instr(qs_orig,"insert%") > 0 or instr(qs_orig,"insert(") > 0 or instr(qs_orig,"insert+") > 0 or instr(qs_orig,"select%") > 0 or instr(qs_orig,"select%20") > 0 or instr(qs_orig,"select(") > 0 or instr(qs_orig,"select+") > 0 or instr(qs_orig,"table_name") > 0 or instr(qs_orig,"update%") > 0 or instr(qs_orig,"update(") > 0 or instr(qs_orig,"update+") > 0 or instr(qs_orig,"where(") > 0 or instr(qs_orig,"where+") > 0 then

sql_bad = left(qs_orig,200)

set connhack = server.CreateObject("ADODB.Connection")
connhack.Open("Provider=SQLNCLI11;Server=(local);Database=logs;Trusted_Connection=yes")

if ignoreIt = "" then

Set rs_hack = Server.CreateObject("ADODB.Recordset")
sql = "insert into hacker(IP,pager,whendo,numo,sql) values ('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Request.ServerVariables("URL") & "',current_timestamp,0,'" & sql_bad & "')"
connhack.execute (sql)

session("hack") = session("hack") + 1

end if

response.write "root/3"

response.end

end if

' ================================================

For Each sItem In Request.QueryString

dox = sItem
dox = lcase(dox)
doy = Request.QueryString(dox)

' response.write dox & " // " & doy & "<br>"

if len(doy) > 0 then

doy = lcase(doy)

' --------------------

if instr(dox,"fuck") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A069'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A069",dox,doy)
response.end
end if

if instr(doy,"fputs") or instr(doy,"char(") or instr(doy,"ch[") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A070'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A070",dox,doy)
response.end
end if

if instr(doy,"3gnxsa9psanzdn3tdcnkxskc2f3msa9icrfrklmrvnbj2zp") then
call logit("A057",dox,doy)
response.end
end if

if instr(refer,"reviewProfiles.asp") > 0 and dox = "category" then
okDavies = "y"
end if

if instr(myPage,"journal_add.asp") > 0 and dox = "info" then
tempok = "y"
end if

if instr(refer,"ina-payme") >= 1 then

if (dox = "method_other" or dox = "easy_other" or dox = "acad_other") and len(doy) <= 200 then
tempok = "y"
end if

if (dox = "comments" or dox = "how_easier") and len(doy) <= 2000 then
tempok = "y"
end if

end if

if instr(refer,"register.asp") <= 0 and instr(refer,"/user_account.asp") <= 0 then

if len(doy) > 45 and len(doy) <= 60 and instr(doy,"@") then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 100 and dox = "myw1" and session("userID") <> "" then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 150 and dox = "url" then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 80 and dox = "fbclid" then
tempok = "y"
end if

if dox <> "univn" and len(doy) > 55 and tempok = "" and okDavies = "" then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A091'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A091",dox,doy)
response.end
end if

else ' is register.asp or user_account.asp

if dox <> "info" and dox <> "oldurl" and dox <> "url" and len(doy) > 80 then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A092'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A092",dox,doy)
response.end
end if

if dox = "url" and len(doy) > 120 and left(doy,4) <> "http" then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A093'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A093",dox,doy)
response.end
end if

end if ' register.asp

' --------------------

if instr(doy,"select") or instr(doy,"exec(") or instr(doy,"char%") or instr(doy,"char(") or instr(doy,"chr(") or instr(doy,"cast(") or instr(doy,"convert(") then
tricky = "y"
end if

if tricky = "y" and myIP <> "136.36.172.52" then

if instr(doy,"drop") or instr(doy,"where") or instr(doy,"union") or instr(doy,"truncate") or instr(doy,"select") or instr(doy,"update") or instr(doy,"insert") or instr(doy,"delete") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A094'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A094",dox,doy)
response.end
end if

if instr(doy,"DROP") or instr(doy,"WHERE") or instr(doy,"UNION") or instr(doy,"TRUNCATE") or instr(doy,"SELECT") or instr(doy,"UPDATE") or instr(doy,"INSERT") or instr(doy,"DELETE") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A095'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A095",dox,doy)
response.end
end if

end if

if tricky = "y" and len(doy) >= 120 then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A096'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A096",dox,doy)
response.end
end if

' --------------------

end if

next

' ================================================

For Each sItem In Request.Form

dox = sItem
dox = lcase(dox)
doy = Request.Form(dox)
' response.write dox & ": " & doy & "<br>"

if instr(doy,"remotejounal") then
ignoreit = "y"
end if

doy = replace(doy,"remotejournal","")

' -------------- new 22-05-08

if instr(doy,"echo copy") >= 1 then

set connhack1 = server.CreateObject("ADODB.Connection")
connhack1.Open("Provider=SQLNCLI11;Server=(local);Database=logs;Trusted_Connection=yes")

sql = "insert into hacker(IP,pager,whendo,numo) values ('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Request.ServerVariables("URL") & "',current_timestamp," & session("hack") & ")"
connhack1.execute (sql)

session("hack") = session("hack") + 1

response.write "root/4"

response.end

end if

' -------------- end new


if instr(doy,"select%") > 0 or instr(doy,"update%") > 0 or instr(doy,"delete%") > 0 or instr(doy,"insert%") > 0 then
doy_bad = doy & "<hr>"
end if

if len(doy) > 0 then

doy = lcase(doy)

if instr(doy,"select%") > 0 or instr(doy,"update%") > 0 or instr(doy,"delete%") > 0 or instr(doy,"insert%") > 0 then
doy_bad = doy & "<hr>"
end if

' --------------------

if instr(refer,"reviewProfiles.asp") > 0 and dox = "category" then
okDavies = "y"
end if

if instr(refer,"ina-payme") >= 1 then

if (dox = "method_other" or dox = "easy_other" or dox = "acad_other") and len(doy) <= 200 then
tempok = "y"
end if

if (dox = "comments" or dox = "how_easier") and len(doy) <= 2000 then
tempok = "y"
end if

end if

if (instr(refer,"register.asp") >= 1 or instr(refer,"reg2.asp") >= 1) and dox = "info" then
tempok = "y"
end if

if instr(refer,"register.asp") <= 0 and instr(refer,"/user_account.asp") <= 0 then

if len(doy) > 45 and len(doy) <= 60 and instr(doy,"@") then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 100 and dox = "myw1" and session("userID") <> "" then
tempok = "y"
end if

' myPage = e.g. "\corpora.asp" *******************

if len(doy) > 45 and dox = "comments" then
tempok = "y"
end if

' academic-license-invoice.asp
if len(doy) > 45 and (dox = "info" or dox = "info1") then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 140 and dox = "url" then
tempok = "y"
end if

if dox <> "univn" and len(doy) > 55 and tempok = "" and okDavies = "" then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A081'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A081",dox,doy)
response.end
end if

else ' is register.asp or user_account.asp

' response.write "@" & len(dox) & "@"
' response.end

if dox = "mysubmit" and len(dox) >= 25 and len(dox) <= 32 then
ignoreIt = "y"
end if

if dox <> "info" and dox <> "oldurl" and dox <> "url" and len(doy) > 80 and ignoreIt = "" then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A082'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
myPage = Request.ServerVariables("URL")
call logit("A082",dox,doy)
response.end
end if

if dox = "url" and left(doy,9) = "[url=http" and ignoreIt = "" then
sql = "insert into hacker(IP,pager,whendo,numo) values ('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Request.ServerVariables("URL") & "',current_timestamp," & session("hack") & ")"
connhack.execute (sql)
session("hack") = session("hack") + 1
call logit("A083",dox,doy)
response.end
end if

if dox = "url" and len(doy) > 120 and left(doy,4) <> "http" and ignoreIt = "" then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A083'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A083",dox,doy)
response.end
end if

end if ' register.asp

' --------------------

if instr(dox,"content") or instr(dox,"fuck") or instr(dox,"accesstoken") or instr(dox,"fbclid") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A069'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A069",dox,doy)
response.end
end if

if instr(doy,"chr(") or instr(doy,"char(") or instr(doy,"ch[") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A070'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A070",dox,doy)
response.end
end if

if instr(doy,"http") and dox = "info" then
response.write "Cannot include web address (e.g. http://...) in profile field. Just replace it, e.g. <u>http://myUniv.edu</u> with <u>myUniv.edu</u>"
call logit("A071",dox,doy)
response.end
end if

if instr(doy,"http") and dox <> "oldurl" and dox <> "url" and dox <> "url_o" and dox <> "myurl" then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A072'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A072",dox,doy)
response.end
end if

' ******************************************

if instr(doy,"select") or instr(doy,"exec(") or instr(doy,"char%") or instr(doy,"char(") or instr(doy,"chr(") or instr(doy,"cast(") or instr(doy,"convert(") then
tricky = "y"
end if


if instr(lcase(doy),"selecte@my") > 0 or instr(lcase(doy),"selecte") > 0 or instr(lcase(doy),"selecter") > 0 then
ok5 = "y"
end if

if ok5 = "" and tricky = "y" and myIP <> "136.36.172.52" then

if instr(doy,"drop") or instr(doy,"where") or instr(doy,"union") or instr(doy,"truncate") or instr(doy,"select") or instr(doy,"update") or instr(doy,"insert") or instr(doy,"delete") then
call logit("A084",dox,doy)
end if

if instr(doy,"DROP") or instr(doy,"WHERE") or instr(doy,"UNION") or instr(doy,"TRUNCATE") or instr(doy,"SELECT") or instr(doy,"UPDATE") or instr(doy,"INSERT") or instr(doy,"DELETE") then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A085'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A085",dox,doy)
response.end
end if

end if

if tricky = "y" and len(doy) >= 120 then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A086'. In your email, also include:<br>[" & dox & "]<br>" & doy & "<hr>"
call logit("A086",dox,doy)
response.end
end if

' --------------------

end if

next

' ================================

if was_hack = "y" and ignoreIt = "" then

if doy_bad <> "" then
qs_orig = "qwq!" & doy_bad
end if

sql_bad = left(qs_orig,50)

set connhack = server.CreateObject("ADODB.Connection")
connhack.Open("Provider=SQLNCLI11;Server=(local);Database=logs;Trusted_Connection=yes")

Set rs_hack = Server.CreateObject("ADODB.Recordset")
sql = "insert into hacker(IP,pager,whendo,numo,sql) values ('" & Request.ServerVariables("REMOTE_ADDR") & "','" & Request.ServerVariables("URL") & "',current_timestamp,0,'" & sql_bad & "')"
connhack.execute (sql)

session("hack") = session("hack") + 1

response.write "root/5"

response.end

end if

end if

' ================================

sub logit(coder,dox,doy)

session("hack") = session("hack") + 1

if instr(Request.ServerVariables("URL"),"survey-vc") <= 0 then

if 5=6 then
response.write "coder: " & coder & "<br>"
response.write "dox: " & dox & "<br>"
response.write "doy: " & doy & "<br>"
end if

if len(doy) >= 1000 then
doy = left(doy,999)
end if

if instr(Request.ServerVariables("URL"),"/coca/") > 0 or instr(Request.ServerVariables("URL"),"/bnc/") > 0 or instr(Request.ServerVariables("URL"),"/googlebooks/") > 0 or instr(Request.ServerVariables("URL"),"/now/") > 0 or instr(Request.ServerVariables("URL"),"/iweb/") > 0 or instr(Request.ServerVariables("URL"),"/coha/") > 0 or instr(Request.ServerVariables("URL"),"/glowbe/") > 0 or instr(Request.ServerVariables("URL"),"/coca/") > 0 or instr(Request.ServerVariables("URL"),"/tv/") > 0 or instr(Request.ServerVariables("URL"),"/movies/") > 0 then
pageOK = "y"
end if

doy = replace(doy,"'","''")

if pageOK <> "y" and ignoreIt = "" then

set connhack = server.CreateObject("ADODB.Connection")
connhack.Open("Provider=SQLNCLI11;Server=(local);Database=logs;Trusted_Connection=yes")

Set rs_hack = Server.CreateObject("ADODB.Recordset")
sql = "insert into hacker2(IP,page,code,dox,doy,whendo) values ('"
sql = sql & Request.ServerVariables("REMOTE_ADDR") & "','"
sql = sql & Request.ServerVariables("URL") & "','"
sql = sql & coder & "','" & dox & "','" & doy & "',current_timestamp)"
session("errSQL") = sql
connhack.execute(sql)

connhack.close
set connhack = nothing

end if

response.write "Blocked.<br>"

select case dox

case "info"
response.write "Make the [profile] field shorter, and/or try to simplify the characters and use mainly letters and/or numbers.<br>For more information contact "

case "email"
response.write "Make the [email] field shorter, and/or try to simplify the characters and use mainly letters and/or numbers.<br>For more information contact "

case "password"
response.write "Make sure that the password field does not have non-Roman characters (i.e. no characters from Chinese, Arabic, or Russian) and that it does not have a web address (e.g. http://...) as part of the password.<br>For more information contact "

case else
response.write "Contact "

end select

if ignoreIt = "" then

response.write "admin@english-corpora.org for help.<br><br>In your email, include:<br><br>"
response.write "Time: " & now() & "<br>"
response.write "Page: " & Request.ServerVariables("URL") & "<br>"
response.write "Code: " & coder & "<br>"
response.write "IP: " & Request.ServerVariables("REMOTE_ADDR") & "<br>"
' response.write "Field: " & dox & "<br>"
' response.write "Value: " & doy & "<hr>"
response.end

end if

end if ' if instr(Request.ServerVariables("URL"),"survey-vc") <= 0 then

end sub

%>