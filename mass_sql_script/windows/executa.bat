@echo off
cls
for /F %%x in (bancos.conf) do (
	echo CONNECT "%%x" user 'sysdba' password 'masterkey'; > script_.sql
	type script.sql >> script_.sql
	isql -i script_.sql
	del script_.sql
)
