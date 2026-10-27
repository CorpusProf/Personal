<%

refer = request.servervariables("http_referer")

qs = request.servervariables("query_string")
qs = lcase(qs)
if instr(qs,"convert(") or instr(qs,"char(") then
response.end
end if

IP = Request.ServerVariables("REMOTE_ADDR")

For Each sItem In Request.Form

dox = sItem
dox = lcase(dox)
doy = Request.Form(dox)

if len(doy) > 0 then

doy = lcase(doy)

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

if instr(refer,"profile_new.asp") <= 0 and instr(refer,"/user_account.asp") <= 0 then

if len(doy) > 45 and len(doy) <= 60 and instr(doy,"@") then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 100 and dox = "myw1" and session("userID") <> "" then
tempok = "y"
end if

if len(doy) > 45 and len(doy) < 100 and dox = "url" then
tempok = "y"
end if

if dox <> "univn" and len(doy) > 55 and tempok = "" and okDavies = "" then
response.write "Blocked. Contact admin@english-corpora.org with code 'A089'. In your email, also include:<br>[" & dox & "]<br>" & doy
response.end
end if

else ' is profile_new.asp or user_account.asp

if dox <> "info" and dox <> "oldurl" and dox <> "url" and len(doy) > 80 then
response.write "Blocked. Contact admin@english-corpora.org with code 'A090'. In your email, also include:<br>[" & dox & "]<br>" & doy
response.end
end if

if dox = "url" and len(doy) > 120 and left(doy,4) <> "http" then
response.write "Blocked. Contact admin@english-corpora.org with code 'A091'. In your email, also include:<br>[" & dox & "]<br>" & doy
response.end
end if

end if ' profile_new.asp

' --------------------

if instr(doy,"exec(") or instr(doy,"%") or instr(doy,"char(") or instr(doy,"=") or instr(doy,"chr(") or instr(doy,"cast(") or instr(doy,"convert(") then
tricky = "y"
end if

if tricky = "y" then
if instr(doy,"drop") or instr(doy,"where") or instr(doy,"union") or instr(doy,"truncate") or instr(doy,"select") or instr(doy,"update") or instr(doy,"insert") or instr(doy,"delete") then
response.write "Blocked. Contact admin@english-corpora.org with code 'A092'. In your email, also include:<br>[" & dox & "]<br>" & doy
response.end
end if
end if

if tricky = "y" and len(doy) >= 110 then
' response.write "Blocked. Contact admin@english-corpora.org with code 'A093'. In your email, also include:<br>[" & dox & "]<br>" & doy
' response.end
end if

' --------------------

end if

next

%>