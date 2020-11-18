![GitHub Logo](https://www.gstatic.com/devrel-devsite/prod/v8ea8343deca3e735c5e491f22b0e2533427dcd1d0302777baea2667771626911/cloud/images/cloud-logo.svg)

# GCP
GCP Code Repository

This repository contains informations about Google Cloud

https://cloud.google.com/

:robot:

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
