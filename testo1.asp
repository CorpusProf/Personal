<!--#include file ="nohack.asp"-->
<html>

<head>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans">

<style>

@media screen and (max-width: 699px)
{

  p { font-family: "Open Sans",sans-serif; font-size: 40px; text-align: justify; }

  div.header_mobile
  {
    display: inline;
  }

  div.header_normal
  {
    display: none;
  }
}

@media screen and (min-width: 700px)
{

  p { font-family: "Open Sans",sans-serif; font-size: 30px; text-align: justify; }

  div.header_mobile
  {
    display: none;
  }

  div.header_normal
  {
    display: inline;
  }
}

</style>

</head>

<body link="#0000FF" vlink="#0000FF" alink="#0000FF">

<div class="header_normal">
<p>Normal
</div>

<div class="header_mobile">
<p>Mobile
</div>

</body>
</html>


