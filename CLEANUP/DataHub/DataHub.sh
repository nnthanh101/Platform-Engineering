echo " ..."
kubectl create secret generic mysql-secrets --from-literal=mysql-root-password=datahub
kubectl create secret generic neo4j-secrets --from-literal=neo4j-password=datahub

echo " ..."
helm repo add datahub https://helm.datahubproject.io/

echo " ..."
# helm install prerequisites datahub/datahub-prerequisites

helm install prerequisites datahub/datahub-prerequisites --values dynamic

echo "WIP"

helm init --history-max 2 --upgrade --wait