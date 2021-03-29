#################################################################################
#################################################################################
# Curso 7 - Getting Started with Google Kubernetes Engine
#################################################################################
#################################################################################

# Introduction

## cloud Computing

GCP
    On demand resources
    Acessible over network
    Resource pooling
    Rapid Elasticity
    Pay as you Google 

    CE - Compute Engine
    GKE - Google Kubernetes Engine
    App Engine
    Cloud Functions

# Basic commands

      gclouod containers clusters get-credentials <cluster> --zone <zone>
      kubectl get pod
      kubectl config view
      kubectl <command> 	<type> 		<name> 		<flags>
        get	  	pods  		teste 		-o=yaml
        describe   	service 	front		-o=wide

# Deployments

Manifest yaml file

apiVersion: app
Kind: Deployment
metadada:
	name

States

	Progressing
	Complete
	Failed

Manifest file

kubectl apply -f <file>

kubectl run

console 
kubectl get deployment <name>
kubectl describe deployment <name>

# Services and scalling

kubectl autoscale deployment --min=2 --max=3 --cpu-percent

# Update deployments

Apply yaml file
kubectl set image deploymnent
kubectl edit deploymnent
console

Blue-green deploymnent
  Update service
    Apply 
    patch service (version)

Canary deploymnent
    Service without version 

Network
Volumes
PVCs Claims

gcloud compute disk create pdname
gcepersistentdisk

AB test
Shadow Test
Session afinity

kubectl rollout undo deploymen
kubectl rollout undo deployment to
kubectl rollout history deployments

kubectl rollout pause deploymen
kubectl rollout resume deploymen
kubectl rollout status deploymen
kubectl rollout delete deploymen

#################################################################################
# Services
#################################################################################

## GCP - Resourecs , distribution and project

Billing - Tags

## GCP Administration

Console
Cloud SDK
Cloud Shell
Cloud Mobile App

Containers

Hardware
Virtualization
Containers

## Cloud Build

#################################################################################
# Lab 1 - Managing GCP
#################################################################################

    Storage
    VM
    Service Account 
    
MY_BUCKET_NAME_1=qwiklabs-gcp-01-96036a27c47a
MY_BUCKET_NAME_2=qwiklabs-gcp-01-96036a27c47a2
MY_REGION=us-central1

gcloud config set project qwiklabs-gcp-02-e15eb500d0d1

gsutil mb gs://$MY_BUCKET_NAME_2
gcloud compute zones list | grep $MY_REGION

MY_ZONE=us-central1-c
gcloud config set compute/zone $MY_ZONE

MY_VMNAME=second-vm
gcloud compute instances create $MY_VMNAME \
--machine-type "e2-standard-2" \
--image-project "debian-cloud" \
--image-family "debian-9" \
--subnet "default"

gcloud compute instances list

- Create a service account

gcloud iam service-accounts create test-service-account2 --display-name "test-service-account2"


- In Cloud Shell, execute the following command to grant the second service account the Project viewer role:

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member serviceAccount:test-service-account2@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role roles/viewer

gsutil cp gs://cloud-training/ak8s/cat.jpg cat.jpg

gsutil cp cat.jpg gs://$MY_BUCKET_NAME_1

gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg gs://$MY_BUCKET_NAME_2/cat.jpg
gsutil acl get gs://$MY_BUCKET_NAME_1/cat.jpg  > acl.txt
cat acl.txt

gsutil acl set private gs://$MY_BUCKET_NAME_1/cat.jpg

gsutil acl get gs://$MY_BUCKET_NAME_1/cat.jpg  > acl-2.txt
cat acl-2.txt

gcloud config list

gcloud auth activate-service-account --key-file credentials.json

gcloud auth list

gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg ./cat-copy.jpg

gsutil cp gs://$MY_BUCKET_NAME_2/cat.jpg ./cat-copy.jpg

gcloud config set account student-01-df526dd86ed8@qwiklabs.net

gsutil iam ch allUsers:objectViewer gs://$MY_BUCKET_NAME_1

Open the Cloud Shell code editor

git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git

cd orchestrate-with-kubernetes
cat cleanup.sh

Index.html


<html><head><title>Cat</title></head>
<body>
<h1>Cat</h1>
<img src="https://storage.googleapis.com/leoym/cat.jpg">
</body></html>

sudo apt-get update
sudo apt-get install nginx

gcloud compute scp index.html first-vm:index.nginx-debian.html --zone=us-central1-a

#################################################################################
# Lab 2 - Cloud Build
#################################################################################

Working with Cloud Build

Task 1: Confirm that needed APIs are enabled

