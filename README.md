# ckan-catalog 

### Requirements

* VirtualBox @ https://www.virtualbox.org/
* Vagant @ https://www.vagrantup.com/

### Instructions
1. Clone repository
2. `cd` to cloned repository
3. Run `vagrant up`
4. Run `sh /vagrant/scripts/db/restore_dbs_blank.sh` (on the guest machine)
5. Access ckan-ngds instance @ `192.168.10.52` or add `192.168.10.52 catalog` to `/etc/hosts` and access the app at: `http://catalog`
6. Use admin:admin to log in as the administration (make sure you deselect `Remember me` checkbox at the login dialog)

### Development
The source files are located @ `src/`
