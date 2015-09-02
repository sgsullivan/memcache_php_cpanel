# memcache_php_cpanel
Adds Memcache PHP Module to cPanel EasyApache

Upstream module: https://pecl.php.net/package/memcache

It is important to note, this only will install the PHP module. If you
want to connect to a local memcached server, you will need to install
memcached separately. On most any linux distro these days you can just
install memcached with your package manager. 

Installation
=============

    cd /var/cpanel/easy/apache/custom_opt_mods/
    git clone https://github.com/sgsullivan/memcache_php_cpanel.git .
    /scripts/easyapache

In the EasyApache menu, select the 'Memcache' option, then build!
