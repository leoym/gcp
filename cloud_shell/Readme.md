# Working with Cloud Shell

## Learning Kubernetes with minikube

  # Starting minikube
  
  $ minikube start
  
  $ alias k=kubectl
  
  $ k get nodes
  
  $ k get pods
  
  $ k get po -A
  
  $ k get po -all-namespaces
  
  $ k get po --all-namespaces
  
  
  # Creating Pods
  
  $ kubectl run nginx
  
  $ kubectl run nginx --image nginx
  
  $ k get pod
  
  $ k run nginx --image nginx
 
  $ k describe po nginx
  
  $ k logs
  
  $ k logs nginx
  
  $ k logs -f nginx
  
  $ kubectl port-forward nginx 8080:80
  
  $ k delete pod nginx

----

## References:

  https://kubernetes.io/
  
  https://kubernetes.io/search/?q=forward
  
  https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
    
  https://hub.docker.com/_/nginx
  
  
  
