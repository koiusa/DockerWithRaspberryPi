pipeline {
  agent {
    docker {
      args 'args \'-u root:sudo\''
      image 'python:3.6'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh '''uname
cat /etc/*release
apt-get update && apt-get install sudouname
cat /etc/*release
apt-get update && apt-get install sudo'''
      }
    }

    stage('Install') {
      steps {
        sh '''python -V
ls /home/${USER}

cd ./docker
'''
      }
    }

  }
  post {
    failure {
      discordSend(description: BUILD_RESULT, footer: currentBuild.currentResult, webhookURL: WEBHOOK, successful: false)
    }

    success {
      discordSend(description: BUILD_RESULT, footer: currentBuild.currentResult, webhookURL: WEBHOOK, successful: true)
    }

  }
}