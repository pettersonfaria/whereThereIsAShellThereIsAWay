#!/bin/bash
for banco in `cat bancos.conf`; do
	cat <<-fim > "script_.sql"
		CONNECT "$banco" user 'sysdba' password 'masterkey';
		$(cat script.sql)
	fim
	sudo ./isql-fb -i "script_.sql"
	rm "script_.sql"
done
