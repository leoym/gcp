Alertas

Download the Code	

	git clone https://github.com/GoogleCloudPlatform/training-data-analyst.git

	cd ~/training-data-analyst/courses/design-process/deploying-apps-to-gcp

Edit the Source code

	edit main.py

Run the application

	sudo pip3 install -r requirements.txt
	python3 main.py

Deploy App

	vi app.yaml

		runtime: python37



		Check logs

gcloud app create --region=us-central4

gcloud app deploy --version=one --quiet


