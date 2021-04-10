# Building Scalable Java Microservices with Spring Boot and Spring Cloud

---

## 1) Course Introduction
    
    Basic instructions

## 2) How to use Qwiklabs

    Getting Started with Google Cloud Platform and Qwiklabs

## 3) GCP service overview

    GCP service overview

## 4) Spring Framework Introduction

    Spring Framework Introduction

--- 

## The demo application
    13 Labs

## Bootstrapping the application frontend and backend

    Task 1. Bootstrap the application

    Clone de Code

    cd ~/
    git clone https://github.com/saturnism/spring-cloud-gcp-guestbook.git

    Copy and run backend 

    cp -a ~/spring-cloud-gcp-guestbook/1-bootstrap/guestbook-service \
    ~/guestbook-service

    cd ~/guestbook-service
    ./mvnw -q spring-boot:run -Dserver.port=8081

    curl http://localhost:8081/guestbookMessages

    curl -XPOST -H "content-type: application/json" \
  -d '{"name": "Ray", "message": "Hello"}' \
  http://localhost:8081/guestbookMessages

  curl http://localhost:8081/guestbookMessages

    Copy and run frontend

    cp -a ~/spring-cloud-gcp-guestbook/1-bootstrap/guestbook-frontend \
  ~/guestbook-frontend

    cd ~/guestbook-frontend
    ./mvnw -q spring-boot:run

Task 2. Test the guestbook application

    curl -s http://localhost:8080

    curl -s http://localhost:8081/guestbookMessages

    curl -s http://localhost:8081/guestbookMessages \
  | jq -r '._embedded.guestbookMessages[] | {name: .name, message: .message}'


## Configuring and connecting Cloud SQL


    Start by cloning the project repository:

        git clone --single-branch --branch cloud-learning https://github.com/saturnism/spring-cloud-gcp-guestbook.git

    Now copy the relevant folders to your home directory. You're ready to go!

        cp -a ~/spring-cloud-gcp-guestbook/1-bootstrap/guestbook-service ~/guestbook-service
        cp -a ~/spring-cloud-gcp-guestbook/1-bootstrap/guestbook-frontend ~/guestbook-frontend

Task 1. Create a Cloud SQL instance, database, and table

    In this task, you provision a new Cloud SQL instance, create a database on that instance, and then create a database table with a schema that can be used by the demo application to store messages.

    Enable Cloud SQL Administration API
    You enable Cloud SQL Administration API and verify that Cloud SQL is preprovisioned.

        In the Cloud Shell enable Cloud SQL Administration API.

        $ gcloud services enable sqladmin.googleapis.com

        Confirm that Cloud SQL Administration API is enabled.

        $ gcloud services list | grep sqladmin

    List the Cloud SQL instances.

        $ gcloud sql instances list
        No instances are listed yet.

        Listed 0 items.
    
    Create a Cloud SQL instance
    You create a new Cloud SQL instance.

    Provision a new Cloud SQL instance.

        $gcloud sql instances create guestbook --region=us-central1
        Provisioning the Cloud SQL instance will take a couple of minutes to complete.

        Creating Cloud SQL instance...done.
        Created [...].

NAME       DATABASE_VERSION REGION       TIER              ADDRESS   STATUS
guestbook  MYSQL_5_6        us-central1  db-n1-standard-1  92.3.4.5  RUNNABLE

    Create a database in the Cloud SQL instance
    You create a database to be used by the demo application.

    Create a messages database in the MySQL instance.

    $ gcloud sql databases create messages --instance guestbook

    Connect to Cloud SQL and create the schema
    By default, Cloud SQL is not accessible through public IP addresses. You can connect to Cloud SQL in the following ways:

    Use a local Cloud SQL proxy.
    Use gcloud to connect through a CLI client.
    From the Java application, use the MySQL JDBC driver with an SSL socket factory for secured connection.
    You create the database schema to be used by the demo application to store messages.

    Use gcloud CLI to connect to the database.
    This command temporarily allowlists the IP address for the connection.

    $ gcloud sql connect guestbook

    Press ENTER at the following prompt to leave the password empty for this lab.
    The root password is empty by default.

    Allowlisting your IP for incoming connection for 5 minutes...done.

    Connecting to database with SQL user [root].Enter password:
    The prompt changes to mysql> to indicate that you are now working in the MySQL command-line environment.

    Note

    For security reasons, the default setting for Cloud SQL does not allow connections to the public IP unless an address is explicitly allowlisted. The gcloud sql connect command line automatically and temporarily allowlists your incoming connection. It takes a minute or two for the allowlisting process to complete before the MySQL administration client can connect.

    List the databases.

    show databases;

    This command lists all of the databases on the Cloud SQL instance, which should include the messages database that you configured in previous steps.

+--------------------+
| Database           |
+--------------------+
| information_schema |
| messages           |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.04 sec)
Switch to the messages database.

    use messages;
    Create the table.

    CREATE TABLE guestbook_message (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name CHAR(128) NOT NULL,
  message CHAR(255),
  image_uri CHAR(255),
  PRIMARY KEY (id)
);

    Exit the MySQL management utility.
    You return to the standard Cloud Shell user prompt.

    exit


Task 2. Use Spring to add Cloud SQL support to your application
In this task, you add the Spring Cloud GCP Cloud SQL starter to your project so that you can use Spring to connect to your Cloud SQL database.

Add the Spring Cloud GCP Cloud SQL starter
From a Java application, you can integrate with a Cloud SQL instance by using the standard method, where you use the JDBC driver. However, configuring the JDBC driver for use with Cloud SQL can be more complicated than connecting to a standard MySQL server because of the additional security that GCP puts in place. Using the Spring Cloud GCP Cloud SQL starter simplifies this task.

The Spring Cloud GCP project provides configurations that you can use to automatically configure your Spring Boot applications to consume GCP services, including Cloud SQL.

You update the guestbook service's pom.xml file to import the Spring Cloud GCP BOM and also the Spring Cloud GCP Cloud SQL starter. This process involves adding the milestone repository to use the latest Spring release candidates.

Edit guestbook-service/pom.xml in the Cloud Shell code editor or in the shell editor of your choice.
Note

The lab instructions refer only to the Cloud Shell code editor, but you can use vi, vim, emacs or nano as your text editor if you prefer.

Insert an additional dependency for spring-cloud-gcp-starter-sql-mysql just before the </dependencies> closing tag.

      <dependency>
         <groupId>org.springframework.cloud</groupId>
         <artifactId>spring-cloud-gcp-starter-sql-mysql</artifactId>
      </dependency>

Disable Cloud SQL in the default profile

For local testing, you can continue to use a local database or an embedded database. The demo application is initially configured to use an embedded HSQL database.

To continue to use the demo application for local runs, you disable the Cloud SQL starter in the default application profile by updating the application.properties file.

In the Cloud Shell code editor, open guestbook-service/src/main/resources/application.properties.

Add the following property setting:

spring.cloud.gcp.sql.enabled=false


Task 3. Configure an application profile to use Cloud SQL

In this task, you create an application profile that contains the properties that are required by the Spring Boot Cloud SQL starter to connect to your Cloud SQL database.

Configure a cloud profile
When deploying the demo application into the cloud, you want to use the production-managed Cloud SQL instance.

You create an application profile called cloud profile. The cloud profile leaves the Cloud SQL starter that is defined in the Spring configuration profile enabled. And it includes properties used by the Cloud SQL starter to provide the connection details for your Cloud SQL instance and database.

In the Cloud Shell find the instance connection name by running the following command:

$ gcloud sql instances describe guestbook --format='value(connectionName)'

This command format filters out the connectionName property from the description of the guestbook Cloud SQL object. The entire string that is returned is the instance's connection name. The string looks like the following example:

qwiklabs-gcp-4d0ab38f9ff2cc4c:us-central1:guestbook

In the Cloud Shell code editor create an application-cloud.properties file in the guestbook-service/src/main/resources directory.

In the Cloud Shell code editor, open guestbook-service/src/main/resources/application-cloud.properties and add the following properties:

spring.cloud.gcp.sql.enabled=true
spring.cloud.gcp.sql.database-name=messages
spring.cloud.gcp.sql.instance-connection-name=YOUR_INSTANCE_CONNECTION_NAME
Replace the YOUR_INSTANCE_CONNECTION_NAME placeholder with the full connection name string returned in step 1 in this task.
If you worked in the Cloud Shell code editor, your screen looks like the following screenshot:

lab2-cloudshell-screenshot.png

Configure the connection pool
You use the spring.datasource.* configuration properties to configure the JDBC connection pool, as you do with other Spring Boot applications.

Add the following property to guestbook-service/src/main/resources/application-cloud.properties that should still be open in the Cloud Shell code editor to specify the connection pool size.

spring.datasource.hikari.maximum-pool-size=5

Test the backend service running on Cloud SQL
You relaunch the backend service for the demo application in Cloud Shell, using the new cloud profile that configures the service to use Cloud SQL instead of the embedded HSQL database.

In the Cloud Shell change to the guestbook-service directory.

cd ~/guestbook-service
Run a test with the default profile and make sure there are no failures.

./mvnw test

