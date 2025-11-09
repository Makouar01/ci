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
          docker.withRegistry('', 'dockerhub-credentials') {
            def app = docker.build("${DOCKER_HUB_REPO}:${BUILD_NUMBER}")

          }
        }
      }
    }

stage('Deploy via Ansible (in WSL)') {
      steps {
        script {
          // Exécute la commande dans WSL Ubuntu
          bat """
          wsl ansible-playbook -i /mnt/c/Users/MAKOUAR/ansible/inventory.ini /mnt/c/Users/MAKOUAR/ansible/deploy.yml ^
            --extra-vars "image=${DOCKER_HUB_REPO}:${BUILD_NUMBER} host=${SERVER_HOST} ansible_user=${SSH_USER}"
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
