# CURSO 1  - Google Cloud Platform Fundamentals: Core Infrastructure
--- 
--- 

# GCP COMMANDS

## GCP Cloud Administration and management

# 1) Working with Projects

## How to prepare your Project

  $ gcloud config set project <nome-do-projeto>
 
## How to check and list zones

  $ gcloud compute zones list | grep us-central1

## How to set zone

  $ gcloud config set compute/zone us-central1-a

# 2) Working with Compute Engine

## How to create a MM instance

  $ gcloud compute instances create "vm-do-leo-1" \
    --machine-type "n1-standard-1" \
    --image-project "debian-cloud" \
    --image "debian-9-stretch-v20190213" \
    --subnet "default"

## Connect using SSH

  $ gcloud compute ssh vm-do-leo-1

## Runing commands inside the VM01

  $ ping vm-2.us-central1-a

  $ ssh vm-2.us-central1-a

## Runing commands inside the VM02

  $ sudo apt-get install nginx-light -y
  $ sudo nano /var/www/html/index.nginx-debian.html
  $ curl http://localhost/
  $ exit

## Runing commands inside the VM01

  $ curl http://vm-2.us-central1-a/

# 3) Working with Cloud Storage

## Creating buckets - Cloud Storage bucket

  $ export LOCATION=US
  $ export DEVSHELL_PROJECT_ID=nome-do-projeto
  $ gcloud config set project nome-do-projeto

  $ gsutil mb -l $LOCATION  gs://$DEVSHELL_PROJECT_ID
  $ gsutil mb gs://bucket-de-leo

## Copying files

  $ gsutil cp gs://<bucket>/image.png image.png
  $ gsutil cp image2.png gs://$DEVSHELL_PROJECT_ID/image2.png
  $ gsutil cp lang_go.png gs://bucket-de-leo

## List files in bucket

  $ gsutil ls  gs://$DEVSHELL_PROJECT_ID
  $ gsutil ls gs://bucket-de-leo/

## Giving permission

  $ gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID/image2.png

## Deleting file from bucket 

  $ gsutil rm gs://bucket-de-leo/lang_go.png 

## Add image from bucket in a page
   
  <img src='https://<bucket>/image2.png'>

# 4) Cloud SQL

## Creating MySql

  database: teste-db
  pass: MfC1GPFys2rjf52E

## Add User
    
  user: testeuser

## Create connection

  <IP:3306>
    
## Creating a PHP code 

  $ cd /var/www/html

  $ sudo nano index.php

  <html>
        <head><title>Welcome to my page</title></head>
        <body>
        <h1>Welcome to my excellent blog</h1>
        <?php
        $dbserver = "CLOUDSQLIP";
        $dbuser = "blogdbuser";
        $dbpassword = "DBPASSWORD";

        $conn = new mysqli($dbserver, $dbuser, $dbpassword);

        if (mysqli_connect_error()) {
                echo ("Database connection failed: " . mysqli_connect_error());
        } else {
                echo ("Database connection succeeded.");
        }
        ?>
        </body>
  </html>

  $ sudo service apache2 restart

  http://Ip/index.php

# 5) GKE

## working with GKE - Enable API

  Kubernetes Engine API
  Container Registry API

## Set Config

  $ export MY_ZONE=us-central1-a
  $ gcloud config set project <project>
    
## Create adn config GKE

  $ gcloud container clusters create webfrontend --zone $MY_ZONE --num-nodes 2
  $ kubectl version
  $ kubectl get nodes

## Deploying

  $ kubectl create deploy nginx --image=nginx:1.17.10
  $ kubectl get pods
  $ kubectl expose deployment nginx --port 80 --type LoadBalancer
  $ kubectl get services
  $ kubectl scale deployment nginx --replicas 3
  $ kubectl get pods
  $ kubectl get services

# 6) APP Engine

## Creating APP

  $ gcloud config set project <project>
  $ gcloud auth list
  $ gcloud config list project

  $ export DEVSHELL_PROJECT_ID=<project>
  $ gcloud app create --project=$DEVSHELL_PROJECT_ID

## Creating a Python APP

  $ git clone https://github.com/GoogleCloudPlatform/python-docs-samples
  $ cd python-docs-samples/appengine/standard_python3/hello_world

  $ sudo apt-get update
  $ sudo apt-get install virtualenv

  $ virtualenv -p python3 venv
  $ source venv/bin/activate

  $ pip install  -r requirements.txt
  $ cd ~/python-docs-samples/appengine/standard_python3/hello_world
  $ gcloud app deploy

# 7) Getting Started with Deployment Manager and Cloud Monitoring

## Deploying Automatically

    $ export MY_ZONE=qwiklabs-gcp-01-6bb2ae99d9fe
    $ export MY_ZONE=us-central1-a
    $ gsutil cp gs://cloud-training/gcpfcoreinfra/mydeploy.yaml mydeploy.yaml
    $ sed -i -e "s/PROJECT_ID/$DEVSHELL_PROJECT_ID/" mydeploy.yaml
    $ sed -i -e "s/ZONE/$MY_ZONE/" mydeploy.yaml
    $ cat mydeploy.yaml
    $ gcloud deployment-manager deployments create my-first-depl --config mydeploy.yaml

    value: "apt-get update; apt-get install nginx-light -y"

    $ gcloud deployment-manager deployments update my-first-depl --config mydeploy.yaml

    Scroll down to the bottom of the page and select Compute Engine default service account from Service account dropdown.

    Select Allow full access to all Cloud APIs for Access scopes.

    $ dd if=/dev/urandom | gzip -9 >> /dev/null &

    $ curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
    $ sudo bash install-monitoring-agent.sh

    $ curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
    $ sudo bash install-logging-agent.sh

    $ kill %1

# 8) Working with BigQuery

## Create a Dataset 

    Using console

## create and load a table
    
    $ gs://cloud-training/gcpfci/access_log.csv

## Querying using Editor

    $ select int64_field_6 as hour, count(*) as hitcount from logdata.accesslog
    $ group by hour
    $ order by hour

## Quering using Shell

    $ bq query "select string_field_10 as request, count(*) as requestcount from logdata.accesslog group by request order by requestcount desc"

---
---
# CURSO 2  - Essential Google Cloud Infrastructure: Foundation
---
---

# 9) Working with Shell and persistence

  ## Cloud Shell

    $ gcloud compute regions list

    $ INFRACLASS_REGION=us-east1
    $ echo $INFRACLASS_REGION

    Append the environment variable to a file

    Create a subdirectory for materials used in this lab:

        $ mkdir infraclass

    Create a file called config in the infraclass directory:

        $ touch infraclass/config

    Append the value of your Region environment variable to the config file:

        $ echo INFRACLASS_REGION=$INFRACLASS_REGION >> ~/infraclass/config

    Create a second environment variable for your Project ID, replacing 
    [YOUR_PROJECT_ID] with your Project ID. 

        INFRACLASS_PROJECT_ID=qwiklabs-gcp-03-e8c3738efe52

    Append the value of your Project ID environment variable to the config file:

        $ echo INFRACLASS_PROJECT_ID=$INFRACLASS_PROJECT_ID >> ~/infraclass/config

    Use the source command to set the environment variables, and use the echo command to verify that the project variable was set:

        $ source infraclass/config
        $ echo $INFRACLASS_PROJECT_ID

        $ nano .profile

# Working with Network VPC

## Creating VPC and subnets
    
    $ gcloud compute networks create managementnet --project=qwiklabs-gcp-04-cd4f61e47d34 --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

    $ gcloud compute networks subnets create managementsubnet-us --project=qwiklabs-gcp-04-cd4f61e47d34 --range=10.130.0.0/20 --network=managementnet --region=us-east1

# Subnets

## Creating Subnets

    $ gcloud compute networks create privatenet --subnet-mode=custom

    $ gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-central1 --range=172.16.0.0/24

    $ gcloud compute networks list

    $ gcloud compute networks subnets list --sort-by=NETWORK

## Creating Rules

    $ gcloud compute firewall-rules create <FIREWALL_NAME> --network privatenet --allow tcp,udp,icmp --source-ranges <IP_RANGE>
    $ gcloud compute firewall-rules create <FIREWALL_NAME> --network privatenet --allow tcp:22,tcp:3389,icmp

## Rules

    $ gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

    $ gcloud compute firewall-rules list --sort-by=NETWORK

    $ gcloud compute firewall-rules list --sort-by=NETWORK

    $ gcloud compute ssh vm-internal --zone us-central1-c --tunnel-through-iap

    $ gsutil cp gs://cloud-training/gcpnet/private/access.svg gs://gcp-leo

    $ gsutil cp gs://gcp-leo/*.svg .

    $ gcloud compute ssh vm-internal --zone us-central1-c --tunnel-through-iap

---
---
# CURSO 3  - Essential Google Cloud Infrastructure: Foundation
---
---