Task 2. Building Containers with DockerFile and Cloud Build

nano quickstart.sh

#!/bin/sh
echo "Hello, world! The time is $(date)."

nano Dockerfile

FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]

chmod +x quickstart.sh

Build

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .

Task 3. Building Containers with a build configuration file and Cloud Build

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cat cloudbuild.yaml

gcloud builds submit --config cloudbuild.yaml .

Task 4. Building and Testing Containers with a build configuration file and Cloud Build

cd ~/ak8s/Cloud_Build/b

gcloud builds submit --config cloudbuild.yaml .


echo $?


#################################################################################
# Lab 3 - Deploying Google Kubernetes Engine
#################################################################################
# GKE 

Deploying Google Kubernetes Engine
Task 1. Deploy GKE clusters

Task 2. Modify GKE clusters

Task 3. Deploy a sample workload

Task 4. View details about workloads in the Google Cloud Console


#################################################################################
# Lab 4 - Configuring Persistent Storage for Google Kubernetes Engine
#################################################################################

gcloud auth list

gcloud config list project

Task 1. Create PVs and PVCs

export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone

pvc-demo.yaml


apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hello-web-disk
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 30Gi

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/Storage/

kubectl get persistentvolumeclaim

kubectl apply -f pvc-demo.yaml

kubectl get persistentvolumeclaim


pod-volume-demo.yaml

kind: Pod
apiVersion: v1
metadata:
  name: pvc-demo-pod
spec:
  containers:
    - name: frontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: pvc-demo-volume
  volumes:
    - name: pvc-demo-volume
      persistentVolumeClaim:
        claimName: hello-web-disk


Task 2. Mount and verify Google Cloud persistent disk PVCs in Pods


kubectl apply -f pod-volume-demo.yaml

kubectl get pods

kubectl exec -it pvc-demo-pod -- sh

echo Test webpage in a persistent volume!>/var/www/html/index.html
chmod +x /var/www/html/index.html


kubectl delete pod pvc-demo-pod
kubectl get pods
kubectl get persistentvolumeclaim

kubectl apply -f pod-volume-demo.yaml

kubectl exec -it pvc-demo-pod -- sh

Task 3. Create StatefulSets with PVCs


kubectl delete pod pvc-demo-pod

kubectl get pods

kubectl apply -f statefulset-demo.yaml

kubectl describe statefulset statefulset-demo

kubectl get pvc

kubectl describe pvc hello-web-disk-statefulset-demo-0

Task 4. Verify the persistence of Persistent Volume connections to Pods managed by StatefulSets

kubectl exec -it statefulset-demo-0 -- sh

cat /var/www/html/index.html

echo Test webpage in a persistent volume!>/var/www/html/index.html
chmod +x /var/www/html/index.html

exit
Test webpage in a persistent volume!

kubectl delete pod statefulset-demo-0

kubectl exec -it statefulset-demo-0 -- sh

cat /var/www/html/index.html


#################################################################################
#################################################################################
# Curso 8 - # Developing a Google SRE Culture
#################################################################################
#################################################################################

Overview

  Site Reliabilty Engineering
    Principles
    Technical

  DevOps phylosoph
    Value to It
    Identify

7 modules:

# Introduction

Module 1) The first module is the course introduction and structure, 
    which I'm covering right now. 

Module 2)  DevOps, SRE and Why they exist - In the second module, DevOps, SRE, and why they exist, 
    you'll be introduced to DevOps philosophy and how SRE practices emerged. 

 In this module, you'll learn about the practice of DevOps, 
 why Site Reliability Engineering, or 
 SRE was developed, and who in an organization can and should apply these practices. 

 What is DevOps and SRE

 DevOps philosophy

Reduce silos
Failure is normal
Gradual Changes 
automation
Measure everything

SRE
Engineers

Technical Culturaal
Share Onwerhsip - Comunicat
 Blameless
 Reduces costs of failures
 Toil automation 
 Mesure  reliable

# Role + practice

Modules 3-5 will cover the journey to SRE. 

Module 3) SLO with consequences - In module 3, SLOs with Consequences. You'll learn about the SRE concepts of service level objectives, error budgets, blamelessness, and psychological safety. 

the first step is to develop service level objectives or SLOs with consequences
The value of SRE to your organization
. The mission of SRE is to protect, provide for, and progress software and systems with consistent focus on availability, latency, performance, and capacity

Accept failure as normal with blameless postmortems

Blamelessness and Psychological Safety
Reduce organizational silos with SLOs and Error Budgets
Unify vision, foster collaboration and communications, and share knowledg

Team is important

