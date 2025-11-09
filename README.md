# springboot-hello

Simple Spring Boot project (Java 21) exposing one endpoint:

GET /hi -> returns "Hi user"

## How to build locally

```bash
mvn -B clean package
java -jar target/springboot-hello-0.0.1-SNAPSHOT.jar
```

## Docker

Build:
```bash
docker build -t yourdockeruser/springboot-hello:latest .
docker tag yourdockeruser/springboot-hello:latest yourdockeruser/springboot-hello:1.0
docker push yourdockeruser/springboot-hello:1.0
```

## Jenkins notes

- Update `Jenkinsfile` with your repo URL, Docker Hub repo and credentials IDs.
- Add SSH key in Jenkins credentials (id=`ssh-server`) and Docker Hub credentials (id=`dockerhub`).

## Ansible

- Update `ansible/inventory.ini` with your server IP and user.
- Run the playbook (locally or via Jenkins):
```
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml --extra-vars "image=yourdockeruser/springboot-hello:latest host=your.server.ip"
```