Start the Guestbook Service with the cloud profile.

./mvnw spring-boot:run \
  -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

During the application startup, validate that you see CloudSQL related connection logs.

… First Cloud SQL connection, generating RSA key pair.
… Obtaining ephemeral certificate for Cloud SQL instance [springone17-sfo-1000:us-ce
… Connecting to Cloud SQL instance [...:us-central1:guestbook] on …
… Connecting to Cloud SQL instance [...:us-central1:guestbook] on …
… Connecting to Cloud SQL instance [...:us-central1:guestbook] on …
...
In a new Cloud Shell tab, make a few calls using curl:

curl -XPOST -H "content-type: application/json" \
  -d '{"name": "Ray", "message": "Hello CloudSQL"}' \
  http://localhost:8081/guestbookMessages

You can also list all the messages:

curl http://localhost:8081/guestbookMessages

Use the Cloud SQL client to validate that message records have been added to the database.

$ gcloud sql connect guestbook

Press ENTER at the Enter password prompt.

Allowlisting your IP for incoming connection for 5 minutes...done.
Connecting to database with SQL user [root].Enter password:
Query the guestbook_message table in the messages database.

use messages
select * from guestbook_message;
The guestbook_messages table now contains a record of the test message that you sent using curl in a previous step.

+----+------+----------------+-----------+
| id | name | message        | image_uri |
+----+------+----------------+-----------+
|  1 | Ray  | Hello Cloud SQL | NULL      |
+----+------+----------------+-----------+
1 row in set (0.04 sec)
Close the Cloud SQL interactive client.

exit
Note

You will test the full application using the Cloud SQL enabled backend service application in the next lab.

## Working with runtime configurations 

    Fetch the application source files
    
    Click the Activate Cloud Shell

    $ export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

    Verify that the demo application files were created.

    $ gsutil ls gs://$PROJECT_ID

    Copy the application folders to Cloud Shell.

    $ gsutil -m cp -r gs://$PROJECT_ID/* ~/

    Make the Maven wrapper scripts executable. Now you're ready to go!

    $ chmod +x ~/guestbook-frontend/mvnw

    $ chmod +x ~/guestbook-service/mvnw

Task 1. Add the Spring Cloud GCP Config starter

In this task, you update the frontend application's pom.xml

Open guestbook-frontend/pom.xml in the Cloud Shell code editor.

Add the following dependency definition to the <dependencies> section:

        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-gcp-starter-trace</artifactId>
        </dependency>
        <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-gcp-starter-config</artifactId>
            <version>1.2.0.RC2</version>
        </dependency>

Insert a new section called <repositories> at the bottom of the file, after the <build> section and just before the closing </project> tag.

    <repositories>
         <repository>
              <id>spring-milestones</id>
              <name>Spring Milestones</name>
              <url>https://repo.spring.io/milestone</url>
              <snapshots>
                  <enabled>false</enabled>
              </snapshots>
         </repository>
    </repositories>
Note

    The version for the spring-cloud-gcp-starter-config and the milestones repo are necessary because Runtime Config is in beta.

Task 2. Configure a local profile

    When deploying the demo application locally, you want to use a production configuration that includes properties for local services.

    In this task, you set a local profile in the default profile for the frontend application.

    In the guestbook-frontend/src/main/resources/ folder, create a file called bootstrap.properties that disables the Spring Cloud GCP starter.

Open guestbook-frontend/src/main/resources/bootstrap.properties in the Cloud Shell code editor and add the following property:

spring.cloud.gcp.config.enabled=true
spring.cloud.gcp.config.name=frontend
spring.cloud.gcp.config.profile=local

Open guestbook-frontend/src/main/resources/application.properties and add the following property:

management.endpoints.web.exposure.include=*

This property allows access to the Spring Boot Actuator endpoint so that you can dynamically refresh the configuration.

Note

The combination of ${spring.cloud.gcp.config.name}_${spring.cloud.gcp.config.profile} forms frontend_local, which is the name of the runtime configuration that you create in a later task.

Task 3. Configure a cloud profile

    When deploying the demo application into the cloud, you want to use a production configuration that includes properties for cloud services.

    In this task, you use the Spring configuration profile and create a cloud profile for the frontend application.

    In the guestbook-frontend/src/main/resources/ folder, create a file called bootstrap-cloud.properties that defines the Spring Cloud Config bootstrapping configuration.

    Open guestbook-frontend/src/main/resources/bootstrap-cloud.properties in the Cloud Shell code editor and add the following new properties:

    spring.cloud.gcp.config.enabled=true
    spring.cloud.gcp.config.name=frontend
    spring.cloud.gcp.config.profile=cloud


Task 4. Add RefreshScope to FrontendController

    By default, runtime configuration values are read only when an application starts. In this task, you add a Spring Cloud Config RefreshScope to the frontend application so that runtime configuration values can be updated dynamically without restarting the application. You do this by adding an @RefreshScope annotation to the FrontendController source file.

    Open guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java in the Cloud Shell code editor.

    Insert the following lines below the import directives just above @Controller:

    import org.springframework.cloud.context.config.annotation.RefreshScope;

    @RefreshScope

Task 5. Create a runtime configuration

    In this task, you enable Cloud Runtime Configuration API and create a runtime configuration value that is used to dynamically update the application.

    In the Cloud Shell enable Cloud Runtime Configuration API.

    gcloud services enable runtimeconfig.googleapis.com

Create a runtime configuration for the frontend application's local profile.

    $ gcloud beta runtime-config configs create frontend_local
    
    A URL for the new runtime configuration similar to the following is displayed:

    Created [https://runtimec.../v1beta1/projects/.../frontend_local].
    Created [https://runtimeconfig.googleapis.com/v1beta1/projects/qwiklabs-gcp-01-d757967ad5b1/configs/frontend_local].

    Set a new configuration value for the greeting message.

    gcloud beta runtime-config configs variables set greeting \
  "Hi from Runtime Config" \
  --config-name frontend_local

  Created [https://runtimeconfig.googleapis.com/v1beta1/projects/qwiklabs-gcp-01-d757967ad5b1/configs/frontend_local/variables/greeting].


    Enter the following command to display all the variables in the runtime configuration:

    gcloud beta runtime-config configs variables list --config-name=frontend_local

    Enter the following command to display the value of a specific variable.

    gcloud beta runtime-config configs variables \
    get-value greeting --config-name=frontend_local

The command displays the value of greeting.

Task 6. Run the updated application locally

    In this task, you test the changes that you made to the application by testing the Maven build with the default profile and then using the cloud profile to restart the frontend service.

    Change to the guestbook-service directory.

    $ cd ~/guestbook-service

    Run the backend service application.

    $ ./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

    The backend service application launches on port 8081. The cloud profile specified here is configured with the Cloud SQL database enabled. This takes a minute or two to complete and you should wait until you see that the GuestbookApplication is running.

    Started GuestbookApplication in 20.399 seconds (JVM running...)

    Open a new Cloud Shell session tab to run the frontend application by clicking the plus (+) icon to the right of the title tab for the initial Cloud Shell session.

    This action opens a second Cloud Shell console to the same virtual machine.

    Change to the guestbook-frontend directory.

    $ cd ~/guestbook-frontend

    Start the frontend application with the cloud profile.

    $ ./mvnw spring-boot:run -Dspring.profiles.active=cloud

    Use the Cloud Shell web preview to browse to the frontend application on port 8080.
    
    Enter values for Your name and Message, and then click Post to trigger the Hello response.

    Verify that the returned greeting message now uses the value you set using the Cloud Runtime Configuration API.
    91cb2e6db18917d0.png

    Note

    If you use Spring Boot Actuator, you can refresh and reload configurations on the fly. See sample code for how that works. You will test this in the next task.

Task 7. Update and refresh a configuration

    In this task, you update a runtime configuration property by using Cloud Runtime Configuration API. And you verify that the application has dynamically refreshed the variable linked to that property.

    Open a new Cloud Shell tab and update the greeting configuration value:

    $ gcloud beta runtime-config configs variables set greeting \
  "Hi from Updated Config" \
  --config-name frontend_local

    Use curl to trigger Spring Boot Actuator so that it reloads configuration values from the Runtime Configuration API service.

    curl -XPOST http://localhost:8080/actuator/refresh

    Post another message to the guestbook application through the frontend application in the Web Preview tab.
    The updated greeting response is displayed.

    7e042d9d9a14003a.png

    You can also use Spring Boot Actuator to display the current configuration values directly, as well as other information using this syntax.

    curl http://localhost:8080/actuator/configprops | jq
This command prints out the configuration property values in JSON format.

## Working with Stackdriver Trace

Task 0: Fetch the application source files

To begin the lab:

    Click the Activate Cloud Shell

1) Create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

2) Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

3) Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

4) Make the Maven wrapper scripts executable.

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Enable Cloud Trace API

Enable Cloud Trace API:
    
    gcloud services enable cloudtrace.googleapis.com

Task 2. Add the Spring Cloud GCP Trace starter

Click on the Open Editor icon and then, open ~/guestbook-service/pom.xml.