4) Module 4, Make Tomorrow Better Than Today, will cover the concepts of toil monitoring, implementing gradual change, and the impact automation has on IT teams. 

- Continuous integration, continuous delivery, and canarying
- Design thinking and prototyping
- Toil automation
- Psychology of change and resistance to change


5) Module 5 - Regulate Workload - The fifth module, Regulate Workload, covers topics around measurement and SRE practices related to measuring toil and reliability. 

# Applyng SRE

Once you've learned about the key SRE technical and cultural fundamentals, 

- Measure everything by quantifying toil and reliability
- Goal setting, transparency, and data-based decision-making


6) the sixth module, Apply SRE in Your Organization 
    will discuss steps to begin SRE implementation in your organization. 

    Organizational maturity for SRE
SRE skills and training
SRE team implementations
Getting started with Google and SRE


7) Finally, the last module contains a summative graded assessment 
    to evaluate the knowledge you've acquired throughout the course.



#################################################################################
#################################################################################
# curso 8 - # Reliable Google Cloud Infrastructure: Design and Process
#################################################################################
#################################################################################

# Introduction
  Activity Intro: Defining your case study
  Activity Review: Defining your case study

# Defining Services
  Requirements Analysis, and Design
  Activity 6 Intro: Analyzing your case study
  Activity Review: Analyzing your case study
  KPIs and SLIs
  SLOs and SLAs
  Activity 7 Intro: Defining SLIs and SLOs
  Activity Review: Defining SLIs and SLOs
  
# Microservices Design and Architecture
  Microservices
  Microservices Best Practices
  Activity Intro: Designing microservices for your application
  Activity Review: Designing microservices for your application
  Rest 
  HTTP
  APIs
  Activity 8 Intro: Designing REST APIs
  Activity Intro: Designing REST APIs


# DevOps automation
  Continuous Integration Pipelines
  Infrastructure as Code

# Chosing Storage Solutions
  Key Storage Characteristics
  Activity Intro: Defining storage characteristics
  Activity Review: Defining storage characteristics
  Choosing Google Cloud Storage and Data Solutions
  Activity 9 Intro: Choosing Google Cloud storage and data services
  Activity Review: Choosing Google Cloud storage and data services

# Google Cloud and Hybrid Network Architecture 
  Designing Google Cloud Networks
  Designing Google Cloud load balancers
  Activity Intro: Defining network characteristics
  Activity Review: Defining network characteristics
  Connecting Networks
  Activity 10 Intro: Diagramming your network
  Activity Review: Diagramming your network

# Deploying Applications do Google  Cloud 
  Google Cloud Infrastructure as a Service
  Google Cloud Deployment Platforms

# Designing reliable systems
  Key Performance Metrics
  Designing for Reliability
  Activity Intro: Designing Reliable Scalable Applications
  Activity Review: Designing Reliable Scalable Applications
  Disaster Planning
  Activity 11 Intro: Disaster planning
  Activity 11 Review: Disaster planning

# Security 
  Security Concepts
  Securing People
  Securing Machine Access
  Network Security
  Encryption
  Activity Intro: Modeling Secure Google Cloud Services
  Activity 12 Review: Modeling Secure Google Cloud Services

# Maintenance and monitoring  
  Managing Versions
  Cost Planning
  Monitoring Dashboards
  Activity 13 Intro: Cost estimating and planning
  Activity Review: Cost estimating and planning

##############################################################################

LAB 1 - Building a DevOps Pipeline

Task 1: Create a Git Repository

In the Cloud Console, on the Navigation menu, click Source Repositories. A new tab will open.

Click Add repository.

Select Create new repository and click Continue.

Name the repository devops-repo


Select your current project ID from the list.

Click Create.


mkdir gcp-course

cd gcp-course

gcloud source repos clone devops-repo

Task 2: Create a Simple Python Application

Create a file
main.py

from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/")
def main():
    model = {"title": "Hello DevOps Fans."}
    return render_template('index.html', model=model)


mkdir templates


cd templates

vi layout.html

<!doctype html>
<html lang="en">
<head>
    <title>{{model.title}}</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

</head>
<body>
    <div class="container">

        {% block content %}{% endblock %}

        <footer></footer>
    </div>
</body>
</html>


 requirements.txt


Flask==1.1.1

cd ~/gcp-course/devops-repo
git add --all

git config --global user.email "student-02-75c1db3f7c0c@qwiklabs.net"
git config --global user.name "Leo"
git commit -a -m "Initial Commit"

Task 3: Test Your Web Application in Cloud Shell

cd ~/gcp-course/devops-repo
sudo pip3 install -r requirements.txt

python3 main.py

Task 4: Define a Docker Build

