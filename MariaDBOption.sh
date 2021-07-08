#/bin/bash
# This is MariaDB custom setting script

CONFIG_MY_INNODB="/etc/my.cnf.d/my-innodb-heavy-4G.cnf"
CONFIG_SERVER_CNF="/etc/my.cnf.d/server.cnf"
CONFIG_SYSTEMD_MARIADB="/etc/systemd/system/multi-user.target.wants/mariadb.service"

echo "[INFO] Start changing DB options." 
grep '^old_password' $CONFIG_MY_INNODB -q

if [ $? -eq 0 ]; then
	echo "[INFO] Option is existed"
else [ $? -eq 1 ]
	sed -i '46 iold_passwords = 0' $CONFIG_MY_INNODB
fi

grep '^innodb_buffer_pool_instances' $CONFIG_MY_INNODB -q

if [ $? -eq 0 ]; then
	echo "[INFO] Option is existed"
else [ $? -eq 1 ]
	sed -i '47 iinnodb_buffer_pool_instances = 8' $CONFIG_MY_INNODB
fi

grep '^innodb_file_per_table' $CONFIG_MY_INNODB -q

if [ $? -eq 0 ]; then
	echo "[INFO] Option is existed"
else [ $? -eq 1 ]
	sed -i '48 iinnodb_file_per_table = 1' $CONFIG_MY_INNODB
fi

sed -i '49 iopen-files-limit = 30000 ' $CONFIG_MY_INNODB
sed '50d' $CONFIG_MY_INNODB

sed -i 's|^transaction_isolation = .*|transaction_isolation = READ-COMMITTED|g' $CONFIG_MY_INNODB
sed -i 's|^max_connections = .*|max_connections = 1000|g' $CONFIG_MY_INNODB

echo "[INFO] You should set up your system memory up to 50%"
echo -n "buffer_pool_size (ex.> 2G,4G ) : "
read sizeValue

sed -i "s|^innodb_buffer_pool_size = .*|innodb_buffer_pool_size = $sizeValue|g" $CONFIG_MY_INNODB

echo "[INFO] Would you like to set up MySql-bin-log ( Yes / No ) : "

read answer
  
  case $answer in
   Yes|y|Y|YES|yes)
    sed -i 's|^log-bin=.*|log-bin=mysql-bin|g' $CONFIG_MY_INNODB
	sed -i 's|^binlog_format=.*|binlog_format=mixed|g' $CONFIG_MY_INNODB
  ;;
   no|N|No|NO|n)
    sed -i 's|^log-bin=.*|# log-bin=mysql-bin|g' $CONFIG_MY_INNODB
	sed -i 's|^binlog_format=.*|# binlog_format=mixed|g' $CONFIG_MY_INNODB
 ;;
 *)
  echo "[INFO] You must input Yes or NO"
  exit 1
  esac
  
grep '^thread_handling' $CONFIG_SERVER_CNF -q

if [ $? -eq 0 ]; then
	echo "[INFO] Option is existed"
else [ $? -eq 1 ]
	sed -i '14 ithread_handling = pool-of-threads' $CONFIG_SERVER_CNF
fi

echo "[INFO] You should set up LimitNOFILE Line"
echo -n "LimitNOFILE (ex.> 30000,40000 ) : "
read limitValue

systemctl enable mariadb
sed -i "s|^LimitNOFILE=.*|LimitNOFILE=$limitValue|g" $CONFIG_SYSTEMD_MARIADB

systemctl restart mariadb

echo "[INFO] Checking open-files-limit!! "
echo "[INFO] Input DB PASSWORD ."

# 패스워드 검증 프로세스 추가
while [ $? -le 1  ]
do 
    mysql -uroot -p -A -e "show variables like 'open_file%';"
    if [ $? -eq 0 ]; then
      break;
    fi
done

echo "[INFO] Setup Complete !!"