@echo off

for /r %%i in (.\*.jpg) do (
	@REM magick .\%%~ni.jpg -quality 100 .\%%~ni.webp
    @echo %%~ni

    set var = %%~ni

    @echo %var%
)
