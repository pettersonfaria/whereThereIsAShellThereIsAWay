#!/bin/bash
dir=`dirname $(readlink -f $0)`
out="${dir}/out.txt"
URL="http://www.incp.org.br/portal/internet/incp/arquivos"
# dia, mes, ano, 6 digitos
for sequencial in `seq 100000 1 999999`; do
	urlcompleta="${URL}/1_1092012${sequencial}.pdf"
	retorno=`curl -w '%{http_code}\n' -s -X HEAD ${urlcompleta}`
	# 200 = ok
	if [ ${retorno} -eq 200 ]; then
		echo "${retorno} - ${urlcompleta}" >> ${out}
		break;
	fi
done