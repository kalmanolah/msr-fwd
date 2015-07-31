## msr-fwd

`msr-fwd` is a daemon that wraps around [`msr-cli`][1], forwarding all data
to a specified HTTP endpoint.

### Configuration

Configuration can be found in `/usr/local/etc/msr-fwd.cfg`.

### Installing

Please ensure that [`fpm`][2] is installed if you want to build the package.

Debian & derivatives:

```
./package.sh
dpkg -i python-msr-cli_0.0.1-1_all.deb
dpkg -i msr-fwd_0.0.1-1_all.deb
systemctl daemon-reload
systemctl enable msr-fwd
systemctl start msr-fwd
```

RH/CentOS & derivatives:

```
./package.sh
rpm -Uvh python-msr-cli-0.0.1-1_noarch.rpm
rpm -Uvh msr-fwd-0.0.1-1.noarch.rpm
systemctl daemon-reload
systemctl enable msr-fwd
systemctl start msr-fwd
```

[1]: https://github.com/kalmanolah/msr-cli
[2]: https://github.com/jordansissel/fpm
