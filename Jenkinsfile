pipeline {
  agent any

  environment {
    DOCKER_HUB_REPO = 'abderrahim298/ci'
    SSH_CRED = 'ssh-server'
    SERVER_HOST = '192.168.137.130'
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/Makouar01/ci.git'
      }
    }

    stage('Build Maven (Windows)') {
      steps {
        bat 'mvn -B clean package -DskipTests'
      }
      post {
        success {
          archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
      }
    }

    stage('Docker Build & Push (Windows)') {
      steps {
        script {
          docker.withRegistry('', 'dockerhub') {
            def app = docker.build("${DOCKER_HUB_REPO}:${BUILD_NUMBER}")
            app.push()
            app.push("latest")
          }
        }
      }
    }

    stage('Deploy via Ansible (in WSL)') {
      steps {
        sshagent([SSH_CRED]) {
          bat """
          wsl ansible-playbook -i ansible/inventory.ini ansible/deploy.yml ^
            --extra-vars "image=${DOCKER_HUB_REPO}:${BUILD_NUMBER} host=${SERVER_HOST}"
          """
        }
      }
    }
  }

  post {
    success {
      echo '✅ Déploiement réussi sur la VM Linux !'
    }
    failure {
      echo '❌ Échec du pipeline'
    }
  }
}