vi Dockerfile

FROM python:3.7
WORKDIR /app
COPY . .
RUN pip install gunicorn
RUN pip install -r requirements.txt
ENV PORT=80
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 main:app



Task 5: Manage Docker Images with Cloud Build and Container Registry

echo $DEVSHELL_PROJECT_ID

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/devops-image:v0.1 .


git add --all

git commit -am "Added Docker Support"

git push origin master

Task 6: Automate Builds with Triggers

Create a trigger


cd ~/gcp-course/devops-repo
git commit -a -m "Testing Build Trigger"
git push origin master

Return to the Cloud Console and the Cloud Build service. You should see another build running.

create a new machine
##############################################################################
LAB 2 - Deploying Apps to Google Cloud

Task 1: Download a sample app from GitHub

create dir
mkdir gcp-course
Change to the folder you just created:
cd gcp-course

git clone https://GitHub.com/GoogleCloudPlatform/training-data-analyst.git


cd training-data-analyst/courses/design-process/deploying-apps-to-gcp


sudo pip3 install -r requirements.txt
python3 main.py

Task 2: Deploy to App Engine

app.yaml

runtime: python37

gcloud app create --region=us-central

gcloud app deploy --version=one --quiet

gcloud app deploy --version=two --no-promote --quiet


Split

Task 3: Deploy to Kubernetes Engine


kubernetes-config.yaml

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-deployment
  labels:
    app: devops
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: devops
      tier: frontend
  template:
    metadata:
      labels:
        app: devops
        tier: frontend
    spec:
      containers:
      - name: devops-demo
        image: gcr.io/qwiklabs-gcp-04-8ca1d6d4e70f/devops-image:v0.2
        ports:
        - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: devops-deployment-lb
  labels:
    app: devops
    tier: frontend-lb
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: devops
    tier: frontend



kubectl apply -f kubernetes-config.yaml

kubectl get pods

kubectl get services




Task 4: Deploy to Cloud Run



Hello Cloud Run
cd ~/gcp-course/training-data-analyst/courses/design-process/deploying-apps-to-gcp
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/cloud-run-image:v0.1 .

Click Create service.

Accept the defaults in the Deployment platform section.

Give any name to the service and select the Allow unauthenticated invocations option.

Click Next.

Click the Select link in the Container image URL text box. In the resulting dialog, expand cloud-run-image and select the image listed. Then click Continue.

Finally, click Create.



##############################################################################
LAB 3 - Monitoring Applications in Google Cloud

Task 1: Download a sample app from Github

mkdir gcp-logging
cd gcp-logging
git clone https://GitHub.com/GoogleCloudPlatform/training-data-analyst.git
cd training-data-analyst/courses/design-process/deploying-apps-to-gcp

Edit:
 gcp-logging/training-data-analyst/courses/design-process/deploying-apps-to-gcp folder in the navigation pane, and then click main.py


import googlecloudprofiler

try:
    googlecloudprofiler.start(verbose=3)
except (ValueError, NotImplementedError) as exc:
    print(exc)


Requirements.txt


    google-cloud-profiler


gcloud services enable cloudprofiler.googleapis.com

sudo pip3 install -r requirements.txt
python3 main.py


Task 2: Deploy an application to App Engine

app.yaml

runtime: python37


gcloud app create --region=us-central

gcloud app deploy --version=one --quiet

You can stream logs from the command line by running:
  $ gcloud app logs tail -s default

To view your application in the web browser run:
  $ gcloud app browse


Task 3: Examine the Cloud logs

Return to the Console and click the App Engine > Versions link on the left.
Click Tools in the Diagnose column of the table, and then click Logs.
The logs should indicate that Profiler has started and profiles are being generated. If you get to this point too quickly, wait a minute and click Refresh.



Task 4: View Profiler information

In the Cloud Console, on the Navigation menu (Navigation menu), click Profiler. The screen should look similar to this:


Create to create a virtual machine.

us-east-1

sudo apt update
sudo apt install apache2-utils -y

ab -n 1000 -c 10 https://qwiklabs-gcp-03-a0accc288b5a.uc.r.appspot.com/

Task 5: Explore Cloud Trace

Every request to your application is added to the Trace list. On the Navigation menu (Navigation menu), click Trace.
The overview screen shows recent requests and allows you to create reports to analyze traffic. Because your program is new and has only one page, it's not very interesting, but in a real app there would be lots of useful information.

Click Trace list.

Task 6: Monitor resources using Dashboards

In the Cloud Console, on the Navigation menu (Navigation menu), click Monitoring.
In the left pane, click Dashboards.

Task 7: Create uptime checks and alerts

