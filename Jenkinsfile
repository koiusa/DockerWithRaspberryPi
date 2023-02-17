pipeline {
  agent {
    docker {
      image 'raspbian/stretch'
      args 'args \'-u root:sudo\''
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
}