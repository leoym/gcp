![GitHub Logo](https://www.gstatic.com/devrel-devsite/prod/v8ea8343deca3e735c5e491f22b0e2533427dcd1d0302777baea2667771626911/cloud/images/cloud-logo.svg)

# GCP
GCP Code Repository

This repository contains informations about Google Cloud

https://cloud.google.com/

Documentation:

https://cloud.google.com/gcp/getting-started


:robot:

## Products

https://cloud.google.com/products/

## Como criar um App NodeJS

    git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples
    cd nodejs-docs-samples/appengine/hello-world/standard
    export PORT=3001 && npm install
    npm start
    vi app.js


## Como criar um App .NET

    git clone https://github.com/GoogleCloudPlatform/dotnet-docs-samples
    cd dotnet-docs-samples/appengine/flexible/HelloWorld
    cat Startup.cs
    dotnet restore
    ASPNETCORE_URLS="http://*:8080" dotnet run


## Como criar um App Java

    git clone https://github.com/GoogleCloudPlatform/appengine-try-java
    cd appengine-try-java
    cat src/main/java/myapp/DemoServlet.java
    cat pom.xml
    mvn appengine:run

## Como implantar no App Engine

Criar um aplicativo

    Para fazer a implantação, é preciso criar um aplicativo em uma região:

    gcloud app create

    Observação: se você já fez isso, pule esta etapa.

    Como implantar com o Cloud Shell

    É possível usar o Cloud Shell para implantar seu aplicativo. Para fazer isso, insira:

    gcloud app deploy

Acessar seu aplicativo

O URL padrão do seu aplicativo é um subdomínio em appspot.com.


## Como usar o Cloud Storage

O Cloud Storage é um serviço para o armazenamento de objetos no Google Cloud. Primeiros passos: como usar a ferramenta gsutil

https://cloud.google.com/storage/docs/quickstart-gsutil


    gsutil mb -b on -l us-east1 gs://my-awesome-bucket/
    gsutil cp Desktop/kitten.png gs://my-awesome-bucket
    
    wget https://cloud.google.com/storage/images/kitten.png
    
    gsutil cp gs://my-awesome-bucket/kitten.png Desktop/kitten2.png
    gsutil ls gs://my-awesome-bucket
    gsutil ls -l gs://my-awesome-bucket/kitten.png
    gsutil iam ch allUsers:objectViewer gs://my-awesome-bucket
    gsutil iam ch -d allUsers:objectViewer gs://my-awesome-bucket
    
    gsutil iam ch user:jane@gmail.com:objectCreator,objectViewer gs://my-awesome-bucket
    gsutil iam ch -d user:jane@gmail.com:objectCreator,objectViewer gs://my-awesome-bucket
    
    gsutil rm gs://my-awesome-bucket/kitten.png
    gsutil rm -r gs://my-awesome-bucket
    
    
## Como usar o Compute Engine

Guia de início rápido sobre como usar uma VM do Linux

https://cloud.google.com/compute/docs/quickstart-linux


##  Como usar o Kubernetes Engine

Guia de início rápido

https://cloud.google.com/kubernetes-engine/docs/quickstart


Criar uma aplicação K8S

https://cloud.google.com/kubernetes-engine/docs/how-to/exposing-apps?hl=pt-br#kubectl-apply

Exemplo NODEJS

https://cloud.google.com/kubernetes-engine/docs/quickstarts/deploying-a-language-specific-app?hl=pt-br#node.js


## Anthos

https://cloud.google.com/anthos?hl=pt-br#section-2


## Como usar o Terraform com o Google Cloud

https://cloud.google.com/docs/terraform

https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform

https://registry.terraform.io/providers/hashicorp/google/latest/docs


    