Insert the following new dependency at the end of the dependencies section, just before the closing </dependencies> tag:

        <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-gcp-starter-trace</artifactId>
        </dependency>

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Insert the following new dependency at the end of the dependencies section, just before the closing </dependencies> tag:

        <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-gcp-starter-trace</artifactId>
        </dependency>

Task 3. Configure applications

Disable trace completely for the default profile and configure trace sampling for all requests in the cloud profile.

Disable trace for testing purposes

In the Cloud Shell code editor, open guestbook-service/src/main/resources/application.properties.

Add the following property to disable tracing in the guestbook service:

spring.cloud.gcp.trace.enabled=false

In the Cloud Shell code editor, open guestbook-frontend/src/main/resources/application.properties.

Add the following property to disable tracing in the guestbook frontend application:

spring.cloud.gcp.trace.enabled=false

Enable trace sampling for the cloud profile for the guestbook backend
For the cloud profile for the guestbook backend, you enable trace sampling for all of the requests in the application.properties file used for the cloud profile.

In the Cloud Shell code editor, open the guestbook service cloud profile: guestbook-service/src/main/resources/application-cloud.properties.

Add the following properties to enable the tracing detail needed in the guestbook service:

spring.cloud.gcp.trace.enabled=true
spring.sleuth.sampler.probability=1.0
spring.sleuth.scheduled.enabled=false

Enable trace sampling for the cloud profile for the guestbook frontend
For the cloud profile for the frontend application, you enable trace sampling for all of the requests in the application.properties file used for the cloud profile.

In the Cloud Shell code editor, create a properties file for the guestbook frontend application cloud profile: guestbook-frontend/src/main/resources/application-cloud.properties.

Add the following properties to enable the tracing detail needed in the guestbook frontend application:

spring.cloud.gcp.trace.enabled=true
spring.sleuth.sampler.probability=1.0
spring.sleuth.scheduled.enabled=false


Task 4. Set up a service account

Click on the Open Terminal

Create service account specific to the guestbook application.

gcloud iam service-accounts create guestbook

Add the Editor role for your project to this service account.

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:guestbook@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/editor

Generate the JSON key file to be used by the application to identify itself using the service account.

gcloud iam service-accounts keys create \
    ~/service-account.json \
    --iam-account guestbook@${PROJECT_ID}.iam.gserviceaccount.com

This command creates service account credentials that are stored in the $HOME/service-account.json file.


Task 5. Run the application locally with your service account

Change to the guestbook-service directory.

cd ~/guestbook-service
Start the guestbook backend service application.

./mvnw spring-boot:run \
  -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud \
  -Dspring.cloud.gcp.credentials.location=file:///$HOME/service-account.json"

This takes a minute or two to complete and you should wait until you see that the GuestbookApplication is running.

Started GuestbookApplication in 20.399 seconds (JVM running...)

Open a new Cloud Shell tab by clicking the plus (+) icon to the right of the title of the current Cloud Shell tab.

Change to the guestbook-frontend directory.

cd ~/guestbook-frontend

Start the guestbook frontend application.

./mvnw spring-boot:run \
  -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud \
  -Dspring.cloud.gcp.credentials.location=file:///$HOME/service-account.json"

Post a message using the Cloud Shell web preview of the application to generate trace data.

Task 6. Examine the traces

Open the GCP console browser tab.

In the Navigation Menu navigate to Trace > Trace List in the Operations section.
cloud-trace.png

At the top of the window, set the time range to 1 hour.
Turn Auto reload on. New trace data will take up to 30 seconds to appear.

trace.png

Click the blue dot to view trace detail.
trace_details.png

End your lab


## Messaging with Cloud PubSub

Fetch the application source files
To begin the lab, 
    click the Activate Cloud Shell

Create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable. Now you're ready to go!

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Enable Cloud Pub/Sub API

In the Cloud Shell, enable Cloud Pub/Sub API.

    gcloud services enable pubsub.googleapis.com

Task 2. Create a Cloud Pub/Sub topic

In this task, you create a Cloud Pub/Sub topic to send the message to.

Use gcloud to create a Cloud Pub/Sub topic.

    gcloud pubsub topics create messages

Task 3. Add Spring Cloud GCP Pub/Sub starter

In this task, you update the guestbook frontend application's pom.xml file to include the Spring Cloud GCP starter for Cloud Pub/Sub in the dependency section.

Open the Cloud Shell code editor.

In the code editor, open ~/guestbook-frontend/pom.xml.

Insert the following new dependency at the end of the <dependencies> section, just before the closing </dependencies> tag:

        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-gcp-starter-pubsub</artifactId>
        </dependency>

Task 4. Publish a message

In this task, you use the PubSubTemplate bean in Spring Cloud GCP to publish a message to Cloud Pub/Sub. 

This bean is automatically configured and made available by the starter. You add PubSubTemplate to FrontendController.

Open guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java in the Cloud Shell code editor.

Add the following statement immediately after the existing import directives:

import org.springframework.cloud.gcp.pubsub.core.*;

Insert the following statement between the lines private GuestbookMessagesClient client; and @Value("${greeting:Hello}"):

    @Autowired
    private PubSubTemplate pubSubTemplate;

Add the following statement inside the if statement to process messages that aren't null or empty, just below the comment // Post the message to the backend service:

pubSubTemplate.publish("messages", name + ": " + message);

The code for FrontendController.java should now look like the screenshot:

update-editor.png

Task 5. Test the application in the Cloud Shell

In this task, you run the application in the Cloud Shell to test the new Cloud Pub/Sub message handling code.

In the Cloud Shell change to the guestbook-service directory.

cd ~/guestbook-service

Run the backend service application.

./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

The backend service application launches on port 8081.This takes a minute or two to complete and you should wait until you see that the GuestbookApplication is running.

Started GuestbookApplication in 20.399 seconds (JVM running...)

Open a new Cloud Shell session tab to run the frontend application by clicking the plus (+) icon to the right of the title tab for the initial Cloud Shell session.

Change to the guestbook-frontend directory.

cd ~/guestbook-frontend

Start the frontend application with the cloud profile.

./mvnw spring-boot:run -Dspring.profiles.active=cloud

Open the Cloud Shell web preview and post a message.

The frontend application tries to publish a message to the Cloud Pub/Sub topic. You will check if this was successful in the next task.


Task 6. Create a subscription

Before subscribing to a topic, you must create a subscription. Cloud Pub/Sub supports pull subscription and push subscription. With a pull subscription, the client can pull messages from the topic. With a push subscription, Cloud Pub/Sub can publish messages to a target webhook endpoint.

A topic can have multiple subscriptions. A subscription can have many subscribers. If you want to distribute different messages to different subscribers, then each subscriber needs to subscribe to its own subscription. If you want to publish the same messages to all the subscribers, then all the subscribers must subscribe to the same subscription.

Cloud Pub/Sub delivery is "at least once." Thus, you must deal with idempotence and you must deduplicate messages if you cannot process the same message more than once.

In this task, you create a Cloud Pub/Sub subscription and then test it by pulling messages from the subscription before and after using the frontend application to post a message.

Open a new Cloud Shell tab.

Create a Cloud Pub/Sub subscription.

gcloud pubsub subscriptions create messages-subscription-1 \
  --topic=messages

Pull messages from the subscription.

gcloud pubsub subscriptions pull messages-subscription-1

The pull messages command should report 0 items.

The message you posted earlier does not appear, because the message was published before the subscription was created.

Return to the frontend application, post another message, and then pull the message again.

gcloud pubsub subscriptions pull messages-subscription-1

The message appears. The message remains in the subscription until it is acknowledged.

Pull the message again and remove it from the subscription by using the auto-acknowledgement switch at the command line.

gcloud pubsub subscriptions pull messages-subscription-1 --auto-ack

Task 7. Process messages in subscriptions

In this task, you use the Spring PubSubTemplate to listen to subscriptions.

In the Cloud Shell generate a new project from Spring Initializr.

cd ~

curl https://start.spring.io/starter.tgz \
  -d dependencies=web,cloud-gcp-pubsub \
  -d baseDir=message-processor | tar -xzvf -


Open ~/message-processor/pom.xml to verify that the starter dependencies were automatically added.

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>com.google.cloud</groupId>
            <artifactId>spring-cloud-gcp-starter-pubsub</artifactId>
        </dependency>
    </dependencies>

To write the code to listen for new messages delivered to the topic, open ~/message-processor/src/main/java/com/example/demo/DemoApplication.java in the Cloud Shell code editor.

Add the following import directives below the existing import directives:

import org.springframework.context.annotation.Bean;
import org.springframework.boot.ApplicationRunner;
import com.google.cloud.spring.pubsub.core.*;

Add the following code block to the class definition for DemoApplication, just above the existing definition for the main method:

    @Bean
    public ApplicationRunner cli(PubSubTemplate pubSubTemplate) {
        return (args) -> {
            pubSubTemplate.subscribe("messages-subscription-1",
                (msg) -> {
                    System.out.println(msg.getPubsubMessage()
                        .getData().toStringUtf8());
                    msg.ack();
                });
        };
    }

