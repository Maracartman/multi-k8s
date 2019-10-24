CLIENT_VERSION=$(jq -r .version  ./client/package.json) #Para probar: tagear versiones con
SERVER_VERSION=$(jq -r .version  ./server/package.json) #package Json para versionamiento semantico
WORKER_VERSION=$(jq -r .version  ./worker/package.json)
docker build -t maracartman/multi-client:latest -t maracartman/multi-client:$CLIENT_VERSION -t maracartman/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t maracartman/multi-server:latest -t maracartman/multi-server:$SERVER_VERSION -t maracartman/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t maracartman/multi-worker:latest -t maracartman/multi-worker:$WORKER_VERSION -t maracartman/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push maracartman/multi-client:latest #Generar la version latest de forma dinamica
docker push maracartman/multi-server:latest
docker push maracartman/multi-worker:latest
docker push maracartman/multi-client:$SHA #toma la variable global definida en .travis.yml y lo inyecta
docker push maracartman/multi-server:$SHA #OJO está usando el SHA de GIT (considerar opcion version por package)
docker push maracartman/multi-worker:$SHA
docker push maracartman/multi-client:$CLIENT_VERSION #Caso con versiones de package.json
docker push maracartman/multi-server:$SERVER_VERSION
docker push maracartman/multi-worker:$WORKER_VERSION
kubectl apply -f k8s
#Probar con las versiones
#kubectl set image deployments/client-deployment web=maracartman/multi-client:$SHA
#kubectl set image deployments/server-deployment server=maracartman/multi-server:$SHA
#kubectl set image deployments/worker-deployment worker=maracartman/multi-worker:$SHA
kubectl set image deployments/server-deployment server=maracartman/multi-server:$SERVER_VERSION
kubectl set image deployments/worker-deployment worker=maracartman/multi-worker:$WORKER_VERSION
kubectl set image deployments/client-deployment web=maracartman/multi-client:$CLIENT_VERSION