pipeline {
  agent any

  environment {
    DOCKER_HUB_REPO = 'aderrahim298/ci'
    SSH_CRED = 'ssh-server'
    SERVER_HOST = '192.168.137.130'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/your/repo.git'
      }
    }
    stage('Build') {
      steps {
        sh 'mvn -B clean package -DskipTests'
      }
      post {
        success {
          archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
      }
    }
    stage('Docker Build & Push') {
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
    stage('Deploy via Ansible') {
      steps {
        sshagent([SSH_CRED]) {
          sh """
          ansible-playbook -i ansible/inventory.ini ansible/deploy.yml \
            --extra-vars "image=${DOCKER_HUB_REPO}:${BUILD_NUMBER} host=${SERVER_HOST}"
          """
        }
      }
    }
  }

  post {
    success { echo '✅ Déploiement réussi' }
    failure { echo '❌ Échec du pipeline' }
  }
}
