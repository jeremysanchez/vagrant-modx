Vagrant-MODx
============

MODx bootstrap for Vagrant in plain bash.

This will setup a MODx env that it ready to run the setup at http://127.0.0.1/setup.
- Webserver at 80*
- MySQL sever at 443* 

(*requires Vagrant Triggers plugin)

The MODx install will be in the directory of the Vagrantfile in /public (which gives /vagrant/public in the VM).

It will also...
- Setup so that you can connect to MySQL from the host
- Configure your local timezone
- Set PHP display_errors = On
- Enable Apache rewrite (But does NOT rename the ht.acces-file)
- Install VIM in the VM

#Config info
__MySQL__
- User: root
- Password: root
- Database: modx
