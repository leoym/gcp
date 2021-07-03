# Working with GKE - Google Kubernetes Engine - Lab

----

## Lab 01 - GCP Basics

## Creating a bucket using Web Console and gsutil

    MY_BUCKET_1=lymlab-bucket_01
    MY_BUCKET_2=lymlab-bucket_02
    
    gsutil mb gs://$MY_BUCKET_1 
    gsutil mb gs://$MY_BUCKET_2
    
    gsutil ls gs://$MY_BUCKET_1
    gsutil ls gs://$MY_BUCKET_2
    
## Creating a VM using gcloud

    MY_REGION=us-central1
    MY_ZONE=us-central1-a
    MY_VMNAME=web-vm-01

    gcloud compute instances create $MY_VMNAME \
    --machine-type "f1-micro" \
    --image-project "debian-cloud" \
    --image-family "debian-10" \
    --subnet "default" --zone $MY_ZONE

    gcloud compute instances list    
    
    gcloud compute ssh web-vm-01

## Creating a service account

    gcloud iam service-accounts create test-service-account2 --display-name "test-service-account2"

    gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member serviceAccount:test-service-account2@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role roles/viewer

## Working with buckets

    gsutil cp gs://cloud-training/ak8s/cat.jpg cat.jpg
    gsutil cp cat.jpg gs://$MY_BUCKET_1
    gsutil cp gs://$MY_BUCKET_1/cat.jpg gs://$MY_BUCKET_2/cat.jpg
    gsutil acl set private gs://$MY_BUCKET_1/cat.jpg
    gsutil acl get gs://$MY_BUCKET_1/cat.jpg  > acl-2.txt
    cat acl-2.txt
    gsutil acl set private gs://$MY_BUCKET_1/cat.jpg
    gsutil acl get gs://$MY_BUCKET_1/cat.jpg  > acl-2.txt
    cat acl-2.txt

## Config

    gcloud config list
    gcloud auth activate-service-account --key-file credentials.json
    gcloud config list
    
    gsutil cp gs://$MY_BUCKET_1/cat.jpg ./cat-copy.jpg
    gsutil cp gs://$MY_BUCKET_2/cat.jpg ./cat-copy.jpg

    gcloud config set account user test-service-account2
    gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg ./copy2-of-cat.jpg
    gsutil iam ch allUsers:objectViewer gs://$MY_BUCKET_1
    gsutil iam ch allUsers:objectViewer gs://$MY_BUCKET_1

## Cloud Shell

    git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
    mkdir test
    cd orchestrate-with-kubernetes
    cat cleanup.sh

## Working with Editor

index.html

<html><head><title>Cat</title></head>
<body>
<h1>Cat</h1>
<img src="https://raw.githubusercontent.com/leoym/Cloud-Infra/main/gituser.png">
</body></html>

## Working with VM Instance

    gcloud compute scp index.html first-vm:index.nginx-debian.html --zone=us-central1-c

    gcloud compute ssh web-vm-01

    sudo apt-get update
    sudo apt-get install nginx
    sudo systemctl start nginx
    sudo cp index.nginx-debian.html /var/www/html

    mkdir test

----
# Lab 02

## 1 - Enable API 

  Cloud Build

  Container Registry

## 2 - Build 
    nano quickstart.sh

    #!/bin/sh
    echo "Hello, world! The time is $(date)."

    nano Dockerfile

    FROM alpine
    COPY quickstart.sh /
    CMD ["/quickstart.sh"]

    chmod +x quickstart.sh

    gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .

    Verifiy image in registry

## 3 - 

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/Cloud_Build/a

cat cloudbuild.yaml

gcloud builds submit --config cloudbuild.yaml .

## 4 

cd ~/ak8s/Cloud_Build/b
cat cloudbuild.yaml

gcloud builds submit --config cloudbuild.yaml .
echo $?


----

# Lab 03 

## Creating a standard cluster

gcloud beta container --project "prj-lym-dev" clusters create "cluster-lm" --zone "us-central1-c" --no-enable-basic-auth --cluster-version "1.19.9-gke.1900" --release-channel "regular" --machine-type "e2-micro" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "2" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/prj-lym-dev/global/networks/default" --subnetwork "projects/prj-lym-dev/regions/us-central1/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "us-central1-c"


