# Creating a static site with nginx
 
  mkdir images
  cd images/
  ls
  web-nginx
  mkdir nginx
  cd nginx/
  ls
  vi Dockerfile
  mkdir html
  vi html/index.html
  docker build -t web-nginx .
  docker run -p 8080:80 web-nginx
  docker ps -a
  docker images
  docker images
  docker login
  docker tag web-nginx  leoym/web-nginx
  docker push leoym/web-nginx
  docker images
