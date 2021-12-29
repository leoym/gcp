Alertas

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

	Monitoring > Metrics Explorerr

