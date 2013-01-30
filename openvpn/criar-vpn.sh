#!/bin/bash
# pettersonfaria @ 2011-11-04
if [ -z $1 ]; then
	echo "Modo de usar: $0 <numero_de_clientes>"
else
if [ `whoami` == "root" ]; then
_dir="/etc/openvpn"
_rsa="$_dir/easy-rsa"
_vars="$_rsa/vars"
_keys="$_rsa/keys"
_inicial="`pwd`"

echo \# verificando se existe o diretorio openvpn...
if [ ! -d $_dir ]; then
	echo \# instalando openvpn...
	aptitude install openvpn -y >/dev/null 2>&1
	sleep 1
	cp -a /usr/share/doc/openvpn/examples/easy-rsa/2.0 $_rsa
	mkdir $_dir/keys
else 
	if [ ! -d $_rsa ]; then
		cp -a /usr/share/doc/openvpn/examples/easy-rsa/2.0 $_rsa
	fi
	if [ ! -d $_dir/keys ]; then
		mkdir $_dir/keys
	fi
fi
cp -a $_inicial/vars $_vars
sleep 1
source $_vars
. $_rsa/clean-all 2>&1
clear
. $_rsa/build-ca 2>&1
clear
. $_rsa/build-key-server servidor 2>&1

for i in `seq 1 $1`; do
	clear
	. $_rsa/build-key cliente$i 2>&1
done

clear
echo \# criando diffie hellman \(DH\)
. /$_rsa/build-dh 2>&1

echo \# gerando chave estatica
openvpn --genkey --secret $_keys/static.key
sleep 1

echo \# removendo *.csr
rm $_keys/*.csr

if [ -e $_inicial/servidor.tar.gz ]; then
	rm $_inicial/servidor.tar.gz
fi
if [ -e $_inicial/cliente1.tar.gz ]; then
	rm $_inicial/cliente*.tar.gz
fi

echo \# copiando certificados e chaves para $_dir/keys
cp -a $_keys/dh2048.pem $_keys/ca.crt $_keys/servidor.crt $_keys/servidor.key $_keys/static.key $_dir/keys

echo \# copiando openvpn.conf
cp -a $_inicial/openvpn.conf $_dir

cd $_dir
echo \# salvando conf do servidor
tar -cvzf servidor.tar.gz openvpn.conf keys 2>&1
mv servidor.tar.gz $_inicial
cd -

echo \# compactando as chaves dos clientes...
for i in `seq 1 $1`; do
	if [ ! -d $_keys/keys ]; then
		mkdir $_keys/keys
	fi
	echo \# copiando modelo de client.conf
	
	#criando client.conf
	cat <<-EOF > $_keys/client.ovpn
	remote 172.16.0.1
	ifconfig 172.16.0.$(($i+1)) 255.255.0.0
	dev tap
	tls-client
	proto udp
	port 22222
	cert "c:\\arquivos de programas\\openvpn\\config\\keys\\cliente$i.crt"
	key "c:\\arquivos de programas\\openvpn\\config\\keys\\cliente$i.key"
	dh "c:\\arquivos de programas\\openvpn\\config\\keys\\dh2048.pem"
	ca "c:\\arquivos de programas\\openvpn\\config\\keys\\ca.crt"
	tls-auth "c:\\arquivos de programas\\openvpn\\config\\keys\\static.key"
	persist-key
	persist-tun
	ping-timer-rem
	keepalive 15 60
	EOF
	# fim do client.conf
	
	cp -a $_keys/static.key $_keys/ca.crt $_keys/dh2048.pem $_keys/cliente$i.crt $_keys/cliente$i.key $_keys/keys/
	cd $_keys	
	tar -cvzf cliente$i.tar.gz client.ovpn keys 2>&1
	mv cliente$i.tar.gz $_inicial
	cd -
	rm -rf $_keys/keys/ 
done
chmod +x /etc/init.d/openvpn
/etc/init.d/openvpn start 2>&1
ls -l $_inicial/*.tar.gz
else 
	echo "use sudo ou root user!"
fi
fi
