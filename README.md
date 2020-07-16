# java-to-k8s

# Java Work

## Build the application
```
mvn package
```

## Start the application
```
java -jar target/java-to-k8s-0.1.0.jar
```

## Create a docker image
```
docker build -t grenader/java-to-k8s .
```

## Alternative. Build docker image with Maven
```
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=grenader/java-to-k8s-mvn
```

## Run docker manually:
```
docker run -p 8080:8080 grenader/java-to-k8s
```

## Tag and Push docker images to Docker Hub 
```
docker tag grenader/java-to-k8s grenader/java-to-k8s:2020Jul2
docker push grenader/java-to-k8s:2020Jul2
```

# Deploy to Kubernetes 

## Run the image on Kubernetes
```
k run javak8s --image=grenader/java-to-k8s:2020Jul2 --requests=cpu=0.2,memory=500Mi --limits=cpu=0.3,memory=600Mi --port=8080
```

## Check the POD status
```
k get po
```

## Expose the application via LoadBalancer
```
k expose pod javak8s --port=88 --target-port=8080 --type=LoadBalancer --name=lb-javak8s
```
The application will be exposed externally on port 88

## Check service (LoadBalancer) status and wait for External Ip-Address. 
```
k get svc
```

## View the application in a browser:
http://lb-javak8s-scdc1-staging-grenader.svc-stage.eng.vmware.com:88/
http://lb-javak8s-1-scdc1-staging-grenader.svc-stage.eng.vmware.com/

# References

- Original SpringBoot application with Docker compose: https://spring.io/guides/gs/spring-boot-docker/#scratch
- Unit tests: https://spring.io/guides/gs/testing-web/
- circleCi for Java: https://circleci.com/docs/2.0/hello-world/

- Configure one kubectl client to access several K8s clusters: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/

- Using multi-line env. variables in CircleCI: https://circleci.com/docs/2.0/env-vars/?utm_medium=SEM&utm_source=gnb&utm_campaign=SEM-gb-DSA-Eng-ni&utm_content=&utm_term=dynamicSearch-&gclid=Cj0KCQjw9b_4BRCMARIsADMUIyo1RNzH2os-oOxhvTgYZb6CtXSEF5OzUi1HHQK4J8nnSTRplG8lC9saAqOQEALw_wcB


## Service account for CI/CD
- Create a service account: https://stackoverflow.com/questions/48394610/connect-local-instance-of-kubectl-to-gke-cluster-without-using-gcloud-tool (the answer from Timur)
- Get service account credentials into ./kube/config file: https://stackoverflow.com/questions/47770676/how-to-create-a-kubectl-config-file-for-serviceaccount
- And similar task described here: https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster/
- Similar task of getting credentials: https://docs.armory.io/docs/spinnaker-install-admin-guides/manual-service-account/
 






