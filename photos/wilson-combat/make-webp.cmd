@echo off

for /r %%i in (.\*.jpg) do (
	magick .\%%~ni.jpg -quality 100 .\%%~ni.webp
)

for /r %%i in (.\*.png) do (
	magick .\%%~ni.png -quality 100 .\%%~ni.webp
)