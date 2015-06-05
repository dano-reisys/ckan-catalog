#!/usr/bin/env bash

# install solr
yum install -y java-1.7.0-openjdk.x86_64

if [ ! -f /usr/share/tomcat6/webapps/solr.war ]; then
  rm -rf /var/solr
  mkdir -p /var/solr
  cd /var/solr
  tar zxf /vagrant/config/solr/ngds.solr.tgz
  cp -rf /vagrant/config/solr/schema.xml /var/solr/ngds/conf/schema.xml
  cp -rf /vagrant/config/solr/solrconfig.xml /var/solr/ngds/conf/solrconfig.xml
  chown -R tomcat:tomcat /var/solr/

  service tomcat6 start
  cd /tmp
  echo "Downloading solr 4.2.1 ..."
  curl -LfsOS http://packages.reisys.com/ckan/solr/solr-4.2.1.tgz  
  if [ ! -f /tmp/solr-4.2.1.tgz ]; then
    echo "Error: coud not download solr package."
    echo "Solr needs to be install manually."
    # exit out of solr
  else
    tar zxf solr-4.2.1.tgz
    cp solr-4.2.1/dist/solr-4.2.1.war /usr/share/tomcat6/webapps/solr.war

    # wait 2+ min for war file to be deployed
    echo "Deploying solr 4.2.1 ..."
    n=0
    ret=0
    until [ $n -ge 30 ]
    do
      sleep 5
      if [ -f /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml ]; then
        ret=1
        break
      fi
      n=$[$n+1]
    done

    if [ $ret -eq 0 ]; then
      echo "ERROR: solr deployment failed. It needs to be fixed manually."
      # exit out of solr
    else
      cp -f /vagrant/config/solr/solr.web.xml /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml
      chown tomcat:tomcat /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml
      service tomcat6 restart

      echo "Preparing solr core for ngds..."
      solr_url="http://127.0.0.1:8080/solr/"

      # wait 2+ min for war file to be deployed
      n=0
      until [ $n -ge 30 ]; do
        sleep 5
        reponse_code=$(curl --write-out "%{http_code}\n" --silent --output /dev/null "$solr_url")
        if [ "$reponse_code" = "200" ]; then
          core_url="{$solr_url}admin/cores?wt=json&indexInfo=false&action=CREATE&name=ngds&instanceDir=ngds&dataDir=data&config=solrconfig.xml&schema=schema.xml"
          reponse_code=$(curl --write-out "%{http_code}\n" --silent --output /dev/null "$core_url")
          break
        fi
        n=$[$n+1]
      done

      if [ "$reponse_code" = "200" ]; then
        echo "Solr core done."
      else
        echo "ERROR: solr core creation failed. It need to be fixed manually."
      fi
    fi
  fi
fi

# update schema.xml if needed
if [ $(diff /vagrant/config/solr/schema.xml /var/solr/ngds/conf/schema.xml | wc -l) -gt 0 ]; then
  service tomcat6 stop
  cp -f /vagrant/config/solr/schema.xml /var/solr/ngds/conf/schema.xml
fi

# update solrconfig.xml if needed
if [ $(diff /vagrant/config/solr/solrconfig.xml /var/solr/ngds/conf/solrconfig.xml | wc -l) -gt 0 ]; then
  service tomcat6 stop
  cp -f /vagrant/config/solr/solrconfig.xml /var/solr/ngds/conf/solrconfig.xml
fi
