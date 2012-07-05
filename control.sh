if [ -z "$1" ] 
then
  echo "$0 [start|stop]"
else
	thin -s 2 -C config.yml -R config.ru $1
fi

