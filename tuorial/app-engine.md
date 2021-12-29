# Lab: Developing SLOs and SLIs

SRE
----

# App Engine 

---

# Lab: Alert and Policies

1) Download the Code	

	git clone https://github.com/GoogleCloudPlatform/training-data-analyst.git

	cd ~/training-data-analyst/courses/design-process/deploying-apps-to-gcp

Edit the Source code

	edit main.py

 Run the application

	sudo pip3 install -r requirements.txt
	python3 main.py

2) Deploy App

	vi app.yaml

		runtime: python37


	gcloud app create --region=us-central

	gcloud app deploy --version=one --quiet
	

3) Check logs

	ON Web Console go to

	App Engine > Versions > Diagnose > Logs

4) Create an App Engine latency alert

Go to 

	Monitoring > Metrics Explorer


---
# Lab: Service Monitoring

Task 1

git clone https://github.com/haggman/HelloLoggingNodeJS.git

cd HelloLoggingNodeJS
edit index.js

gcloud app create --region=us-central
gcloud app deploy


Task 2

while true; \
do curl -s https://$DEVSHELL_PROJECT_ID.appspot.com/random-error \
-w '\n' ;sleep .1s;done

---
# Lab: Monitoring and Dashboarding Multiple Projects from a Single Workspace

Objectives
Configure a Worker project.

Create a Monitoring Workspace and link the two worker projects into it.

Create and configure Monitoring Groups.

Create and test an uptime check.

sudo apt-get update
sudo apt-get install apache2-utils

URL=http://[worker-1-server-vm ip]

ab -n 100000 -c 100 $URL/

---

# Lab - Compute Logging and Monitoring

In this task, you:

Set up a VM running Nginx.

Create a GKE cluster.



Install Nginx
Switch back to Compute Engine and SSH in to the web-server-vm.

Use APT to install Nginx.

sudo apt-get update
sudo apt-get install nginx
Copied!
Verify that Nginx installed and is running.

sudo nginx -v
Copied!
Switch back to Compute Engine and if you enabled the HTTP access firewall rule, then you should be able to click the external IP. Do so and make sure the Nginx server is up and running. Copy the URL to the server.

Change to the Cloud Shell terminal window. Create a URL environmental variable and set it equal to the URL to your server.

URL=URL_to_your_server
Copied!
Use a bash while loop to place some load on the server. Make sure you are seeing the Welcome to nginx responses.

while true; do curl -s $URL | grep -oP "<title>.*</title>"; \
sleep .1s;done


--- 
# Lab: Log Analysis

gcloud services enable cloudbuild.googleapis.com \
run.googleapis.com \
compute.googleapis.com \
cloudprofiler.googleapis.com

git clone https://github.com/haggman/HelloLoggingNodeJS.git

cd HelloLoggingNodeJS
edit index.js

sh rebuildService.sh

URL=url_you_copied_here
echo $URL
while true; \
do curl -s $URL/random-error \
-w '\n' ;sleep .1s;done

Task 2. Explore the log files for a test application



//Basic NodeJS app built with the express server
app.get('/score', (req, res) => {
  //Random score, the contaierID is a UUID unique to each
  //runtime container (testing was done in Cloud Run).
  //funFactor is a random number 1-100
  let score = Math.floor(Math.random() * 100) + 1;
    let output = {
      message:  '/score called',
      score:    score,
      containerID: containerID,
      funFactor: funFactor
  };
  console.log(JSON.stringify(output));
  //Basic message back to browser
  res.send(`Your score is a ${score}. Happy?`);
});

cd ~/HelloLoggingNodeJS/
npm i
npm start

sh rebuildService.sh
while true; \
do curl -s $URL/score \
-w '\n' ;sleep .1s;done


while true; \
do curl -s $URL/random-error \
-w '\n' ;sleep .1s;done

SELECT
  textPayload
FROM
  `[project-id].hello_logging_logs.run_googleapis_com_stderr_[date]`
WHERE
  textPayload LIKE 'ReferenceError%'

SELECT
  count(textPayload)
FROM
  `[project-id].hello_logging_logs.run_googleapis_com_stderr_[date]`
WHERE
  textPayload LIKE 'ReferenceError%'


SELECT
  errors / total_requests
FROM (
  SELECT
    (
    SELECT
      COUNT(*)
    FROM
      `[project-id].hello_logging_logs.run_googleapis_com_requests_[date]`) AS total_requests,
    (
    SELECT
      COUNT(textPayload)
    FROM
      `[project-id].hello_logging_logs.run_googleapis_com_stderr_[date]`
    WHERE
      textPayload LIKE 'ReferenceError%') AS errors)


---

# LAB - Application Performance Management

gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable run.googleapis.com

cd ~/
git clone https://github.com/haggman/HelloLoggingNodeJS.git

cd ~/HelloLoggingNodeJS
sh rebuildService.sh

git clone https://github.com/haggman/gcp-debugging
cd ~/HelloLoggingNodeJS/gcp-debugging
sudo pip3 install -r requirements.txt
python3 main.py


Deploy the converter application to App Engine

gcloud app create --region=us-central
gcloud app deploy --version=one --quiet