## Documents

  https://cloud.google.com/compute/docs/instances/connecting-to-instance#rdp

  https://chrome.google.com/webstore/detail/chrome-rdp-for-google-clo/mpbbnannobiobpnfblimoapbephgifkm?hl=en-US

  $ sudo mkdir -p /home/minecraft

  $ sudo mkfs.ext4 -F -E lazy_itable_init=0,\
  lazy_journal_init=0,discard \
  /dev/disk/by-id/google-minecraft-disk

  $ sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft

  $ sudo apt-get update

  $ sudo apt-get install -y default-jre-headless

  $ cd /home/minecraft

  $ sudo apt-get install wget

  $ sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar

  $ sudo java -Xmx1024M -Xms1024M -jar server.jar nogui

  $ sudo ls -l

  $ sudo nano eula.txt

  $ sudo apt-get install -y screen

  $ sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui

  $ sudo screen -r mcs

  #!/bin/bash
  screen -r mcs -X stuff '/save-all\n/save-off\n'
  /usr/bin/gsutil cp -R ${BASH_SOURCE%/*}/world gs://${YOUR_BUCKET_NAME}-minecraft-backup/$(date "+%Y%m%d-%H%M%S")-world
  screen -r

---
---

# CURSO 4  - Preparing for the Google Cloud Associate Cloud Engineer Exam

---
---

## Documents - Deployment Manager - Full Production [ACE]

  https://coursera.org/share/d5b806afea5d732cf2e73f141fef04ae

# Configurando o Projeto

## 1) Configurações iniciais

    gcloud auth list

    gcloud config list project

    gcloud config set project qwiklabs-gcp-02-9100f96a9ea3

    gcloud config set compute/zone us-central1-a

## 2) Configuração de um Load Balancer

  ### Script de setup

  cat << EOF > startup.sh
  #! /bin/bash
  apt-get update
  apt-get install -y nginx
  service nginx start
  sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
  EOF

  ### Criação de template

  gcloud compute instance-templates create nginx-template \
         --metadata-from-file startup-script=startup.sh

  ### Criação de Target poos

  gcloud compute target-pools create nginx-pool

  ### Criar 2 VMS instancias no pool 

  gcloud compute instance-groups managed create nginx-group \
         --base-instance-name nginx \
         --size 2 \
         --template nginx-template \
         --target-pool nginx-pool

  ### List the compute engine instances and you should see all of the instances created:

  gcloud compute instances list

  ### Now configure a firewall so that you can connect to the machines on port 80 via the EXTERNAL_IP addresses:

  gcloud compute firewall-rules create www-firewall --allow tcp:80

## Create a Network Load Balancer

  ### Create an L4 network load balancer targeting your instance group:

  gcloud compute forwarding-rules create nginx-lb \
         --region us-central1 \
         --ports=80 \
         --target-pool nginx-pool

## List all Google Compute Engine forwarding rules in your project.

  gcloud compute forwarding-rules list

## Create a HTTP(s) Load Balancer

  ### First, create a health check. Health checks verify that the instance is responding to HTTP or HTTPS traffic:

  gcloud compute http-health-checks create http-basic-check

  ### Define an HTTP service and map a port name to the relevant port for the instance group. Now the load balancing service can forward traffic to the named port:

  gcloud compute instance-groups managed \
       set-named-ports nginx-group \
       --named-ports http:80

  ### Create a backend service:

  gcloud compute backend-services create nginx-backend \
      --protocol HTTP --http-health-checks http-basic-check --global

  ### Define an HTTP service and map a port name to the relevant port for the instance group.

  gcloud compute instance-groups managed \
       set-named-ports nginx-group \
       --named-ports http:80

  ### Add the instance group into the backend service:

  gcloud compute backend-services add-backend nginx-backend \
    --instance-group nginx-group \
    --instance-group-zone us-central1-a \
    --global

  ### Create a default URL map that directs all incoming requests to all your instances:

  gcloud compute url-maps create web-map \
    --default-service nginx-backend

  ### Create a target HTTP proxy to route requests to your URL map:

  gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map

  ### Create a global forwarding rule to handle and route incoming requests.

  gcloud compute forwarding-rules create http-content-rule \
        --global \
        --target-http-proxy http-lb-proxy \
        --ports 80

  ### After creating the global forwarding rule, it can take several minutes for your configuration to propagate.

  $ gcloud compute forwarding-rules list
  $ gcloud config set project qwiklabs-gcp-04-a2fa7d82584e  
  $ gcloud config list project

## Create a virtual environment

  ### Execute the following command to download and update the packages list.

  sudo apt-get update

## Python virtual environments are used to isolate package installation from the system.

  sudo apt-get install virtualenv
  sudo apt-get install virtualenv 
  virtualenv -p python3 venv

## Activate the virtual environment.

  source venv/bin/activate

## Clone the Deployment Manager Sample Templates

  mkdir ~/dmsamples 

  cd ~/dmsamples

  git clone https://github.com/GoogleCloudPlatform/deploymentmanager-samples.git

  cd ~/dmsamples/deploymentmanager-samples/examples/v2

## Customize the Deployment

  gcloud compute zones list

  nano nodejs.yaml

  nano nodejs.py

  gcloud deployment-manager deployments create advanced-configuration --config nodejs.yaml

## verify

  gcloud compute forwarding-rules list

  http://35.196.32.149:8080/?msg=po


# Create Uptime

# Create Alerting

# Creating Dashboard

# Load teste

  SSH to VM

  Install ApacheBench

  sudo apt-get update
  sudo apt-get -y install apache2-utils

  ab -n 1000 -c 100 http://35.196.78.89:8080/?msg=teste1

  ab -n 10000 -c 100 http://35.196.78.89:8080/?msg=teste1

---
---
# LAB - Google Kubernetes Engine: Qwik Start [ACE]
---

## Configure Project

  gcloud config list project

  gcloud config set compute/zone us-central1-a

  gcloud container clusters create leo-cluster

  gcloud container clusters get-credentials leo-cluster

  kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0

  kubectl expose deployment hello-server --type="LoadBalancer" --port 8080

  kubectl get service hello-server

  gcloud container clusters delete leo-cluster

## Site Reliability Troubleshooting with Cloud Monitoring APM [ACE]

  gcloud config set project  qwiklabs-gcp-04-e770ce803cdf

  gcloud auth list

  gcloud config list project

## Infrastructure setup

  gcloud config set compute/zone us-west1-b

  export PROJECT_ID=$(gcloud info --format='value(config.project)')

  gcloud container clusters list

## Create a Monitoring workspace

  gcloud container clusters list

  gcloud container clusters get-credentials shop-cluster --zone us-west1-b

  kubectl get nodes

## Deploy application

  git clone https://github.com/GoogleCloudPlatform/training-data-analyst

  ln -s ~/training-data-analyst/blogs/microservices-demo-1 ~/microservices-demo-1

  curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin

  cd microservices-demo-1
  skaffold run

  kubectl get pods

  export EXTERNAL_IP=$(kubectl get service frontend-external | awk 'BEGIN { cnt=0; } { cnt+=1; if (cnt > 1) print $4; }')

  curl -o /dev/null -s -w "%{http_code}\n"  http://$EXTERNAL_IP

  ./setup_csr.sh

---
---
# CURSO 5  - Essential Google Cloud Infrastructure: Core Services
---
---

# Cloud IAM and Compute engine

  Virtual Machines

# Storage

  Object Storage

# Mysql

  wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
  ls
  export SQL_CONNECTION=qwiklabs-gcp-04-05ddffa3ed86:us-central1:wordpress-db
  ./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &

  curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip && echo

# Billig and BigQuery

  Create Dataset.

  create table from csv - gs://cloud-training/archinfra/export-billing-example.csv

## Queries

  SELECT * FROM `imported_billing_data.sampleinfotable` WHERE Cost > 0

  SELECT
  product,
  resource_type,
  start_time,
  end_time,
  cost,
  project_id,
  project_name,
  project_labels_key,
  currency,
  currency_conversion_rate,
  usage_amount,
  usage_unit
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`


  SELECT
  product,
  resource_type,
  start_time,
  end_time,
  cost,
  project_id,
  project_name,
  project_labels_key,
  currency,
  currency_conversion_rate,
  usage_amount,
  usage_unit
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`
  WHERE
  Cost > 0
  ORDER BY end_time DESC
  LIMIT
  100

  SELECT
  product,
  resource_type,
  start_time,
  end_time,
  cost,
  project_id,
  project_name,
  project_labels_key,
  currency,
  currency_conversion_rate,
  usage_amount,
  usage_unit
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`
  WHERE
  cost > 3


  SELECT
  product,
  COUNT(*) AS billing_records
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`
  WHERE
  cost > 1
  GROUP BY
  product
  ORDER BY
  billing_records DESC


  SELECT
  product,
  COUNT(*) AS billing_records
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`
  GROUP BY
  product
  ORDER BY billing_records DESC




  SELECT
  usage_unit,
  COUNT(*) AS billing_records
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`
  WHERE cost > 0
  GROUP BY
  usage_unit
  ORDER BY
  billing_records DESC



  SELECT
  product,
  ROUND(SUM(cost),2) AS total_cost
  FROM
  `cloud-training-prod-bucket.arch_infra.billing_data`
  GROUP BY
  product
  ORDER BY
  total_cost DESC


# Monitoring

## Task 6: Review

  In this lab, you learned how to:

  Monitor your projects
  Create a Cloud Monitoring workspace
  Create alerts with multiple conditions  
  Add charts to dashboards
  Create resource groups
  Create uptime checks for your services

## Lab: Error Reporting and Debugging

  Error Reporting and Debugging

  1) Create an application
  Task 1: Create an application


  mkdir appengine-hello
  cd appengine-hello
  gsutil cp gs://cloud-training/archinfra/gae-hello/* .

  dev_appserver.py $(pwd)


  Deploy the application to App Engine

  gcloud app deploy app.yaml

  gcloud app browse


  sed -i -e 's/webapp2/webapp22/' main.py

  cat main.py

  gcloud app deploy app.yaml --quiet

  gcloud app browse

---
---
# CURSO 4
---
---

# LAB 1 - Virtual Private Networks (VPN)

## Task 1: Explore the networks and instances
  
  Two custom networks with VM instances have been configured for you. For the purposes of the lab, both networks are VPC networks within a Google Cloud project. However, in a real-world application, one of these networks might be in a different Google Cloud project, on-premises, or in a different cloud.

## Explore the networks

  Verify that vpn-network-1 and vpn-network-2 have been created with subnets in separate regions.

  In the Cloud Console, on the Navigation menu (Navigation menu), click VPC network > VPC networks.

  Note the vpn-network-1 network and its subnet-a in us-central1.

  Note the vpn-network-2 network and its subnet-b in europe-west1.

  Explore the firewall rules
  In the navigation pane, click Firewall.
  Note the network-1-allow-ssh and network-1-allow-icmp rules for vpn-network-1.
  Note the network-2-allow-ssh and network-2-allow-icmp rules for vpn-network-2.
  These firewall rules allow SSH and ICMP traffic from anywhere.

  Explore the instances and their connectivity
  Currently, the VPN connection between the two networks is not established. Explore the connectivity options between the instances in the networks.

  In the Cloud Console, on the Navigation menu (Navigation menu), click Compute Engine > VM instances.
  Click Columns, and select Network.
  From server-1, you should be able to ping the following IP addresses of server-2:

  External IP address

  Internal IP address

  Note the external and internal IP addresses for server-2.

  For server-1, click SSH to launch a terminal and connect.

  To test connectivity to server-2's external IP address, run the following command, replacing server-2's external IP address with the value noted earlier:

  ping -c 3 <Enter server-2's external IP address here>
  
  This works because the VM instances can communicate over the internet.

  To test connectivity to server-2's internal IP address, run the following command, replacing server-2's internal IP address with the value noted earlier:

  ping -c 3 <Enter server-2's internal IP address here>
  You should see 100% packet loss when pinging the internal IP address because you don't have VPN connectivity yet.

  Exit the SSH terminal.
  Let's try the same from server-2.

  Note the external and internal IP addresses for server-1.

  For server-2, click SSH to launch a terminal and connect.

  To test connectivity to server-1's external IP address, run the following command, replacing server-1's external IP address with the value noted earlier:

  ping -c 3 <Enter server-1's external IP address here>
  To test connectivity to server-1's internal IP address, run the following command, replacing server-1's internal IP address with the value noted earlier:

  ping -c 3 <Enter server-1's internal IP address here>
  You should see similar results.

  Exit the SSH terminal.
  Why are we testing both server-1 to server-2 and server-2 to server-1?

  For the purposes of this lab, the path from subnet-a to subnet-b is not the same as the path from subnet-b to subnet-a. You are using one tunnel to pass traffic in each direction. And if both tunnels are not established, you won't be able to ping the remote server on its internal IP address. The ping might reach the remote server, but the response can't be returned.

  This makes it much easier to debug the lab during class. In practice, a single tunnel could be used with symmetric configuration. However, it is more common to have multiple tunnels or multiple gateways and VPNs for production work, because a single tunnel could be a single point of failure.

## Task 2: Create the VPN gateways and tunnels

  Establish private communication between the two VM instances by creating VPN gateways and tunnels between the two networks.

  Reserve two static IP addresses
  Reserve one static IP address for each VPN gateway.

  In the Cloud Console, on the Navigation menu (Navigation menu), click VPC network > External IP addresses.

  Click Reserve static address.

  Specify the following, and leave the remaining settings as their defaults:

  Property	Value (type value or select option as specified)
  Name	vpn-1-static-ip
  IP version	IPv4
  Region	us-central1
  Click Reserve.

  Repeat the same for vpn-2-static-ip.

  Click Reserve static address.

  Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	vpn-2-static-ip
IP version	IPv4
Region	europe-west1
Click Reserve.

Note both IP addresses for the next step. They will be referred to us [VPN-1-STATIC-IP] and [VPN-2-STATIC-IP].

Create the vpn-1 gateway and tunnel1to2
In the Cloud Console, on the Navigation menu (Navigation menu), click Hybrid Connectivity > VPN.

Click Create VPN Connection.

If asked, select Classic VPN, and then click Continue.

Specify the following in the VPN gateway section, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	vpn-1
Network	vpn-network-1
Region	us-central1
IP address	vpn-1-static-ip
Specify the following in the Tunnels section, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	tunnel1to2
Remote peer IP address	[VPN-2-STATIC-IP]
IKE pre-shared key	gcprocks
Routing options	Route-based
Remote network IP ranges	10.1.3.0/24
Make sure to replace [VPN-2-STATIC-IP] with your reserved IP address for europe-west1.

Click command line.
The gcloud command line window shows the gcloud commands to create the VPN gateway and VPN tunnels and it illustrates that three forwarding rules are also created.

Click Close.
Click Create.
Click Check my progress to verify the objective.

Create the 'vpn-1' gateway and tunnel
Create the vpn-2 gateway and tunnel2to1
Click VPN setup wizard.

If asked, select Classic VPN, and then click Continue.

Specify the following in the VPN gateway section, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	vpn-2
Network	vpn-network-2
Region	europe-west1
IP address	vpn-2-static-ip
Specify the following in the Tunnels section, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	tunnel2to1
Remote peer IP address	[VPN-1-STATIC-IP]
IKE pre-shared key	gcprocks
Routing options	Route-based
Remote network IP ranges	10.5.4.0/24
Make sure to replace [VPN-1-STATIC-IP] with your reserved IP address for us-central1.

Click Create.
Click Cloud VPN Tunnels.
Click Check my progress to verify the objective.

Create the 'vpn-2' gateway and tunnel
Wait for the VPN tunnels status to change to Established for both tunnels before continuing.

Click Check my progress to verify the objective.

Tunnel establishment
Task 3: Verify VPN connectivity
From server-1, you should be able to ping the following IP addresses of server-2:

External IP address

Internal IP address

Verify server-1 to server-2 connectivity
In the Cloud Console, on the Navigation menu, click Compute Engine > VM instances.

For server-1, click SSH to launch a terminal and connect.

To test connectivity to server-2's internal IP address, run the following command:

ping -c 3 <insert server-2's internal IP address here>
Exit the server-1 SSH terminal.

For server-2, click SSH to launch a terminal and connect.

To test connectivity to server-1's internal IP address, run the following command:

ping -c 3 <insert server-1's internal IP address here>
Remove the external IP addresses
Now that you verified VPN connectivity, you can remove the instances' external IP addresses. For demonstration purposes, just do this for the server-1 instance.

On the Navigation menu, click Compute Engine > VM instances.
Select the server-1 instance and click Stop. Wait for the instance to stop.
Instances need to be stopped before you can make changes to their network interfaces.
Click on the name of the server-1 instance to open the VM instance details page.
Click Edit.
For Network interfaces, click the Edit icon (Edit).
Change External IP to None.
Click Done.
Click Save and wait for the instance details to update.
Click Start.
Click Start again to confirm that you want to start the VM instance.
Return to the VM instances page and wait for the instance to start.
Notice that External IP is set to None for the server-1 instance.
Feel free to SSH to server-2 and verify that you can still ping the server-1 instance's internal IP address. You still be able to SSH to server-1 from the Cloud Console using Cloud IAP as described here.

External IP addresses that don’t fall under the Free Tier will incur a small cost. Also, as a general security best practice, it’s a good idea to use internal IP addresses where applicable and since you configured Cloud VPN you no longer need to communicate between instances using their external IP address.
Task 4: Review
In this lab, you configured a VPN connection between two networks with subnets in different regions. Then you verified the VPN connection by pinging VMs in different networks using their internal IP addresses.

You configured the VPN gateways and tunnels using the Cloud Console. However, this approach obfuscated the creation of forwarding rules, which you explored with the command line button in the Console. This can help in troubleshooting a configuration if needed.

End your lab
When you have completed your lab, click End Lab. Qwiklabs removes the resources you’ve used and cleans the account for you.

You will be given an opportunity to rate the lab experience. Select the applicable number of stars, type a comment, and then click Submit.

The number of stars indicates the following:

1 star = Very dissatisfied
2 stars = Dissatisfied
3 stars = Neutral
4 stars = Satisfied
5 stars = Very satisfied
You can close the dialog box if you don't want to provide feedback.

For feedback, suggestions, or corrections, please use the Support tab.

Copyright 2020 Google LLC All rights reserved. Google and the Google logo are trademarks of Google LLC. All other company and product names may be trademarks of the respective companies with which they are associated.

#################################################################################
## Lab 2 - Internal Load Balancer
#################################################################################

1 hour 30 minutes
Free
Overview
Google Cloud offers Internal Load Balancing for your TCP/UDP-based traffic. Internal Load Balancing enables you to run and scale your services behind a private load balancing IP address that is accessible only to your internal virtual machine instances.

In this lab, you create two managed instance groups in the same region. Then you configure and test an internal load balancer with the instances groups as the backends, as shown in this network diagram:

network_diagram.png

Objectives
In this lab, you learn how to perform the following tasks:

Create internal traffic and health check firewall rules
Create a NAT configuration using Cloud Router
Configure two instance templates
Create two managed instance groups
Configure and test an internal load balancer
For each lab, you get a new GCP project and set of resources for a fixed time at no cost.

Make sure you signed into Qwiklabs using an incognito window.

Note the lab's access time (for example, img/time.png and make sure you can finish in that time block.

There is no pause feature. You can restart if needed, but you have to start at the beginning.

When ready, click img/start_lab.png.

Note your lab credentials. You will use them to sign in to Cloud Platform Console. img/open_google_console.png

Click Open Google Console.

Click Use another account and copy/paste credentials for this lab into the prompts.

If you use other credentials, you'll get errors or incur charges.

Accept the terms and skip the recovery resource page.
Do not click End Lab unless you are finished with the lab or want to restart it. This clears your work and removes the project.

Task 1. Configure internal traffic and health check firewall rules.
Configure firewall rules to allow internal traffic connectivity from sources in the 10.10.0.0/16 range. This rule allows incoming traffic from any client located in the subnet.

Health checks determine which instances of a load balancer can receive new connections. For HTTP load balancing, the health check probes to your load-balanced instances come from addresses in the ranges 130.211.0.0/22 and 35.191.0.0/16. Your firewall rules must allow these connections.

Explore the my-internal-app network
The network my-internal-app with subnet-a and subnet-b and firewall rules for RDP, SSH, and ICMP traffic have been configured for you.

In the Cloud Console, on the Navigation menu (Navigation menu), click VPC network > VPC networks. Notice the my-internal-app network with its subnets: subnet-a and subnet-b.

Each Google Cloud project starts with the default network. In addition, the my-internal-app network has been created for you as part of your network diagram.

You will create the managed instance groups in subnet-a and subnet-b. Both subnets are in the us-central1 region because an internal load balancer is a regional service. The managed instance groups will be in different zones, making your service immune to zonal failures.

Create the firewall rule to allow traffic from any sources in the 10.10.0.0/16 range
Create a firewall rule to allow traffic in the 10.10.0.0/16 subnet.

On the Navigation menu (Navigation menu), click VPC network > Firewall. Notice the app-allow-icmp and app-allow-ssh-rdp firewall rules.

These firewall rules have been created for you.

Click Create Firewall Rule.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	fw-allow-lb-access
Network	my-internal-app
Targets	Specified target tags
Target tags	backend-service
Source filter	IP Ranges
Source IP ranges	10.10.0.0/16
Protocols and ports	Allow all
Make sure to include the /16 in the Source IP ranges.

Click Create.

Create the health check rule
Create a firewall rule to allow health checks.

On the Navigation menu (Navigation menu), click VPC network > Firewall.

Click Create Firewall Rule.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	fw-allow-health-checks
Network	my-internal-app
Targets	Specified target tags
Target tags	backend-service
Source filter	IP Ranges
Source IP ranges	130.211.0.0/22 and 35.191.0.0/16
Protocols and ports	Specified protocols and ports
Make sure to include the /22 and /16 in the Source IP ranges.

For tcp, specify port 80.
Click Create.
Click Check my progress to verify the objective.
Configure internal traffic and health check firewall rules

Task 2: Create a NAT configuration using Cloud Router
The Google Cloud VM backend instances that you setup in Task 3 will not be configured with external IP addresses.

Instead, you will setup the Cloud NAT service to allow these VM instances to send outbound traffic only through the Cloud NAT, and receive inbound traffic through the load balancer.

Create the Cloud Router instance
In the Cloud Console, on the Navigation menu (Navigation menu), click Network services > Cloud NAT.

Click Get started.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Gateway name	nat-config
VPC network	my-internal-app
Region	us-central1
Click Cloud Router, and select Create new router.

For Name, type nat-router-us-central1.

Click Create.

In Create a NAT gateway, click Create.

Wait until the NAT Gateway Status changes to Running before moving onto the next task.

Click Check my progress to verify the objective.
Create a NAT configuration using Cloud Router

Task 3. Configure instance templates and create instance groups
A managed instance group uses an instance template to create a group of identical instances. Use these to create the backends of the internal load balancer.

Configure the instance templates
An instance template is an API resource that you can use to create VM instances and managed instance groups. Instance templates define the machine type, boot disk image, subnet, labels, and other instance properties. Create an instance template for both subnets of the my-internal-app network.

On the Navigation menu (Navigation menu), click Compute Engine > Instance templates.

Click Create instance template.

For Name, type instance-template-1

Under Machine configuration, For Series, Select N1.

Machine type f1-micro(1 vCPU).

Click Management, security, disks, networking, sole tenancy.

Click Management.

Under Metadata, specify the following:

Key	Value
startup-script-url	gs://cloud-training/gcpnet/ilb/startup.sh
The startup-script-url specifies a script that is executed when instances are started. This script installs Apache and changes the welcome page to include the client IP and the name, region, and zone of the VM instance. You can explore this script here.

Click Networking.

For Network interfaces, specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Network	my-internal-app
Subnet	subnet-a
Network tags	backend-service
External IP	None
The network tag backend-service ensures that the firewall rule to allow traffic from any sources in the 10.10.0.0/16 subnet and the Health Check firewall rule applies to these instances.

Click Create. Wait for the instance template to be created.

Create another instance template for subnet-b by copying instance-template-1:

Select the instance-template-1 and click Copy.

Click Management, security, disks, networking, sole tenancy.

Click Networking.

For Network interfaces, select subnet-b as the Subnet.

Click Create.

Create the managed instance groups
Create a managed instance group in subnet-a (us-central1-a) and subnet-b (us-central1-b).

On the Navigation menu (Navigation menu), click Compute Engine > Instance groups.

Click Create Instance group.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	instance-group-1
Location	Single-zone
Region	us-central1
Zone	us-central1-a
Instance template	instance-template-1
Autoscaling metrics > metrics type (Click the pencil edit icon)	CPU utilization
Target CPU utilization	80
Cool-down period	45
Minimum number of instances	1
Maximum number of instances	5
Managed instance groups offer autoscaling capabilities that allow you to automatically add or remove instances from a managed instance group based on increases or decreases in load. Autoscaling helps your applications gracefully handle increases in traffic and reduces cost when the need for resources is lower. Just define the autoscaling policy, and the autoscaler performs automatic scaling based on the measured load.

Click Create.

Repeat the same procedure for instance-group-2 in us-central1-b:

Click Create Instance group.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	instance-group-2
Location	Single-zone
Region	us-central1
Zone	us-central1-b
Instance template	instance-template-2
Autoscaling metrics > metric type (Click the pencil edit icon)	CPU utilization
Target CPU utilization	80
Cool-down period	45
Minimum number of instances	1
Maximum number of instances	5
Click Create.

Verify the backends
Verify that VM instances are being created in both subnets and create a utility VM to access the backends' HTTP sites.

On the Navigation menu, click Compute Engine > VM instances. Notice two instances that start with instance-group-1 and instance-group-2.

These instances are in separate zones, and their internal IP addresses are part of the subnet-a and subnet-b CIDR blocks.

Click Create Instance.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	utility-vm
Region	us-central1
Zone	us-central1-f
Series	N1
Machine type	f1-micro (1 vCPU)
Boot disk	Debian GNU/Linux 10 (buster)
Click Management, security, disks, networking, sole tenancy.

Click Networking.

For Network interfaces, click the pencil icon to edit.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Network	my-internal-app
Subnetwork	subnet-a
Primary internal IP	Ephemeral (Custom)
Custom ephemeral IP address	10.10.20.50
External IP	None
Click Done.

Click Create.

Note that the internal IP addresses for the backends are 10.10.20.2 and 10.10.30.2.

If these IP addresses are different, replace them in the two curl commands below.

Click Check my progress to verify the objective.
Configure instance templates and create instance groups

For utility-vm, click SSH to launch a terminal and connect. If you see the Connection via Cloud Identity-Aware Proxy Failed popup, click Retry.

To verify the welcome page for instance-group-1-xxxx, run the following command:

curl 10.10.20.2
The output should look like this (do not copy; this is example output):

<h1>Internal Load Balancing Lab</h1><h2>Client IP</h2>Your IP address : 10.10.20.50<h2>Hostname</h2>Server Hostname:
 instance-group-1-1zn8<h2>Server Location</h2>Region and Zone: us-central1-a
To verify the welcome page for instance-group-2-xxxx, run the following command:

curl 10.10.30.2
The output should look like this (do not copy; this is example output):

<h1>Internal Load Balancing Lab</h1><h2>Client IP</h2>Your IP address : 10.10.20.50<h2>Hostname</h2>Server Hostname:
 instance-group-2-q5wp<h2>Server Location</h2>Region and Zone: us-central1-b
Which of these fields identify the location of the backend?

Client IP

Server Hostname

Server Location

This will be useful when verifying that the internal load balancer sends traffic to both backends.

Close the SSH terminal to utility-vm:

exit
Task 4. Configure the internal load balancer
Configure the internal load balancer to balance traffic between the two backends (instance-group-1 in us-central1-a and instance-group-2 in us-central1-b), as illustrated in the network diagram:

network_diagram.png

Start the configuration
In the Cloud Console, on the Navigation menu (Navigation menu), click Network Services > Load balancing.
Click Create load balancer.
Under TCP Load Balancing, click Start configuration.
For Internet facing or internal only, select Only between my VMs.
Choosing Only between my VMs makes this load balancer internal. This choice requires the backends to be in a single region (us-central1) and does not allow offloading TCP processing to the load balancer.

Click Continue.

For Name, type my-ilb.

Configure the regional backend service
The backend service monitors instance groups and prevents them from exceeding configured usage.

Click Backend configuration.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (select option as specified)
Region	us-central1
Network	my-internal-app
Instance group	instance-group-1 (us-central1-a)
Click Done.

Click Add backend.

For Instance group, select instance-group-2 (us-central1-b).

Click Done.

For Health Check, select Create a health check.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (select option as specified)
Name	my-ilb-health-check
Protocol	TCP
Port	80
Check interval	10 sec
Timeout	5 sec
Healthy threshold	2
Unhealthy threshold	3
Health checks determine which instances can receive new connections. This HTTP health check polls instances every 10 seconds, waits up to 5 seconds for a response, and treats 2 successful or 3 failed attempts as healthy threshold or unhealthy threshold, respectively.

Click Save and Continue.

Verify that there is a blue check mark next to Backend configuration in the Cloud Console. If there isn't, double-check that you have completed all the steps above.

Configure the frontend
The frontend forwards traffic to the backend.

Click Frontend configuration.

Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Subnetwork	subnet-b
Internal IP > IP address	Reserve static internal IP address
Specify the following, and leave the remaining settings as their defaults:

Property	Value (type value or select option as specified)
Name	my-ilb-ip
Static IP address	Let me choose
Custom IP address	10.10.30.5
Click Reserve.

For Ports, type 80.

Click Done.

Review and create the internal load balancer
Click Review and finalize.
Review the Backend and Frontend.
Click Create. Wait for the load balancer to be created before moving to the next task.
Click Check my progress to verify the objective.
Configure the Internal Load Balancer

Task 5. Test the internal load balancer
Verify that the my-ilb IP address forwards traffic to instance-group-1 in us-central1-a and instance-group-2 in us-central1-b.

Access the internal load balancer
On the Navigation menu, click Compute Engine > VM instances.

For utility-vm, click SSH to launch a terminal and connect.

To verify that the internal load balancer forwards traffic, run the following command:

curl 10.10.30.5
The output should look like this (do not copy; this is example output):

<h1>Internal Load Balancing Lab</h1><h2>Client IP</h2>Your IP address : 10.10.20.50<h2>Hostname</h2>Server Hostname:
 instance-group-2-1zn8<h2>Server Location</h2>Region and Zone: us-central1-b
As expected, traffic is forwarded from the internal load balancer (10.10.30.5) to the backend.

Run the same command a couple of times:

curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
curl 10.10.30.5
You should be able to see responses from instance-group-1 in us-central1-a and instance-group-2 in us-central1-b. If not, run the command again.

Task 6. Review
In this lab, you created two managed instance groups in the us-central1 region and a firewall rule to allow HTTP traffic to those instances and TCP traffic from the Google Cloud health checker. Then you configured and tested an internal load balancer for those instance groups.

End your lab
When you have completed your lab, click End Lab. Qwiklabs removes the resources you’ve used and cleans the account for you.

You will be given an opportunity to rate the lab experience. Select the applicable number of stars, type a comment, and then click Submit.

The number of stars indicates the following:

1 star = Very dissatisfied
2 stars = Dissatisfied
3 stars = Neutral
4 stars = Satisfied
5 stars = Very satisfied
You can close the dialog box if you don't want to provide feedback.

For feedback, suggestions, or corrections, please use the Support tab.

Copyright 2020 Google LLC All rights reserved. Google and the Google logo are trademarks of Google LLC. All other company and product names may be trademarks of the respective companies with which they are associated.

#################################################################################
# Lab 3 - Automating the Deployment of Infrastructure Using Deployment Manager
#################################################################################

Task 1. Configure the network
A configuration describes all the resources you want for a single deployment.

Verify that the Deployment Manager API is enabled
In the Cloud Console, on the Navigation menu (Navigation menu), click APIs & services > Library.

In the search bar, type Deployment Manager, and click the result for Google Cloud Deployment Manager V2 API.

Verify that the API is enabled.

Start the Cloud Shell Editor
To write the configuration and the template, you use the Cloud Shell Editor.

In the Cloud Console, click Activate Cloud Shell (Cloud Shell).

If prompted, click Continue.

Run the following commands:

mkdir dminfra
cd dminfra
In Cloud Shell, click Launch code editor (Cloud Shell Editor).

In the left pane of the code editor, expand the dminfra folder.

Create the auto mode network configuration
A configuration is a file written in YAML syntax that lists each of the resources you want to create and their respective resource properties. A configuration must contain a resources: section followed by the list of resources to create. Start the configuration with the mynetwork resource.

To create a new file, click File > New File.

Name the new file config.yaml, and then open it.

Copy the following base code into config.yaml:

resources:
# Create the auto-mode network
- name: [RESOURCE_NAME]
  type: [RESOURCE_TYPE]
  properties:
    #RESOURCE properties go here
Indentation is important in YAML.

True

False

This base configuration is a great starting point for any Google Cloud resource. The name field allows you to name the resource, and the type field allows you to specify the Google Cloud resource that you want to create. You can also define properties, but these are optional for some resources.

In config.yaml, replace [RESOURCE_NAME] with mynetwork

To get a list of all available network resource types in Google Cloud, run the following command in Cloud Shell:

gcloud deployment-manager types list | grep network
The output should look like this (do not copy; this is example output):

compute.beta.subnetwork
compute.alpha.subnetwork
compute.v1.subnetwork
compute.beta.network
compute.v1.network
compute.alpha.network
For a normal Deployment Manager configuration, which subnetwork resource type would you use? (assume these three options are available)

compute.v1.subnetwork

compute.alpha.subnetwork

compute.beta.subnetwork

Alternatively, you can find the full list of available resource types here.

Locate compute.v1.network, which is the type needed to create a VPC network using Deployment Manager.

In config.yaml, replace [RESOURCE_TYPE] with compute.v1.network

Add the following property to config.yaml:

autoCreateSubnetworks: true
By definition, an auto mode network automatically creates a subnetwork in each region. Therefore, you are setting autoCreateSubnetworks to true.

Verify that config.yaml looks like this, including the spacing/indentation:

resources:
# Create the auto-mode network
- name: mynetwork
  type: compute.v1.network
  properties:
    autoCreateSubnetworks: true
To save config.yaml, click File > Save.

Task 2. Configure the firewall rule
In order to allow ingress traffic instances in mynetwork, you need to create a firewall rule.

Add the firewall rule to the configuration
Add a firewall rule that allows HTTP, SSH, RDP, and ICMP traffic on mynetwork.

Copy the following base code into config.yaml (below the mynetwork resource):

# Create the firewall rule
- name: mynetwork-allow-http-ssh-rdp-icmp
  type: [RESOURCE_TYPE]
  properties:
    #RESOURCE properties go here
To get a list of all available firewall rule resource types in Google Cloud, run the following command in Cloud Shell:

gcloud deployment-manager types list | grep firewall
The output should look like this (do not copy; this is example output):

compute.v1.firewall
compute.alpha.firewall
compute.beta.firewall
Locate compute.v1.firewall, which is the type needed to create a firewall rule using Deployment Manager.

In config.yaml, replace [RESOURCE_TYPE] with compute.v1.firewall

In config.yaml, add the following properties for the firewall rule:

  network: $(ref.mynetwork.selfLink)
  sourceRanges: ["0.0.0.0/0"]
  allowed:
  - IPProtocol: TCP
    ports: [22, 80, 3389]
  - IPProtocol: ICMP
These properties define:

network: Network that the firewall rule applies to
sourceRange: Source IP ranges that traffic is allowed from
IPProtocol: Specific protocol that the rule applies to
ports: Specific ports of that protocol
Because firewall rules depend on their network, you are using the $(ref.mynetwork.selfLink) reference to instruct Deployment Manager to resolve these resources in a dependent order. Specifically, the network is created before the firewall rule. By default, Deployment Manager creates all resources in parallel, so there is no guarantee that dependent resources are created in the correct order unless you use references.

Verify that config.yaml looks like this, including the spacing/indentation:

resources:
# Create the auto-mode network
- name: mynetwork
  type: compute.v1.network
  properties:
    autoCreateSubnetworks: true

# Create the firewall rule
- name: mynetwork-allow-http-ssh-rdp-icmp
  type: compute.v1.firewall
  properties:
    network: $(ref.mynetwork.selfLink)
    sourceRanges: ["0.0.0.0/0"]
    allowed:
    - IPProtocol: TCP
      ports: [22, 80, 3389]
    - IPProtocol: ICMP
To save config.yaml, click File > Save.

Task 3. Create a template for VM instances
Deployment Manager allows you to use Python or Jinja2 templates to parameterize your configuration. This allows you to reuse common deployment paradigms such as networks, firewall rules, and VM instances.

Create the VM instance template
Because you will be creating two similar VM instances, create a VM instance template.

To create a new file, click File > New File.

Name the new file instance-template.jinja, and then open it.

Copy the following base code into instance-template.jinja:

resources:
- name: [RESOURCE_NAME]
  type: [RESOURCE_TYPE]
  properties:
    #RESOURCE properties go here
In instance-template.jinja, replace [RESOURCE_NAME] with {{ env["name"] }}. Make sure to include the double brackets {{}}.

This is an environment variable that will be provided by the configuration so that you can reuse the template for multiple instances.

To get a list of all available instance resource types in Google Cloud, run the following command in Cloud Shell:

gcloud deployment-manager types list | grep instance
The output should look like this (do not copy; this is example output):

...
compute.v1.instance
compute.alpha.instance
Locate compute.v1.instance, which is the type needed to create a VM instance using Deployment Manager.

In instance-template.jinja, replace [RESOURCE_TYPE] with compute.v1.instance

Specify the VM instance properties
To create a VM instance in the correct zone and network, you need to define these as properties.

In instance-template.jinja, add the following properties for the VM instance:

     machineType: zones/{{ properties["zone"] }}/machineTypes/{{ properties["machineType"] }}
     zone: {{ properties["zone"] }}
     networkInterfaces:
      - network: {{ properties["network"] }}
        subnetwork: {{ properties["subnetwork"] }}
        accessConfigs:
        - name: External NAT
          type: ONE_TO_ONE_NAT
     disks:
      - deviceName: {{ env["name"] }}
        type: PERSISTENT
        boot: true
        autoDelete: true
        initializeParams:
          sourceImage: https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/family/debian-9
These properties define:

machineType: Machine type and zone
zone: Instance zone
networkInterfaces: Network and subnetwork that VM is attached to
accessConfigs: Required to give the instance a public IP address (required in this lab). To create instances with only an internal IP address, remove the accessConfigs section.
disks: The boot disk, its name and image
Most properties are defined as template properties, which you will provide values for from the top-level configuration (config.yaml).

Verify that instance-template.jinja looks like this, including the spacing/indentation:

resources:
- name: {{ env["name"] }}
  type: compute.v1.instance  
  properties:
     machineType: zones/{{ properties["zone"] }}/machineTypes/{{ properties["machineType"] }}
     zone: {{ properties["zone"] }}
     networkInterfaces:
      - network: {{ properties["network"] }}
        subnetwork: {{ properties["subnetwork"] }}
        accessConfigs:
        - name: External NAT
          type: ONE_TO_ONE_NAT
     disks:
      - deviceName: {{ env["name"] }}
        type: PERSISTENT
        boot: true
        autoDelete: true
        initializeParams:
          sourceImage: https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/family/debian-9
To save instance-template.jinja, click File > Save.

Task 4. Deploy the configuration
Configure the instances and deploy the configuration.

Import the template
Templates are included in the *.yaml configuration using import:.

Copy the following into config.yaml (before resources):

imports:
- path: instance-template.jinja
The import statement defines the template that you want to use in your configuration. You can import multiple templates in one configuration. For example, you could create templates for the firewall rule and networks if you want to reuse those.

Configure VM instances in each network
Create the mynet-us-vm and mynet-eu-vm instances.

Add the mynet-us-vm instance to config.yaml (within the resources block):

# Create the mynet-us-vm instance
- name: mynet-us-vm
  type: instance-template.jinja
  properties:
    zone: us-central1-a
    machineType: n1-standard-1
    network: $(ref.mynetwork.selfLink)
    subnetwork: regions/us-central1/subnetworks/mynetwork
Add the mynet-eu-vm instance to config.yaml (within the resources block):

# Create the mynet-eu-vm instance
- name: mynet-eu-vm
  type: instance-template.jinja
  properties:
    zone: europe-west1-d
    machineType: n1-standard-1
    network: $(ref.mynetwork.selfLink)  
    subnetwork: regions/europe-west1/subnetworks/mynetwork
The zone, machineType, and subnetwork are passed from this configuration to the template. This allows you to create only one template for multiple VM instances. Also, references to the network are used for the VM instances. This ensures that the network is created before the VM that is attached to that network.

To save config.yaml, click File > Save.
If you want to use a different operating system or different operating system version, which property of the instance resource should you change?

type

deviceName

machineType

sourceImage

Deploy the configuration
It's time to deploy your configuration from Cloud Shell.

In Cloud Shell, run the following command:

gcloud deployment-manager deployments create dminfra --config=config.yaml --preview
The output should look like this (do not copy; this is example output):

NAME                               TYPE                 STATE      
mynet-eu-vm                        compute.v1.instance  IN_PREVIEW
mynet-us-vm                        compute.v1.instance  IN_PREVIEW
mynetwork                          compute.v1.network   IN_PREVIEW
mynetwork-allow-http-ssh-rdp-icmp  compute.v1.firewall  IN_PREVIEW
The --preview flag gives you a preview of how your configuration is applied before creating it. Previewing a configuration causes Deployment Manager to start creating your deployment but then stop before actually creating any resources. The --preview flag is especially useful when you update a deployment.

Run the following command to create the deployment:

gcloud deployment-manager deployments update dminfra
The update command commits the preview. If you don't preview a configuration, you can directly run the following command:

gcloud deployment-manager deployments create dminfra --config=config.yaml

Wait for the resources to be created and listed in Cloud Shell.

The output should look like this (do not copy; this is example output):

NAME                               TYPE                 STATE      ERRORS  INTENT
mynet-eu-vm                        compute.v1.instance  COMPLETED  []
mynet-us-vm                        compute.v1.instance  COMPLETED  []
mynetwork                          compute.v1.network   COMPLETED  []
mynetwork-allow-http-ssh-rdp-icmp  compute.v1.firewall  COMPLETED  []
If something goes wrong with the preview or creation of the deployment, try to use the error messages to troubleshoot the source of the issue. You must delete the Deployment Manager configuration before you can try deploying it again. This can be achieved with this command in Cloud Shell:

gcloud deployment-manager deployments delete dminfra

If you cannot troubleshoot the issue of your deployment, take a look at this finished configuration (config.yaml) and template (instance-template.jinja).

When Deployment Manager creates the resources, they are always created sequentually, one at a time.

True

False

Click Check my progress to verify the objective.

Create network, firewall rules and VM instances
Task 5. Verify your deployment
Verify your network in the Cloud Console
In the Cloud Console, on the Navigation menu (Navigation menu), click VPC network > VPC networks.

View the mynetwork VPC network with a subnetwork in every region.

On the Navigation menu, click VPC network > Firewall.

Sort the firewall rules by Network.

View the mynetwork-allow-http-ssh-rdp-icmp firewall rule for mynetwork.

Verify your VM instances in the Cloud Console
On the Navigation menu (Navigation menu), click Compute Engine > VM instances.

View the mynet-us-vm and mynet-eu-vm instances.

Note the internal IP address for mynet-eu-vm.

For mynet-us-vm, click SSH to launch a terminal and connect.

To test connectivity to mynet-eu-vm's internal IP address, run the following command in the SSH terminal (replacing mynet-eu-vm's internal IP address with the value noted earlier):

ping -c 3 <Enter mynet-eu-vm's internal IP here>
This should work because both VM instances are on the same network and the firewall rule allows ICMP traffic!

Task 6. Review
In this lab, you created a Deployment Manager configuration and template to automate the deployment of Google Cloud infrastructure. Templates can be very flexible because of their environment and template variables. Therefore, the benefit of creating templates is that they can be reused across many configurations.

Template variables are abstract properties that allow you to declare the value to be passed to the template in the *.yaml configuration file. You can change the value for each deployment in the *.yaml file without having to make changes to the underlying templates.

Environment variables allow you to reuse templates in different projects and deployments. Instead of representing properties of resources, they represent more global properties such as a Project ID or the name of the deployment. You can use the template that you created as a starting point for future deployments.

End your lab
When you have completed your lab, click End Lab. Qwiklabs removes the resources you’ve used and cleans the account for you.

You will be given an opportunity to rate the lab experience. Select the applicable number of stars, type a comment, and then click Submit.

The number of stars indicates the following:

1 star = Very dissatisfied
2 stars = Dissatisfied
3 stars = Neutral
4 stars = Satisfied
5 stars = Very satisfied
You can close the dialog box if you don't want to provide feedback.

For feedback, suggestions, or corrections, please use the Support tab.

Copyright 2020 Google LLC All rights reserved. Google and the Google logo are trademarks of Google LLC. All other company and product names may be trademarks of the respective companies with which they are associated.


#################################################################################
# Automating the Deployment of Infrastructure Using Terraform
#################################################################################
1 hour
Free
Overview
Terraform enables you to safely and predictably create, change, and improve infrastructure. It is an open-source tool that codifies APIs into declarative configuration files that can be shared among team members, treated as code, edited, reviewed, and versioned.

In this lab, you create a Terraform configuration with a module to automate the deployment of Google Cloud infrastructure. Specifically, you deploy one auto mode network with a firewall rule and two VM instances, as shown in this diagram:

diagram.png

Objectives
In this lab, you learn how to perform the following tasks:

Create a configuration for an auto mode network

Create a configuration for a firewall rule

Create a module for VM instances

Create and deploy a configuration

Verify the deployment of a configuration

Qwiklabs setup
For each lab, you get a new GCP project and set of resources for a fixed time at no cost.

Make sure you signed into Qwiklabs using an incognito window.

Note the lab's access time (for example, img/time.png and make sure you can finish in that time block.

There is no pause feature. You can restart if needed, but you have to start at the beginning.

When ready, click img/start_lab.png.

Note your lab credentials. You will use them to sign in to Cloud Platform Console. img/open_google_console.png

Click Open Google Console.

Click Use another account and copy/paste credentials for this lab into the prompts.

If you use other credentials, you'll get errors or incur charges.

Accept the terms and skip the recovery resource page.
Do not click End Lab unless you are finished with the lab or want to restart it. This clears your work and removes the project.

Task 1. Set up Terraform and Cloud Shell
Configure your Cloud Shell environment to use Terraform.

Install Terraform
Terraform is now integrated into Cloud Shell. Verify which version is installed.

In the Cloud Console, click Activate Cloud Shell (Cloud Shell).

If prompted, click Continue.

To confirm that Terraform is installed, run the following command:

terraform --version
The output should look like this (do not copy; this is example output):

Terraform v0.12.24
Don't worry if you get a warning that the version of Terraform is out of date, because the lab instructions will work with Terraform v0.12.2 and later. The available downloads for the latest version of Terraform are on the Terraform website. Terraform is distributed as a binary package for all supported platforms and architectures, and Cloud Shell uses Linux 64-bit.

To create a directory for your Terraform configuration, run the following command:

mkdir tfinfra
In Cloud Shell, click Open Editor (Cloud Shell Editor).
Note: If you see the message "Unable to load code editor because third-party cookies are disabled", click Open in New Window. The code editor will open in a new tab. Return to the original tab, click Open Terminal and then switch back to the code editor tab. You will periodically need to switch back to the Cloud Shell terminal in this lab.
In the left pane of the code editor, expand the tfinfra folder.

Initialize Terraform
Terraform uses a plugin-based architecture to support the numerous infrastructure and service providers available. Each "provider" is its own encapsulated binary distributed separately from Terraform itself. Initialize Terraform by setting Google as the provider.

To create a new file, click File > New File.

Name the new file provider.tf, and then open it.

Copy the code into provider.tf:

provider "google" {}
To initialize Terraform, run the following command:

cd tfinfra
terraform init
The output should look like this (do not copy; this is example output):

* provider.google: version = "~> 3.37"
Terraform has been successfully initialized!
You are now ready to work with Terraform in Cloud Shell.

Task 2. Create mynetwork and its resources
Create the auto mode network mynetwork along with its firewall rule and two VM instances (mynet_us_vm and mynet_eu_vm).

Configure mynetwork
Create a new configuration, and define mynetwork.

To create a new file, click File > New File.

Name the new file mynetwork.tf, and then open it.

Copy the following base code into mynetwork.tf:

# Create the mynetwork network
resource [RESOURCE_TYPE] "mynetwork" {
name = [RESOURCE_NAME]
#RESOURCE properties go here
}
This base template is a great starting point for any Google Cloud resource. The name field allows you to name the resource, and the type field allows you to specify the Google Cloud resource that you want to create. You can also define properties, but these are optional for some resources.

In mynetwork.tf, replace [RESOURCE_TYPE] with "google_compute_network" (with the quotes).
The google_compute_network resource is a VPC network. Available resources are in the Google Cloud provider documentation. For more information about this specific resource, see the Terraform documentation.

In mynetwork.tf, replace [RESOURCE_NAME] with "mynetwork" (with the quotes).

Add the following property to mynetwork.tf:

auto_create_subnetworks = "true"
By definition, an auto mode network automatically creates a subnetwork in each region. Therefore, you are setting auto_create_subnetworks to true.

Verify that mynetwork.tf looks like this:

# Create the mynetwork network
resource "google_compute_network" "mynetwork" {
name                    = "mynetwork"
auto_create_subnetworks = true
}
To save mynetwork.tf, click File > Save.

Configure the firewall rule
Define a firewall rule to allow HTTP, SSH, RDP, and ICMP traffic on mynetwork.

Add the following base code to mynetwork.tf:

# Add a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on mynetwork
resource [RESOURCE_TYPE] "mynetwork-allow-http-ssh-rdp-icmp" {
name = [RESOURCE_NAME]
#RESOURCE properties go here
}
In mynetwork.tf, replace [RESOURCE_TYPE] with "google_compute_firewall" (with the quotes).
The google_compute_firewall resource is a firewall rule. For more information about this specific resource, see the Terraform documentation.

In mynetwork.tf, replace [RESOURCE_NAME] with "mynetwork-allow-http-ssh-rdp-icmp" (with the quotes).

Add the following property to mynetwork.tf:

network = google_compute_network.mynetwork.self_link
Because this firewall rule depends on its network, you are using the google_compute_network.mynetwork.self_link reference to instruct Terraform to resolve these resources in a dependent order. In this case, the network is created before the firewall rule.

Add the following properties to mynetwork.tf:

allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
    }
allow {
    protocol = "icmp"
    }
The list of allow rules specifies which protocols and ports are permitted.

Verify that your additions to mynetwork.tf look like this:

# Add a firewall rule to allow HTTP, SSH, RDP, and ICMP traffic on mynetwork
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
name = "mynetwork-allow-http-ssh-rdp-icmp"
network = google_compute_network.mynetwork.self_link
allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
    }
allow {
    protocol = "icmp"
    }
}
To save mynetwork.tf, click File > Save.

Configure the VM instance
Define the VM instances by creating a VM instance module. A module is a reusable configuration inside a folder. You will use this module for both VM instances of this lab.

To create a new folder inside tfinfra, select the tfinfra folder, and then click File > New Folder.
Name the new folder instance.
To create a new file inside instance, select the instance folder, and then click File > New File.
Name the new file main.tf, and then open it.
You should have the following folder structure in Cloud Shell:

instance_folder.png

Copy the following base code into main.tf:

resource [RESOURCE_TYPE] "vm_instance" {
  name = [RESOURCE_NAME]
  #RESOURCE properties go here
}
In main.tf, replace [RESOURCE_TYPE] with "google_compute_instance" (with the quotes).
The google_compute_instance resource is a Compute Engine instance. For more information about this specific resource, see the Terraform documentation.

In main.tf, replace [RESOURCE_NAME] with "${var.instance_name}" (with the quotes).
Because you will be using this module for both VM instances, you are defining the instance name as an input variable. This allows you to control the name of the variable from mynetwork.tf. For more information about input variables, see this guide.

Add the following properties to main.tf:

  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
These properties define the zone and machine type of the instance as input variables.

Add the following properties to main.tf:

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      }
  }
This property defines the boot disk to use the Debian 9 OS image. Because both VM instances will use the same image, you can hard-code this property in the module.

Add the following properties to main.tf:

  network_interface {
    network = "${var.instance_network}"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
This property defines the network interface by providing the network name as an input variable and the access configuration. Leaving the access configuration empty results in an ephemeral external IP address (required in this lab). To create instances with only an internal IP address, remove the access_config section. For more information, see the Terraform documentation.

Define the 4 input variables at the top of main.tf, and verify that main.tf looks like this, including brackets {}:

variable "instance_name" {}
variable "instance_zone" {}
variable "instance_type" {
  default = "n1-standard-1"
  }
variable "instance_network" {}

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}"
  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      }
  }
  network_interface {
    network = "${var.instance_network}"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
}
By giving instance_type a default value, you make the variable optional. The instance_name, instance_zone, and instance_network are required, and you will define them in mynetwork.tf.

To save main.tf, click File > Save.

Add the following VM instances to mynetwork.tf:

# Create the mynet-us-vm instance
module "mynet-us-vm" {
  source           = "./instance"
  instance_name    = "mynet-us-vm"
  instance_zone    = "us-central1-a"
  instance_network = google_compute_network.mynetwork.self_link
}

# Create the mynet-eu-vm" instance
module "mynet-eu-vm" {
  source           = "./instance"
  instance_name    = "mynet-eu-vm"
  instance_zone    = "europe-west1-d"
  instance_network = google_compute_network.mynetwork.self_link
}
These resources are leveraging the module in the instance folder and provide the name, zone, and network as inputs. Because these instances depend on a VPC network, you are using the google_compute_network.mynetwork.self_link reference to instruct Terraform to resolve these resources in a dependent order. In this case, the network is created before the instance.

The benefit of writing a Terraform module is that it can be reused across many configurations. Instead of writing your own module, you can also leverage existing modules from the Terraform Module registry.

To save mynetwork.tf, click File > Save.

Create mynetwork and its resources
It's time to apply the mynetwork configuration.

To rewrite the Terraform configuration files to a canonical format and style, run the following command:

terraform fmt
The output should look like this (do not copy; this is example output):

mynetwork.tf
If you get an error, revisit the previous steps to ensure that your configuration matches the lab instructions. If you cannot troubleshoot the issue of your configuration, look at these finished configurations:

mynetwork.tf
main.tf
provider.tf
To initialize Terraform, run the following command:

terraform init
The output should look like this (do not copy; this is example output):

Initializing modules...
- mynet-eu-vm in instance
- mynet-us-vm in instance
...
* provider.google: version = "~> 3.37"

Terraform has been successfully initialized!
If you get an error, revisit the previous steps to ensure that you have the correct folder/file structure. If you cannot troubleshoot the issue of your configuration, refer to the finished configurations linked above. When you have corrected the issue, re-run the previous command.

To create an execution plan, run the following command:

terraform plan
The output should look like this (do not copy; this is example output):

...
Plan: 4 to add, 0 to change, 0 to destroy.
...
Terraform determined that the following 4 resources need to be added:

Name	Description
mynetwork	VPC network
mynetwork-allow-http-ssh-rdp-icmp	Firewall rule to allow HTTP, SSH, RDP and ICMP
mynet-us-vm	VM instance in us-central1-a
mynet-eu-vm	VM instance in europe-west1-d
To apply the desired changes, run the following command:

terraform apply
To confirm the planned actions, type:

yes
The output should look like this (do not copy; this is example output):

...
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
Click Check my progress to verify the objective.
Create mynetwork and its resources

If you get an error during the execution, revisit the previous steps to ensure that you have the correct folder/file structure. If you cannot troubleshoot the issue of your configuration, refer to the finished configurations linked above. When you have corrected the issue, re-run the previous command.

Task 3. Verify your deployment
In the Cloud Console, verify that the resources were created.

Verify your network in the Cloud Console
In the Cloud Console, on the Navigation menu (Navigation menu), click VPC network > VPC networks.

View the mynetwork VPC network with a subnetwork in every region.

On the Navigation menu, click VPC network > Firewall.

Sort the firewall rules by Network.

View the mynetwork-allow-http-ssh-rdp-icmp firewall rule for mynetwork.

Verify your VM instances in the Cloud Console
On the Navigation menu (Navigation menu), click Compute Engine > VM instances.

View the mynet-us-vm and mynet-eu-vm instances.

Note the internal IP address for mynet-eu-vm.

For mynet-us-vm, click SSH to launch a terminal and connect.

To test connectivity to mynet-eu-vm's internal IP address, run the following command in the SSH terminal (replacing mynet-eu-vm's internal IP address with the value noted earlier):

ping -c 3 <Enter mynet-eu-vm's internal IP here>
This should work because both VM instances are on the same network, and the firewall rule allows ICMP traffic!

Task 4. Review
In this lab, you created a Terraform configuration with a module to automate the deployment of Google Cloud infrastructure. As your configuration changes, Terraform can create incremental execution plans, which allows you to build your overall configuration step by step.

The instance module allowed you to re-use the same resource configuration for multiple resources while providing properties as input variables. You can leverage the configuration and module that you created as a starting point for future deployments.

End your lab
When you have completed your lab, click End Lab. Qwiklabs removes the resources you’ve used and cleans the account for you.

You will be given an opportunity to rate the lab experience. Select the applicable number of stars, type a comment, and then click Submit.

The number of stars indicates the following:

1 star = Very dissatisfied
2 stars = Dissatisfied
3 stars = Neutral
4 stars = Satisfied
5 stars = Very satisfied
You can close the dialog box if you don't want to provide feedback.

For feedback, suggestions, or corrections, please use the Support tab.

Copyright 2020 Google LLC All rights reserved. Google and the Google logo are trademarks of Google LLC. All other company and product names may be trademarks of the respective companies with which they are associated.

#################################################################################

First we create a web server. In the GCP Console's
Products and Services menu, I scroll down to
Compute Engine, and choose VM instances. I'll create an instance. I'll name the instance:
bloghost. And I'll leave it in the
offered zone us-central1-a. I'll take the other defaults. And I'll configure the firewall
to allow HTTP traffic in. I also want to add
a startup script. This startup script
will install a web server. I click Create, and the Virtual Machine instance
is created for me. Notice its external IP address.
We'll need that later. Now I'm going to make
a Cloud Storage bucket using Cloud Shell. I enter the command:
gsutil mb -l then I name the location in which I want
the bucket to reside. In this case,
the US Multi-Region. The name of my Cloud Storage
bucket must be globally unique, and the easiest way
to make sure of this is to name the bucket
after my GCP Project ID, which is also globally unique. In the Cloud Shell,
the environment variable $DEVSHELL_PROJECT_ID
always contains my project ID. Now I've created my bucket. I'm going to copy a graphical image from another Cloud Storage bucket, this one called: cloud-training. Now I have the graphical image
here in my directory, my-excellent-blog.png. Now I use the gsutil cp command again to upload it to
my own Cloud Storage bucket. I can see the resulting file, both from the command line
using: gsutil ls... ...and also from the
GCP Console's Storage Browser. There's my bucket, and there's the object
I created in the bucket. Recall that my VM instance
is in zone us-central1-a. Now we'll create
a Cloud SQL instance in the same zone. In the Products and Services menu, we scroll down to SQL. We choose MySQL
for our database engine, Second Generation. We name our instance "blog-db" and we define a root password. We'll place this instance
in the same zone as our Compute instance. When the database instance has been made, we click on its name
to configure it. With my database instance
finished provisioning, I can click on its name
to configure it. I want to create a MySQL
username called: blogdbuser. I'll define a password. Now I want to configure
this database instance so that it can be only contacted from
my Virtual Machine instance. So I need to go back
to its entry in the VM instance's listing and
capture its public IP address. There it is. We'll copy it. We return to our SQL instance, click on our instance name, and click Authorization. We wish to authorize
a network consisting only of the desired VM instance. We'll name the network:
web front end and insert the IP address
of that instance followed by /32. Now our database instance
is protected from broad internet access. Now I'm going to return
to my Virtual Machine and configure it to use
the resources we've set up. I'll log into it using SSH. I'm going to edit
its PHP homepage. I've prepared a page
that I can paste in. I'll fill in my database's
IP address and password. Notice the comment. In a real blog, we would never
store the MySQL password anywhere in the document root. Instead, we would store it
in a separate configuration file somewhere else in the
web server Virtual Machine. Now let's try it. We'll restart
the web server daemon. Now we'll return to the
GCP Console's VM instances list and attempt to
view the homepage. Our database connection
succeeded. If this were a real blog,
we would now begin to load blog content
into our SQL database. Now let's enhance our homepage by adding our
graphical image to it. In the GCP Console, we'll
navigate to the Storage Browser and create a public link
to our graphical image. There's the image. We check the box:
Share publicly. That gives us a hyperlink
that we can clone. Now we return
to our PHP homepage and add in an HTML reference
to that image. Now let's return to our
PHP homepage and refresh it. Our page now contains an image
hosted in Google Cloud Storage.


##############################################################################
# CURSO 6 - Getting Started with Google Kubernetes Engine
##############################################################################


Getting Started with Google Kubernetes Engine
