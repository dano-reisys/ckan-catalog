# ckan-catalog 

### Requirements

* VirtualBox @ https://www.virtualbox.org/
* Vagant @ https://www.vagrantup.com/

### Instructions
1. Clone repository
2. `cd` to cloned repository
3. Run `vagrant up`
4. Run `cd /vagrant/scripts/db/` (on the guest machine)
5. Run `sh restore_dbs_blank.sh` (Note: make sure that you have the ckan databse at config /vagrant/db/minimized.db)
5. Access ckan-ngds instance @ `192.168.10.52` or add `192.168.10.52 catalog` to `/etc/hosts` and access the app at: `http://catalog`
6. Use admin:admin to log in as the administration (make sure you deselect `Remember me` checkbox at the login dialog)

### Development
The source files are located @ `src/`
