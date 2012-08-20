#!/bin/bash
log="/var/log/proftpd/xferlog"
tmp="/tmp/xferlog.tmp"

if [ -z $1 ]; then
    echo "falta de parametros"
    exit 0
else
  filtro="$2"
  tac $log |grep -i $1 > $tmp
fi

fmes(){
    case $1 in
    Jan) echo "01";; Feb) echo "02";; Mar) echo "03";; Apr) echo "04";;
May) echo "05";; Jun) echo "06";; Jul) echo "07";; Aug) echo "08";;
Sep) echo "09";; Oct) echo "10";; Nov) echo "11";; Dec) echo "12";;
esac
}
facao(){
    case $1 in
        o) echo "baixou";; i) echo "enviou";; d) echo "deletou";;
esac
}
ftransf(){
    case $1 in
        i) echo "incompleta";; c) echo "concluido";;
esac
}
farq(){
    prepath="/home/ppu/ftp"
    inicio="${#prepath}"
    echo ${1:$inicio}
}

echo "<table border=1 align=center>"
if [ `wc -l $tmp|cut -d' ' -f1` -gt 0 ]; then
    linhac="1"
    while read linha; do
        set -- $linha
        if [ ${filtro} == "last" ]; then
            if [ ${linhac} -gt 10 ]; then
                break
            fi
        elif [ ${filtro} != "n" ]; then
                case ${12} in
                *) if [ ${12} != $filtro ]; then
                    continue
                    fi ;;
                esac
        fi

        if [ $((linhac % 2)) == 0 ]; then
            echo "<tr id=a>"
        else
            echo "<tr>"
        fi
        echo "<td>${3}/`fmes ${2}`/${5} </td> <td> ${14} </td> <td>`facao ${12}` </td> <td> `farq ${9}` </td> </tr>"
        let linhac++
    done < $tmp
else
    echo "<tr><td>Sem resultados</td></tr>"
fi

echo "</table>"
echo "<p align=center><a href=\"http://ppu/ftp/\">Voltar</a>"
