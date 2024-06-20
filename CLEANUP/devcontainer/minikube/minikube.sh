nohup bash -c 'minikube start &' > minikube.log 2>&1

echo "Deleting minikube cluster (use –all to delete all clusters) !!!"
minikube delete --profile=minikube

minikube start --profile=minikube --driver=docker --nodes 2
sleep 30

minikube kubectl get nodes
minikube status

echo "Checking kubectl version ..."
kubectl version --client --output=yaml

echo "Checking cluster info using kubectl ..."
kubectl cluster-info

echo "Getting kubectl config ..."
kubectl config view

echo "Changing default context for kubectl command ..."
kubectl config use-context minikube
# kubectl config set-context minikube

echo "Listing all pods on a specific namespace (use -A for all namespaces) ..."
# kubectl get po -A
kubectl get pods -n kube-system

echo "Getting all namespaces ..."
kubectl get namespace

echo "Viewing minikube kebernetes dashboard !!!"
# minikube dashboard

### WIP ###
# minikube addons enable ingress
# # Run this to forward to localhost in the background
# nohup kubectl port-forward --pod-running-timeout=24h -n ingress-nginx service/ingress-nginx-controller :80 &

echo "===== Deploy a service to multi-node clusters on minikube ====="
# minikube start --driver=docker --nodes 2 -p minikube

echo "Deploying the K8s deployment ..."
kubectl apply -f k8s-deployment.yaml
kubectl rollout status deployment/hello
sleep 15

echo "Deploying the K8s service ..."
kubectl apply -f k8s-svc.yaml

echo "[x] Check out the IP addresses of our pods, to note for future reference"
kubectl get pods -o wide

echo "[x] Looking at our service, to know what URL to hit"
minikube service list

echo "[x] Hitting the URL a few times and see what comes back"
curl http://192.168.49.2:31000