POST https://container.googleapis.com/v1beta1/projects/prj-lym-dev/zones/us-central1-c/clusters
{
  "cluster": {
    "name": "cluster-lm",
    "masterAuth": {
      "clientCertificateConfig": {}
    },
    "network": "projects/prj-lym-dev/global/networks/default",
    "addonsConfig": {
      "httpLoadBalancing": {},
      "horizontalPodAutoscaling": {},
      "kubernetesDashboard": {
        "disabled": true
      },
      "dnsCacheConfig": {},
      "gcePersistentDiskCsiDriverConfig": {
        "enabled": true
      }
    },
    "subnetwork": "projects/prj-lym-dev/regions/us-central1/subnetworks/default",
    "nodePools": [
      {
        "name": "default-pool",
        "config": {
          "machineType": "e2-micro",
          "diskSizeGb": 100,
          "oauthScopes": [
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/servicecontrol",
            "https://www.googleapis.com/auth/service.management.readonly",
            "https://www.googleapis.com/auth/trace.append"
          ],
          "metadata": {
            "disable-legacy-endpoints": "true"
          },
          "imageType": "COS_CONTAINERD",
          "diskType": "pd-standard",
          "shieldedInstanceConfig": {
            "enableIntegrityMonitoring": true
          }
        },
        "initialNodeCount": 2,
        "autoscaling": {},
        "management": {
          "autoUpgrade": true,
          "autoRepair": true
        },
        "maxPodsConstraint": {
          "maxPodsPerNode": "110"
        },
        "upgradeSettings": {
          "maxSurge": 1
        }
      }
    ],
    "locations": [
      "us-central1-c"
    ],
    "networkPolicy": {},
    "ipAllocationPolicy": {
      "useIpAliases": true
    },
    "masterAuthorizedNetworksConfig": {},
    "autoscaling": {},
    "networkConfig": {
      "datapathProvider": "LEGACY_DATAPATH"
    },
    "defaultMaxPodsConstraint": {
      "maxPodsPerNode": "110"
    },
    "authenticatorGroupsConfig": {},
    "databaseEncryption": {
      "state": "DECRYPTED"
    },
    "shieldedNodes": {
      "enabled": true
    },
    "releaseChannel": {
      "channel": "REGULAR"
    },
    "clusterTelemetry": {
      "type": "ENABLED"
    },
    "notificationConfig": {
      "pubsub": {}
    },
    "initialClusterVersion": "1.19.9-gke.1900",
    "location": "us-central1-c"
  }
}



## Edit the node pool

## Deploy an application


----

# Lab 04


## Task 1. Create deployment manifests and deploy to the cluster

    export my_zone=us-central1-a
    export my_cluster=standard-cluster-1

    gcloud container clusters get-credentials $my_cluster --zone $my_zone

    git clone https://github.com/GoogleCloudPlatform/training-data-analyst

    ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

    cd ~/ak8s/Deployments/

    Create a deployment manifest

    nginx-deployment.yaml 

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
      labels:
        app: nginx
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx:1.7.9
            ports:
            - containerPort: 80

    To deploy your manifest, execute the following command:

    kubectl apply -f ./nginx-deployment.yaml

    To view a list of deployments, execute the following command:

    kubectl get deployments

  Task 2. Manually scale up and down the number of Pods in deployments

    kubectl scale --replicas=3 deployment nginx-deployment

    kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record

  Task 3. Trigger a deployment rollout and a deployment rollback

  kubectl rollout status deployment.v1.apps/nginx-deployment
  kubectl get deployments


  kubectl rollout history deployment nginx-deployment


  kubectl rollout undo deployments nginx-deployment
  kubectl rollout history deployment nginx-deployment
  kubectl rollout history deployment/nginx-deployment --revision=3

  Task 4. Define the service type in the manifest

  kubectl apply -f ./service-nginx.yaml

  kubectl get service nginx

  Task 5. Perform a canary deployment
  kubectl apply -f nginx-canary.yaml
  kubectl scale --replicas=0 deployment nginx-deployment


  Session afinity

  apiVersion: v1
  kind: Service
  metadata:
    name: nginx
  spec:
    type: LoadBalancer
    sessionAffinity: ClientIP
    selector:
      app: nginx
    ports:
    - protocol: TCP
      port: 60000
      targetPort: 80


----

# Lab 05 

## Task 1. Create PVs and PVCs

  export my_zone=us-central1-a
  export my_cluster=standard-cluster-1

  source <(kubectl completion bash)

  gcloud container clusters get-credentials $my_cluster --zone $my_zone


  cat pvc-demo.yaml

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


  Task 2. Mount and verify Google Cloud persistent disk PVCs in Pods

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

  cat /var/www/html/index.html

  Task 3. Create StatefulSets with PVCs
  kubectl delete pod pvc-demo-pod
  kubectl get pods
  kubectl apply -f statefulset-demo.yaml
  kubectl describe statefulset statefulset-demo
  kubectl get pods
  kubectl get pvc
  kubectl describe pvc hello-web-disk-statefulset-demo-0

  Task 4. Verify the persistence of Persistent Volume connections to Pods managed by StatefulSets
  kubectl exec -it statefulset-demo-0 -- sh
  cat /var/www/html/index.html
  echo 1 Test webpage in a persistent volume!>/var/www/html/index.html
  chmod +x /var/www/html/index.html

  kubectl delete pod statefulset-demo-0

  kubectl get pods

  kubectl exec -it statefulset-demo-0 -- sh
  at /var/www/html/index.html
