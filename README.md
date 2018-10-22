SHOW GLOBAL variables LIKE 'open%';
SHOW GLOBAL variables LIKE '%buffer_pool_size%';
SHOW GLOBAL STATUS LIKE 'Opened_tables';

vi /etc/systemd/system/mysql.service
systemctl daemon-reload

