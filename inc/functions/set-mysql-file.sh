
###################################
## MySQL tmp config file
###################################

echo "
[client]
user = ${mysql_user}
password = ${mysql_pass}
host = localhost
" >> "my-magetools.cnf";
chmod 644 my-magetools.cnf;


