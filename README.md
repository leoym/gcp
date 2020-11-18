# gcp
GCP Code Repository

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
cat \
    src/main/java/myapp/DemoServlet.java
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
