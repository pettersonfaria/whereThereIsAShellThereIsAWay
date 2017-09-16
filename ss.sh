if [ -z $1 ]; then
echo \# Use $0 \<lista\>
exit 0
fi

for i in `cat $1|grep -v ^#`; do 

arquivo=$i
novo=`echo $arquivo|cut -f1 -d'.'`
final=${novo}.ts
echo \# baixando $final
echo curl -s "https://silviosande.localmidia.com.br/silviosande2/_definst_/silviosande/ISSCRICIUMA/CONTABILIDADE/AULA01PARTE01.mp4/${arquivo}" -H "Host: silviosande.localmidia.com.br" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:55.0) Gecko/20100101 Firefox/55.0" -H "Accept: */*" -H "Accept-Language: pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3" --compressed -H "Referer: https://www.silviosande.com.br/cursos/player/00000035505/00000000148/00000000628/00000005259" -H "Origin: https://www.silviosande.com.br" -H "Connection: keep-alive" \> $final

done
