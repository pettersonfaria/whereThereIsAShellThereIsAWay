#!/bin/bash
if [ -z $1 ]; then
  echo
  echo \# Use: $0 \<pasta\>
  echo
  exit 0
fi
pasta_do_ftp="$1"
lista_geral="./lista-geral.txt"
lista_duplicados="./lista-duplicados.txt"

if [ -f ${lista_geral} ]; then
  > ${lista_geral}
fi

for arquivo in `find ${pasta_do_ftp} -name \* |grep -v .git/`; do
  if [ -f $arquivo ]; then
    echo "`sha1sum ${arquivo} |cut -d ' ' -f1` ${arquivo}" >> ${lista_geral}
  fi
done

if [ -f ${lista_duplicados} ]; then
  > ${lista_duplicados}
fi

for duplicado in `cat ${lista_geral}|cut -d' ' -f1 |uniq -d`; do
cat <<EOF>> ${lista_duplicados}
# ${duplicado}
`grep ${duplicado} ${lista_geral}`
`echo`
EOF
done