We added the Web starter simply because it's much easier to put Spring Boot application into daemon mode, so that it doesn't exit immediately. There are other ways to create a Daemon, e.g., using a CountDownLatch, or create a new Thread and set the daemon property to true. But since we are using the Web starter, make sure that the server port is running on a different port to avoid port conflicts.

Add this line to change the port on message-processor/src/main/resources/application.properties:

server.port=${PORT:9090}

Return to the Cloud Shell tab for the message processor to listen to the topic.

cd ~/message-processor
./mvnw -q spring-boot:run

Open the browser with the frontend application, and post a few messages.
Verify that the Cloud Pub/Sub messages are received in the message processor.
The new messages should be displayed in the Cloud Shell tab where the message processor is running, as in the following example:

... [main] com.example.demo.DemoApplication         : Started DemoApplication...
Ray: Hey
Ray: Hello!
End your lab




## Integrating Cloud PubSub with Spring

Task 0. Lab Preparation

Open Google Console

    Click the Activate Cloud Shell button
    
Create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable. Now you're ready to go!

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Add the Spring Integration core

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Insert the following new dependency at the end of the <dependencies> section, just before the closing </dependencies> tag:

       <dependency>
            <groupId>org.springframework.integration</groupId>
            <artifactId>spring-integration-core</artifactId>
       </dependency>

Task 2. Create an outbound message gateway

In the Cloud Shell code editor, create a file named OutboundGateway.java in the ~/guestbook-frontend/src/main/java/com/example/frontend directory.

Open ~/guestbook-frontend/src/main/java/com/example/frontend/OutboundGateway.java.

Add the following code to the new file:

package com.example.frontend;

import org.springframework.integration.annotation.MessagingGateway;

@MessagingGateway(defaultRequestChannel = "messagesOutputChannel")
public interface OutboundGateway {
        void publishMessage(String message);
}

Task 3. Publish the message

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java.
Replace the code that references pubSubTemplate with references to outboundGateway:

1) Replace these lines:

    @Autowired
    private PubSubTemplate pubSubTemplate;

With these lines:

    @Autowired
    private OutboundGateway outboundGateway;

2) Replace this line:

    pubSubTemplate.publish("messages", name + ": " + message);

With this line:

    outboundGateway.publishMessage(name + ": " + message);


Task 4. Bind the output channel to the Cloud Pub/Sub topic

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/java/com/example/frontend/FrontendApplication.java.

Add the following import directives below the existing import directives:

import org.springframework.context.annotation.*;
import org.springframework.cloud.gcp.pubsub.core.*;
import org.springframework.cloud.gcp.pubsub.integration.outbound.*;
import org.springframework.integration.annotation.*;
import org.springframework.messaging.*;

Add the following code just before the closing brace at the end of the FrontEndApplication class definition:

    @Bean
    @ServiceActivator(inputChannel = "messagesOutputChannel")
    public MessageHandler messageSender(PubSubTemplate pubsubTemplate) {
        return new PubSubMessageHandler(pubsubTemplate, "messages");
    }

FrontendApplication.java now looks like the following


Task 5. Test the application in the Cloud Shell

In the Cloud Shell change to the guestbook-service directory.

cd ~/guestbook-service

Run the backend service application.

./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

The backend service application launches on port 8081.This takes a minute or two to complete and you should wait until you see that the GuestbookApplication is running.

Started GuestbookApplication in 20.399 seconds (JVM running...)

Open a new Cloud Shell session tab to run the frontend application by clicking the plus (+) icon to the right of the title tab for the initial Cloud Shell session.


Change to the guestbook-frontend directory.

cd ~/guestbook-frontend

Start the frontend application with the cloud profile.

./mvnw spring-boot:run -Dspring.profiles.active=cloud

Open the Cloud Shell web preview and post a message.

Open a new Cloud Shell session tab and check the Cloud Pub/Sub subscription for the published messages.

gcloud pubsub subscriptions pull messages-subscription-1 --auto-ack

Note

Spring Integration for Cloud Pub/Sub works for both inbound messages and outbound messages. Cloud Pub/Sub also supports Spring Cloud Stream to create reactive microservices.

End your lab



## Uploading and storing files

Task 0. Lab Preparation

Click Open Google Console. 
Create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable. Now you're ready to go!

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Add the Cloud Storage starter

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Insert the following new dependency at the end of the <dependencies> section, just before the closing </dependencies> tag:

        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-gcp-starter-storage</artifactId>
        </dependency>

Task 2. Store the uploaded file

Modify the main.container class to allow file uploads
You edit the main.container class input form action to handle multi-part data encoding.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/resources/templates/index.html.

Change this line:

    <form action="/post" method="post">
To these lines:

    <!-- Set form encoding type to multipart form data -->
    <form action="/post" method="post" enctype="multipart/form-data">


Insert the following tags before the <input type="submit" value="Post"/> tag:

    <!-- Add a file input -->

    <span>File:</span>
    <input type="file" name="file" accept=".jpg, image/jpeg"/>

Update FrontendController to accept the uploaded file

You update the FrontendController.java file to accept file data if the user chooses to upload an image with a message.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java.

Insert the following import directives immediately below the existing import directives:

import org.springframework.cloud.gcp.core.GcpProjectIdProvider;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.Resource;
import org.springframework.core.io.WritableResource;
import org.springframework.util.StreamUtils;
import java.io.*;

Insert the following code near the beginning of the FrontendController class definition, immediately before @GetMapping("/").

You need to get Applicationcontext in order to create a new resource. The project ID is required in order to access Cloud Storage because this demo application uses the project ID as the Cloud Storage bucket name.

    // The ApplicationContext is needed to create a new Resource.
    @Autowired
    private ApplicationContext context;
    // Get the Project ID, as its Cloud Storage bucket name here
    @Autowired
    private GcpProjectIdProvider projectIdProvider;

Change the definition for the post method
You modify the post method to save uploaded images to Cloud Storage.

Near the end of the file, change this line:

public String post(@RequestParam String name, @RequestParam String message, Model model) {
    
To these lines:

    public String post(
       @RequestParam(name="file", required=false) MultipartFile file,
         @RequestParam String name,
         @RequestParam String message, Model model)
       throws IOException {

Insert the following code immediately after the line model.addAttribute("name", name);:

        String filename = null;
        if (file != null && !file.isEmpty()
            && file.getContentType().equals("image/jpeg")) {
                // Bucket ID is our Project ID
                String bucket = "gs://" +
                      projectIdProvider.getProjectId();
                // Generate a random file name
                filename = UUID.randomUUID().toString() + ".jpg";
                WritableResource resource = (WritableResource)
                      context.getResource(bucket + "/" + filename);
                // Write the file to Cloud Storage
                try (OutputStream os = resource.getOutputStream()) {
                     os.write(file.getBytes());
                 }
        }

Add the following code to insert the location of the uploaded file immediately before the client.add(payload); line:

            // Store the generated file name in the database
            payload.setImageUri(filename);

Task 3. Test the application in the Cloud Shell

In the Cloud Shell change to the guestbook-service directory.

    cd ~/guestbook-service
    
Run the backend service application.

./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

The backend service application launches on port 8081.This takes a minute or two to complete and you should wait until you see that the GuestbookApplication is running.

Started GuestbookApplication in 20.399 seconds (JVM running...)
Open a new Cloud Shell session tab to run the frontend application by clicking the plus (+) icon to the right of the title tab for the initial Cloud Shell session.

Change to the guestbook-frontend directory.

    cd ~/guestbook-frontend

Start the frontend application with the cloud profile.

    ./mvnw spring-boot:run -Dspring.profiles.active=cloud

Open the Cloud Shell web preview on port 8080 and post a message with a small JPEG image.

From the GCP console, navigate to Storage > Browser.

Navigate to your bucket.

Task 4. Serve the image from Cloud Storage

Add a method to FrontendController to retrieve the requested image and send it to the browser

You edit FrontendController.java so that it fetches image files associated with messages if they are found.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java.

Add the following import directive immediately below the existing import directives:

import org.springframework.http.*;

Insert the following code at the end of the FrontEndController class definition, after the closing brace for the post method definition and immediately before the final closing brace:

  // ".+" is necessary to capture URI with filename extension
  @GetMapping("/image/{filename:.+}")
  public ResponseEntity<Resource> file(
      @PathVariable String filename) {
          String bucket = "gs://" +
                            projectIdProvider.getProjectId();
          // Use "gs://" URI to construct
          // a Spring Resource object
          Resource image = context.getResource(bucket +
                           "/" + filename);
          // Send it back to the client
          HttpHeaders headers = new HttpHeaders();
          headers.setContentType(MediaType.IMAGE_JPEG);
          return new ResponseEntity<>(
          image, headers, HttpStatus.OK);
  }


Update the home page so that it loads the image if present
You edit the main.container class to load and display images for messages if they are present.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/resources/templates/index.html.

In the next step, you insert an <image> tag in the messages class.

Add the following <img> tag after the second <span> tag:

            <img th:src="'/image/' + ${message.imageUri}"
                 alt="image" height="40px"
                 th:unless="${#strings.isEmpty(message.imageUri)}"/>


Task 5. Restart the frontend application to test image retrieval

Switch to the interactive Cloud Shell tab that is running the frontend application. You should see the following status message on screen.

c12378ed02b20518.png

Press CTRL+C to terminate the running application.

Restart the frontend application.

    cd ~/guestbook-frontend
    ./mvnw spring-boot:run -Dspring.profiles.active=cloud

Switch to the web preview browser tab, and refresh the view to verify that messages with uploaded images now display image thumbnails properly.



## Using Cloud Platform application


Task 0. Lab Preparation

Open Google Console

Click the Activate Cloud Shell button at the top of the Google Cloud Console. 

In the Cloud Shell command line, enter the following command to create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable. Now you're ready to go!

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Enable Vision API

Enter the following command in the Cloud Shell code editor to enable Vision API:

    gcloud services enable vision.googleapis.com

Task 2. Add the Vision client library

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Insert the following new dependency at the end of the <dependencies> section, just before the closing </dependencies> tag:

<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-gcp-starter-vision</artifactId>
</dependency>

Task 3. Add a GCP credential scope for Spring

In this task, you specify the GCP scope in the application.properties file.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/resources/application.properties.

Add the following entry:

spring.cloud.gcp.credentials.scopes=https://www.googleapis.com/auth/cloud-platform

In a production application, you should always specify the narrowest scopes that the application needs to use the APIs.

Task 4. Analyze the image

In this task, you analyze the uploaded image, label the objects in the image, and print out the response.

Add a method to the frontend application to use Vision API to analyze an image
You add a method to FrontendController.java that sends an image to Google Vision API for analysis.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java.

Insert the following import directives immediately below the existing imports:

// Add Vision API imports
import org.springframework.cloud.gcp.vision.CloudVisionTemplate;
import com.google.cloud.vision.v1.Feature.Type;
import com.google.cloud.vision.v1.AnnotateImageResponse;
Insert the following code into the FrontendController class definition immediately above the @GetMapping("/") line:

@Autowired
private CloudVisionTemplate visionTemplate;

Modify the frontend application to analyze the image once it is written to the Cloud Storage bucket

In FrontendController.java you add a call to the new analyzeImage method after the code that uploads the file to Cloud Storage.

In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/java/com/example/frontend/FrontendController.java.

Insert the following line into the post method definition after the try block inside the post method definition:

// After writing to GCS, analyze the image.
AnnotateImageResponse response = visionTemplate
.analyzeImage(resource, Type.LABEL_DETECTION);
log.info(response.toString());

Task 5. Set up a service account

In this task, you create a service account with the Editor role, and you create a JSON file containing the authentication keys for the service account.

Create a service account specific to the guestbook application.

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
gcloud iam service-accounts create guestbook
Add the Editor role to this service account.

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:guestbook@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/editor

Generate the JSON key file to be used by the application to identify itself using the service account.

gcloud iam service-accounts keys create \
    ~/service-account.json \
    --iam-account guestbook@${PROJECT_ID}.iam.gserviceaccount.com

This command creates service account credentials that are stored in the $HOME/service-account.json file.


Task 6. Test the application in the Cloud Shell

In the Cloud Shell change to the guestbook-service directory.

cd ~/guestbook-service
Run the backend service application.

./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud"

The backend service application launches on port 8081.This takes a minute or two to complete and you should wait until you see that the GuestbookApplication is running.

Started GuestbookApplication in 20.399 seconds (JVM running...)
Open a new Cloud Shell session tab to run the frontend application by clicking the plus (+) icon to the right of the title tab for the initial Cloud Shell session.

Change to the guestbook-frontend directory.

cd ~/guestbook-frontend

Start the guestbook frontend application using the cloud profile and the guestbook service account credentials.

./mvnw spring-boot:run \
  -Dspring-boot.run.jvmArguments="-Dspring.profiles.active=cloud \
  -Dspring.cloud.gcp.credentials.location=file:///$HOME/service-account.json"

Open the Cloud Shell web preview on port 8080 and post a message with a small JPEG image.

In the frontend application Cloud shell tab you should see image labels in the log output similar to the following example:

label_annotations {
  mid: "/m/09ggk"
  description: "purple"
  score: 0.8982213
  topicality: 0.8982213
}
label_annotations {
  mid: "/m/07vwy6"
  description: "street art"
  score: 0.86210686
  topicality: 0.86210686
}
label_annotations {
  mid: "/m/04rd7"
  description: "mural"
  score: 0.81835103
  topicality: 0.81835103
}
End your lab


## Deploying App Engine


Task 0. Lab Preparation

Click the Activate Cloud Shell

Create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable. Now you're ready to go!

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Initialize App Engine

Enable App Engine in the project.

    gcloud app create --region=us-central

Task 2. Deploy Guestbook Frontend

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Add the following code at the end of the <plugins> section, immediately before the closing </plugins> tag:

<plugin>
  <groupId>com.google.cloud.tools</groupId>
  <artifactId>appengine-maven-plugin</artifactId>
  <version>2.2.0</version>
  <configuration>
    <version>1</version>
    <deploy.projectId>GCLOUD_CONFIG</deploy.projectId>
    </configuration>
</plugin>

In the Cloud Shell, create an App Engine directory in Guestbook Frontend.

mkdir -p ~/guestbook-frontend/src/main/appengine

In the Cloud Shell code editor, create a file named app.yaml in the ~/guestbook-frontend/src/main/appengine/ directory. This file is required to deploy the application to App Engine.

Add the following code to the app.yaml file. Make sure to replace PROJECT_ID with your Project ID. You can use the command echo $PROJECT_ID in the Cloud Shell to retrieve it.

runtime: java11
instance_class: B4_1G
manual_scaling:
  instances: 2
env_variables:
  SPRING_PROFILES_ACTIVE: cloud
  # REPLACE PROJECT_ID with your project ID!
  MESSAGES_ENDPOINT: https://guestbook-service-dot-PROJECT_ID.appspot.com/guestbookMessages

In the Cloud Shell, change to the frontend application directory.

    cd ~/guestbook-frontend

Use Apache Maven to deploy the frontend application to App Engine. This should take a few minutes.

    mvn package appengine:deploy -DskipTests

Note: you may need to run the command twice if there is a build error!
This command reports out success like the following example:

[INFO] GCLOUD: Deployed service [default] to [https://PROJECT_ID.appspot.com]
[INFO] GCLOUD:
[INFO] GCLOUD: You can stream logs from the command line by running:
[INFO] GCLOUD:   $ gcloud app logs tail -s default
[INFO] GCLOUD:
[INFO] GCLOUD: To view your application in the web browser run:
[INFO] GCLOUD:   $ gcloud app browse
[INFO] ------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------
[INFO] Total time: 03:00 min
[INFO] Finished at: 2018-12-08T10:30:09Z
[INFO] ------------------------------------------------------

Find the frontend URL.

    gcloud app browse

This command reports a URL that links to your application's frontend.

Task 3. Deploy Guestbook Service

In the guestbook-service/pom.xml file, add the following code at the end of the <plugins> section, immediately before the closing </plugins> tag:

<plugin>
  <groupId>com.google.cloud.tools</groupId>
  <artifactId>appengine-maven-plugin</artifactId>
  <version>2.2.0</version>
  <configuration>
    <version>1</version>
    <deploy.projectId>GCLOUD_CONFIG</deploy.projectId>
    </configuration>
</plugin>

Create an App Engine directory in Guestbook Service.

    mkdir -p ~/guestbook-service/src/main/appengine

In the Cloud Shell code editor, create a file named app.yaml in the ~/guestbook-service/src/main/appengine/ directory. This file is required to deploy the application to App Engine.

Add the following code to the app.yaml file.

runtime: java11
service: guestbook-service
instance_class: B4_1G
manual_scaling:
  instances: 2
env_variables:
  SPRING_PROFILES_ACTIVE: cloud

    cd ~/guestbook-service

    ./mvnw package appengine:deploy -DskipTests

Find the deployed backend URL. Click the URL link for the backend guestbook service.

    gcloud app browse -s guestbook-service

End your lab

## Debbuging with Stackdriver Debugger

Task 0. Lab Preparation


In the Cloud Shell command line, enter the following command to create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Click Authorize to authorize Cloud Shell to make API calls. It may take up to 10 minutes for the lab setup to complete and the bucket to be created.

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable. Now you're ready to go!

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Examine Cloud logs

Open a new browser tab and navigate to the Google Cloud console.

Navigate to Operations > Logging > Logs Explorer.

In the Log fields pane, select GAE Application.

In the Log name section, select appengine.googleapis.com/request_log.

The default App Engine application log is displayed. When you output a log message, it is grouped by the request. When the application first starts, the log messages are grouped under /_ah/start request.

Expand an entry to view the detailed log entry.

request log

Task 2. Configure Cloud Debugger

In this task, you configure Cloud Debugger so that it can be used to debug the demo microservices application used in this set of labs. The demo application was automatically deployed to App Engine for you as part of the lab setup.

In the Console menu, navigate to Operations > Debugger.

At the top, the running App Engine deployments are listed.

In the drop-down list, select default - 1 (100%).

select default

default - 1 is the frontend application. The source code is not yet available for debugging.

Click Select Source on the left of the screen to expand it and select Deployed Files.

You can provide source code to Cloud Debugger in several ways.

19112fddd4a55750.png

Select Add source code in the Deployed Files drop-down list.

A list of methods for providing source code is displayed. In this lab, you will add the source code to the Google Source Repositories service.

Switch to Cloud Shell and enable the Google Cloud Source Repository API.

gcloud services enable sourcerepo.googleapis.com

Create a source repository for source capture.

gcloud source repos create google-source-captures
Note: You might get a warning that you may be billed for this repository. You can safely ignore this warning since you are using a QwikLabs account.
Change to the frontend application directory.

cd ~/guestbook-frontend
Configure the git email and username properties.

These properties are used for the code upload.

git config --global user.email $(gcloud config get-value core/account)
git config --global user.name "devstar"

Clone the empty google-source-captures repository.

gcloud source repos clone google-source-captures --project=$PROJECT_ID
The repository has been created at ~/guestbook-frontend/google-source-captures.

Copy the source files into the local repository directory.

cd google-source-captures
cp -rip ../src/* .
Commit the source files to the Cloud Source Repository.

git add .
git commit -m "initial commit"
git push -u origin master
Task 3. Use Cloud Debugger to debug an application
In this task, you use Cloud Debugger to debug the demo application running on App Engine.

Return to the Cloud Debugger console and click Select source for Cloud Source Repositories.

You should see the master branch in the google-source-captures repository that you created.

cloud-source-branch

Click Select Source.

In the left menu under cloud repository:/, navigate to and open main/java/com/example/frontend/FrontendController.java.

frontendcontroller

From here, you have a significant amount of control. For example, you can add a log message.

On the right side of the window, click Logpoint.

In the source, click the line number where you want to add a log message, and edit the message to print the text and variables that you want to see.

In this example, the message is changed to print the text Variable name =, followed by the value of the local variable name.

enter logpoint

Click Add. You can add as many log messages as you want.

update map

Open the Guestbook application tab in your browser. You can retrieve the link to your app by executing the following command in the Cloud Shell:

gcloud app browse
In the application, enter a name and message to trigger the code.

Return to the Logs Viewer: Operations > Logging > Logs Explorer.

Click on the Log name dropdown in the Query builder pane and select spring.log in the list of log files:

spring log

Click Add.

Click Run Query.

Find the LOGPOINT messaage and expand it. This message should be close to the end and highlighted with a blue information button:

logpoint log

Return to Debugger: Operations > Debugger.

In the source view on the right side, click Snapshot.

Snapshot allows you to capture the stack in a moment in time. It is almost like stepping through a real debugger, but it does not stop the application for your users.

In the source, click the line number where you want to capture information.

snapshot

Switch to the demo application and post another guestbook message.

As soon as a request flows through the line, the Call Stack is captured, and you can explore the internal state of the application at that point in time. You can add conditionals to both logpoints and snapshots, so that you view only certain requests based on variables that are in scope (for example, session ID).

call-stack1

Note: Cloud Debugger works with various languages, and also outside of App Engine. You can also debug your application in the same way when you deploy your application on-premises, in a VM, or in containers.
Task 4. Enable Cloud Monitoring
Create a Monitoring workspace
You will now setup a Monitoring workspace that's tied to your Qwiklabs GCP Project. The following steps create a new account that has a free trial of Monitoring.

In the Google Cloud Platform Console, click on Navigation menu > Monitoring.

Wait for your workspace to be provisioned.

When the Monitoring dashboard opens, your workspace is ready.

Overview.png

Navigate to Dashboards. Click App Engine and select your App Engine service under Projects.

After a minute or two, an overview dashboard of your App Engine services appears. You might have to refresh the page.

## Working with Cloud spanner

Task 0. Lab Preparation

Open Google Console

In the Cloud Shell command line, enter the following command to create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable.

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Check that the frontend application is running. You can find the URL of the frontend application that should now be running on App Engine via the following command:

    gcloud app browse

Task 1. Enable Cloud Spanner API

Switch back to the Cloud Shell and enable the Cloud Spanner API.

    gcloud services enable spanner.googleapis.com

Task 2. Create a new Cloud Spanner instance

Create a Cloud Spanner instance.

    gcloud spanner instances create guestbook --config=regional-us-central1 \
  --nodes=1 --description="Guestbook messages"

Create a messages database in the Cloud Spanner instance.

    gcloud spanner databases create messages --instance=guestbook

Confirm that the database exists by listing the databases of the Cloud Spanner instance.

    gcloud spanner databases list --instance=guestbook

Create a table in the Cloud Spanner database
You create a table in the messages database by creating a file that contains a DDL statement and then running the command.

In the guestbook-service folder, create the db folder.

    cd ~/guestbook-service
    mkdir db

In the Cloud Shell code editor, create a file named spanner.ddl in the ~/guestbook-service/db/ directory.

Add the following command to the spanner.ddl file:

CREATE TABLE guestbook_message (
    id STRING(36) NOT NULL,
    name STRING(255) NOT NULL,
    image_uri STRING(255),
    message STRING(255)
) PRIMARY KEY (id)

In the Cloud Shell use gcloud to run the DDL command to create the table.

    gcloud spanner databases ddl update messages \
  --instance=guestbook --ddl-file=$HOME/guestbook-service/db/spanner.ddl

In the Google Cloud console, use the navigation menu to navigate to Spanner in the Databases section.

Task 3. Add Spring Cloud GCP Cloud Spanner Starter

Switch back to the tab running the Cloud Shell code editor.

In the editor, open ~/guestbook-service/pom.xml.

Delete the Spring Data JPA by removing these lines:

<dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
Delete the Cloud SQL Starter by removing these lines:

<dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-gcp-starter-sql-mysql</artifactId>
</dependency>

Delete HSQL by removing these lines:

<dependency>
        <groupId>org.hsqldb</groupId>
        <artifactId>hsqldb</artifactId>
        <scope>runtime</scope>
</dependency>

Now, add the following code at the end of the <dependencies> section, immediately before the closing </dependencies> tag:

<dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-gcp-starter-data-spanner</artifactId>
</dependency>

Task 4. Update configuration

In the editor, open guestbook-service/src/main/resources/application.properties. Delete the two Cloud SQL Configuration lines and add the following Spanner configuration:

# Add Spanner configuration
spring.cloud.gcp.spanner.instance-id=guestbook
spring.cloud.gcp.spanner.database=messages

Next, open guestbook-service/src/main/resources/application-cloud.properties and remove the following Spring properties for Cloud SQL:

spring.cloud.gcp.sql.enabled=true
spring.cloud.gcp.sql.database-name=messages
spring.cloud.gcp.sql.instance-connection-name=...

Task 5. Update the backend service to use Cloud Spanner

In this task, you modify GuestbookMessage.java to use the Cloud Spanner annotations.

In the Cloud Shell code editor, open guestbook-service/src/main/java/com/example/guestbook/GuestbookMessage.java.

Replace the entire contents of this file with the following code:

package com.example.guestbook;

import lombok.*;
import org.springframework.cloud.gcp.data.spanner.core.mapping.*;
import org.springframework.data.annotation.Id;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Data
@Table(name = "guestbook_message")
@JsonIgnoreProperties(value={"id"}, allowSetters = false)
public class GuestbookMessage {
	@PrimaryKey
	@Id
	private String id;

	private String name;

	private String message;

	@Column(name = "image_uri")
	private String imageUri;

	public GuestbookMessage() {
		this.id = java.util.UUID.randomUUID().toString();
	}
}

Task 6. Add a method to find messages by name

One example is a simple method signature: List<GuestbookMessage> findByName(String name);. The Spring framework enables querying the Cloud Spanner table with the SQL query SELECT * FROM guestbook_message WHERE name = ?.

In this task, you update the GuestbookMessageRepository.java file to use String as the ID type.

In the Cloud Shell code editor, open guestbook-service/src/main/java/com/example/guestbook/GuestbookMessageRepository.java.

Insert the following import statement below the existing import directives:

import java.util.List;
Change the datatype for the PagingAndSortingRepository GuestbookMessage parameter from Long to String.

public interface GuestbookMessageRepository extends
        PagingAndSortingRepository<GuestbookMessage, String> {
}
Insert the following code into the definition for the GuestbookMessageRepository public interface, immediately before the closing brace:

List<GuestbookMessage> findByName(String name);
The GuestbookMessageRepository.java file should now look like the screenshot: ed26584630fa01b1.png

Task 7. Test the backend service application locally in Cloud Shell
In this task, you run the updated guestbook backend service application in Cloud Shell in order to test that the application has been correctly configured to use Cloud Spanner for database services.

In the Cloud Shell change to the guestbook-service directory.

cd ~/guestbook-service
Launch the guestbook backend service application locally:

./mvnw spring-boot:run
In a new Cloud Shell tab, use curl to post a message.

curl -XPOST -H "content-type: application/json" \
  -d '{"name": "Ray", "message": "Hello Cloud Spanner"}' \
  http://localhost:8081/guestbookMessages
List all the messages.

curl http://localhost:8081/guestbookMessages
List specific messages using the custom findByName() search you added above.

curl http://localhost:8081/guestbookMessages/search/findByName?name=Ray
Use the gcloud spanner command with a SQL query to validate that messages exist.

gcloud spanner databases execute-sql messages --instance=guestbook \
    --sql="SELECT * FROM guestbook_message WHERE name = 'Ray'"
Switch back to the the Google Cloud Platform console and navigate to your Spanner guestbook_message database to see the new entry.
8c4e6de1a26230ae.png

Click Query on top of the page and then click Run query, with the default SELECT query.
2c33c99fb5a7e2e3.png

Task 8. Redeploy the backend service application to App Engine
In this task, you redeploy the updated guestbook backend service application to App Engine.

Switch back to the Cloud Shell tab where the guestbook backend service application is running.

Press CTRL+C to stop the application.

Make sure you are in the guestbook-service directory.

cd ~/guestbook-service
Use Apache Maven to rebuild the backend service application redeploy it to App Engine.

mvn package appengine:deploy -DskipTests
When the deployment completes, the output from Maven provides the URL of the updated backend service application.

...
[INFO] GCLOUD: Deployed service [guestbook-service] to [https://guestbook-service-dot-PROJECT_ID.appspot.com]
[INFO] GCLOUD:
[INFO] GCLOUD: You can stream logs from the command line by running:
[INFO] GCLOUD:   $ gcloud app logs tail -s guestbook-service
[INFO] GCLOUD:
[INFO] GCLOUD: To view your application in the web browser run:
[INFO] GCLOUD:   $ gcloud app browse -s guestbook-service
...
Use the following command to list the URLfor the updated backend service application.

gcloud app browse -s guestbook-service
A clickable URL link to your new backend service appears.

Did not detect your browser. Go to this link to view your app:
https://guestbook-service-dot-....appspot.com
Click the URL link to open the backend guestbook service.
The response lists all the messages in the Cloud Spanner database.

Switch back to the browser tab for the frontend application.
Note: If you have closed that tab, use the following command to list the URL for the guestbook frontend application that is running on App Engine:gcloud app browse -s default. Then click the link to browse to the guestbook frontend application.
Enter a message to test that the application is working.
You should now see an updated message list that includes the initial test message you sent from the Cloud Shell and the new message you just posted confirming that the updated backend service application is using the new Cloud Spanner database.

## Deploying to Google Kubernetes Engine

Task 0. Lab Preparation
Access Qwiklabs

In the Cloud Shell command line, enter the following command to create an environment variable that contains the project ID for this lab:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

Verify that the demo application files were created.

    gsutil ls gs://$PROJECT_ID

Copy the application folders to Cloud Shell.

    gsutil -m cp -r gs://$PROJECT_ID/* ~/

Make the Maven wrapper scripts executable.

    chmod +x ~/guestbook-frontend/mvnw
    chmod +x ~/guestbook-service/mvnw

Task 1. Create a Kubernetes Engine cluster

In the Cloud Shell enable Kubernetes Engine API.

    gcloud services enable container.googleapis.com

Create a Kubernetes Engine cluster that has Cloud Logging and Monitoring enabled. 

    gcloud container clusters create guestbook-cluster \
    --zone=us-central1-a \
    --num-nodes=2 \
    --machine-type=n1-standard-2 \
    --enable-autorepair \
    --enable-stackdriver-kubernetes

Check the Kubernetes server version to verify that the Kubernetes Engine cluster you deployed has been created:

    kubectl version

Task 2. Containerize the applications

In a new Cloud Shell tab enable Container Registry API.

    gcloud services enable containerregistry.googleapis.com

Run the following command to set and display the PROJECT_ID environment variable:

    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
    echo $PROJECT_ID

Make a note of this project ID. In a number of later steps, you replace [PROJECT_ID] placeholders with this project ID.

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Insert a new plugin definition for the Jib Maven plugin into the <plugins> section inside the <build> section near the end of the file, immediately before the closing </plugins> tag.

            <plugin>
                <groupId>com.google.cloud.tools</groupId>
                <artifactId>jib-maven-plugin</artifactId>
                <version>2.4.0</version>
                <configuration>
                    <to>
                    <!-- Replace [PROJECT_ID]! -->
                    <image>gcr.io/[PROJECT_ID]/guestbook-frontend</image>
                    </to>
                </configuration>
            </plugin>

In the Cloud Shell change to the frontend application directory.

cd ~/guestbook-frontend

Use Maven to build the frontend application container using the Jib plugin.

./mvnw clean compile jib:build

When the build completes, it reports success and the location of the container image in the Google gcr.io container registry.

...
[INFO] Built and pushed image as gcr.io/next18-bootcamp-test/spring-cloud-gcp-guestbook-frontend
[INFO]
[INFO] -------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] -------------------------------------------------
[INFO] Total time: 43.730 s
[INFO] Finished at: 2018-07-16T16:07:34-04:00
[INFO] -------------------------------------------------
In the Cloud Shell code editor, open ~/guestbook-service/pom.xml.

Insert a new plugin definition for the Jib Maven plugin into the <plugins> section inside the <build> section near the end of the file, immediately before the closing </plugins> tag.

            <plugin>
                <groupId>com.google.cloud.tools</groupId>
                <artifactId>jib-maven-plugin</artifactId>
                <version>2.4.0</version>
                <configuration>
                    <to>
                    <!-- Replace [PROJECT_ID]! -->
                    <image>gcr.io/[PROJECT_ID]/guestbook-service</image>
                    </to>
                </configuration>
            </plugin>

In the Cloud Shell change to the guestbook backend service application directory.

    cd ~/guestbook-service

Use Maven to build the build the backend service application container using the Jib plugin.

    ./mvnw clean compile jib:build

When the build completes, it reports success and the location of the container image for the backend service.

[INFO] Built and pushed image as gcr.io/qwiklabs-gcp-0a13bb9f8b1a92a2/guestbook-service
[INFO]
[INFO] -----------------------------------------------
[INFO] BUILD SUCCESS
[INFO] -----------------------------------------------
[INFO] Total time: 35.766 s
[INFO] Finished at: 2018-12-09T13:41:02Z
[INFO] -----------------------------------------------

Task 3. Set up a service account

In this task, you create a service account with permissions to access your GCP services. You then store the service account that you generated earlier in Kubernetes as a secret so that it is accessible from the containers.

In Cloud Shell enter the following commands to create a service account specific to the guestbook application.

    gcloud iam service-accounts create guestbook

Add the Editor role for your project to this service account.

    gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:guestbook@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/editor

Generate the JSON key file to be used by the application to identify itself using the service account.

    gcloud iam service-accounts keys create \
    ~/service-account.json \
    --iam-account guestbook@${PROJECT_ID}.iam.gserviceaccount.com

This command creates service account credentials that are stored in the $HOME/service-account.json file.

Create the secret using the service account credential file.

    kubectl create secret generic guestbook-service-account \
  --from-file=$HOME/service-account.json
Verify that the service account is stored.

    kubectl describe secret guestbook-service-account

The output should be similar to the following:

Name:         guestbook-service-account
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
service-account.json:  ... bytes

Task 4. Deploy the containers

In the Cloud Shell code editor, open ~/kubernetes/guestbook-frontend-deployment.yaml.
Note

A basic Kubernetes deployment file has been created for you for each of your applications. These are a standard feature used to configure containerized application deployments for Kubernetes but the full detail is out of scope for this course. For this lab you will only update the guestbook Kubernetes deployment files to use the images that you created.

Replace the line image: saturnism/spring-gcp-guestbook-frontend:latest with the line image: gcr.io/[PROJECT_ID]/guestbook-frontend:latest below the line specifying the container name.
Note

You must replace [PROJECT_ID] with the project ID that you recorded in an earlier task. Spaces are significant in YAML files so make sure your new line matches the indentation of the line it replaces exactly.

In the Cloud Shell code editor, open ~/kubernetes/guestbook-service-deployment.yaml.
Replace the line image: saturnism/spring-gcp-guestbook-service:latest with the line image: gcr.io/[PROJECT_ID]/guestbook-service:latest below the line specifying the container name.
Note

You must replace [PROJECT_ID] with the project ID that you recorded in an earlier task.

Switch back to the Cloud Shell and deploy the updated Kubernetes deployments.

kubectl apply -f ~/kubernetes/
The Kubernetes configuration for your guestbook frontend application is configured to deploy an external load balancer. The configuration used in the sample deployment generates a load balanced external IP address for the frontend application

Check to see that all pods are up and running. You can use CTRL + C to terminate the process.

 watch kubectl get pods
Guestbook Frontend is configured to deploy an external Load Balancer. It'll generate an external IP address that does L4 Load Balancing to your backend. Check and wait until the external IP is populated.

kubectl get svc guestbook-frontend
You can repeat the command every minute or so until the EXTERNAL-IP address is listed.

NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)  AGE
guestbook-frontend   LoadBalancer   ...           23.251.156.216  ...      ...
Check the status of all of the services running on your Kubernetes Engine cluster.

kubectl get svc
You see that only the frontend application has an external ip address.

Open a browser and navigate to the application at http://[EXTERNAL_IP]:8080.
Post a message to test the functionality of the application running on Kubernetes Engine.


## Monitoring Google Kubernetes Engine with Prometheus

Task 0. Lab Preparation
Access Qwiklabs
How to start your lab and sign in to the Console
Click the Start Lab button. If you need to pay for the lab, a pop-up opens for you to select your payment method. On the left is a panel populated with the temporary credentials that you must use for this lab.

Open Google Console

Copy the username, and then click Open Google Console. The lab spins up resources, and then opens another tab that shows the Choose an account page.

Tip: Open the tabs in separate windows, side-by-side.

On the Choose an account page, click Use Another Account.

Choose an account

The Sign in page opens. Paste the username that you copied from the Connection Details panel. Then copy and paste the password.

Important: You must use the credentials from the Connection Details panel. Do not use your Qwiklabs credentials. If you have your own GCP account, do not use it for this lab (avoids incurring charges).

Click through the subsequent pages:

Accept the terms and conditions.
Do not add recovery options or two-factor authentication (because this is a temporary account).
Do not sign up for free trials.
After a few moments, the GCP console opens in this tab.

Note: You can view the menu with a list of GCP Products and Services by clicking the Navigation menu at the top-left, next to “Google Cloud Platform”. Cloud Console Menu
After you complete the initial sign-in steps, the project dashboard appears.

79f19e6d9365880d.png

Fetch the application source files
To begin the lab, click the Activate Cloud Shell button at the top of the Google Cloud Console. To activate the code editor, click the Open Editor button on the toolbar of the Cloud Shell window. This sets up the editor in a new tab with continued access to Cloud Shell.

Note: the lab setup includes automated deployment of the services that you configured yourself in previous labs. When the setup is complete, copies of the demo application (configured so that they are ready for this lab session) are put into a Cloud Storage bucket named using the project ID for this lab.
In the Cloud Shell command line, enter the following command to create an environment variable that contains the project ID for this lab:

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
Verify that the demo application files were created.

gsutil ls gs://$PROJECT_ID
If you get a BucketNotFound error, this means that the lab's deployment script has not finished yet. You will need to wait for the DM template to complete before proceeding. This usually takes around 10 minutes upon starting the lab. Please wait a few minutes then retry.
Copy the application folders to Cloud Shell.

gsutil -m cp -r gs://$PROJECT_ID/* ~/
Make the Maven wrapper scripts executable.

chmod +x ~/guestbook-frontend/mvnw
chmod +x ~/guestbook-service/mvnw
Task 1. Enable Cloud Monitoring and view the Cloud Kubernetes Monitoring dashboard
Create a Monitoring workspace
You will now setup a Monitoring workspace that's tied to your Qwiklabs GCP Project. The following steps create a new account that has a free trial of Monitoring.

In the Google Cloud Platform Console, click on Navigation menu > Monitoring.

Wait for your workspace to be provisioned.

When the Monitoring dashboard opens, your workspace is ready.

Overview.png

Click Dashboards and select GKE to view the Kubernetes monitoring dashboard. Click guestbook-cluster.
You may need to wait for a few minutes for the Kubernetes Engine cluster and its resources to become visible to Cloud Monitoring.

monitoring_ui.png

Task 2. Expose Prometheus metrics from Spring Boot applications
Spring Boot can expose metrics information through Spring Boot Actuator. Micrometer is the metrics collection facility included in Spring Boot Actuator. Micrometer can expose all the metrics using the Prometheus format.

If you are not using Spring Boot, you can expose JMX metrics through Prometheus by using a Prometheus JMX Exporter agent.

In this task, you add the Spring Boot Actuator starter and Micrometer dependencies to the guestbook frontend application.

In the Cloud Shell code editor, open ~/guestbook-frontend/pom.xml.

Insert the following new dependencies at the end of the <dependencies> section, just before the closing </dependencies> tag.

        <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
             <groupId>io.micrometer</groupId>
             <artifactId>micrometer-registry-prometheus</artifactId>
             <scope>runtime</scope>
        </dependency>
In the Cloud Shell code editor, open ~/guestbook-frontend/src/main/resources/application.properties.

Add the following two properties to configure Spring Boot Actuator to expose metrics on port 9000.

management.server.port=9000
management.endpoints.web.exposure.include=*
To send log entries to Stackdriver Logging, via STDOUT and structured JSON logging, change guestbook-frontend/src/main/resources/logback-spring.xml to use the CONSOLE_JSON appender. Copy and replace the entire contents of the file with the following code:

<configuration>
    <include resource="org/springframework/boot/logging/logback/defaults.xml" />
    <include resource="org/springframework/boot/logging/logback/console-appender.xml" />

    <springProfile name="cloud">
        <include resource="org/springframework/cloud/gcp/logging/logback-json-appender.xml"/>
        <root level="INFO">
            <appender-ref ref="CONSOLE_JSON"/>
        </root>
    </springProfile>
    <springProfile name="default">
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>
</configuration>
Task 3. Rebuild the containers
In this task you rebuild the containers and configure the frontend contaner deployment to expose the prometheus monitoring endpoint.

In the Cloud Shell change to the frontend application directory.

cd ~/guestbook-frontend
Build the frontend application container.

./mvnw clean compile jib:build
While this is compiling switch back to the Cloud Shell code editor and open ~/kustomize/base/guestbook-frontend-deployment.yaml.
You update the Kubernetes deployment to specify the Prometheus metrics endpoint. With this configuration, Spring Boot Actuator exposes the Prometheus metrics on port 9000, under the path of /actuator/prometheus.

Update the Kubernetes manifest to declare the metrics ports. You will be putting this under the kind: Deployment in the containers section.

        - name: metrics
          containerPort: 9000
The guestbook-frontend-deployment.yaml file should now look like the following screenshot:

guestbook-frontend-deployment.png

Note: Whitespace is significant in YAML file layouts. The layout of the changes you make must match the screenshot.
When the frontend application build has completed in the Cloud Shell change to the guestbook backend service application directory.

cd ~/guestbook-service
Build the guestbook backend service application container.

./mvnw clean compile jib:build
Note: You haven't made any changes to the backend service application but you have to build the image so that it is available on the gcr.io container repository for the lab when you deploy the full application.
Redeploy the manifest:

mkdir -p ~/bin
cd ~/bin
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
export PATH=$PATH:$HOME/bin
cd ~/kustomize/base
cp ~/service-account.json ~/kustomize/base
kustomize build
gcloud container clusters get-credentials guestbook-cluster --zone=us-central1-a
kustomize edit set namespace default
kustomize build | kubectl apply -f -
Wait for the pods to restart. Find the pod name for one of the instances.

kubectl get pods -l app=guestbook-frontend
You should see something like the following:

NAME                                  READY     STATUS    RESTARTS   AGE
guestbook-frontend-8567fdc8c8-c68vk   1/1       Running   0          5m
guestbook-frontend-8567fdc8c8-gvcf5   1/1       Running   0          5m
Establish a port forward to one of the Guestbook Frontend pod. Replacing [podnumber] with one of the ID's of the pods you received from the previous command:

kubectl port-forward guestbook-frontend-[podnumber] 9000:9000
Task 4. Install Prometheus and Stackdriver Sidecar
Stackdriver Kubernetes Monitoring can monitor Prometheus metrics from the Kubernetes cluster. Install Prometheus support to the cluster.

In a new Cloud Shell tab, install a quickstart Prometheus operator.

gcloud container clusters get-credentials guestbook-cluster --zone=us-central1-a
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/v0.38.1/bundle.yaml
Provision Prometheus using the Prometheus Operator.

cd ~/prometheus
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

# Make sure the project ID is set
echo $PROJECT_ID
cat prometheus.yaml | envsubst | kubectl apply -f -
kubectl apply -f pod-monitors.yaml
The prometheus.yaml file has an additional Stackdriver Sidecar that's designed to export the scraped Prometheus metrics to Stackdriver.
Validate Prometheus is running properly and scraping the data. Establish a port forward to Prometheus' port.

pkill java
kubectl port-forward svc/prometheus 9090:9090
Click Web Preview in the Cloud Shell, then click Preview on port 8080. It should open up a new page.
change-port-1.png

Now, in the URL, change the beginning of the line from 8080 to 9090 and refresh the page. Your URL should now look something like: https://9090-dot-12909153-dot-devshell.appspot.com/graph.

In the Prometheus console, select Status → Targets.

Observe that there are 2 targets (2 pods) being scraped for metrics.

targets.png

Task 5. Explore the metrics
In the Google Cloud Console, navigate to the Operations > Monitoring.

Click Metrics Explorer.

In the Metrics Explorer, search for jvm_memory to find metrics collected by the Prometheus agent from the Spring Boot application.

6c8a8ce85a01abea.png

It may take a few minutes for the Prometheus metrics to show up in the Metrics Explorer.
Select jvm_memory_used_bytes to plot the metrics. For Resource Type, select Kubernetes Container.

The JVM memory has multiple dimensions (for example, Heap versus Non-Heap and Eden Space versus Metaspace).

In Filter, filter by area, setting the value to heap, and in Group By, select pod_name, and in Aggregator, select sum.

These options build a graph of current heap usage of the frontend application.

metric_explorer.png

End your lab

## Final Quiz