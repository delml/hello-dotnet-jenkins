pipeline {
  agent any

  environment {
    HELLOMVC_PROJECT_NAME = "HelloMvc"
    HELLOMVC_APP_NAME = "${HELLOMVC_PROJECT_NAME}"
    HELLOMVC_DLL_NAME = "${HELLOMVC_PROJECT_NAME}"
    HELLOMVC_IDENTIFIER = "hellomvc"
    HELLOMVC_PUBLISH_TO = "/var/www/${HELLOMVC_IDENTIFIER}"
    HELLOMVC_PATH_BASE = "/hello"
  }

  stages {
    stage('Build') {
      steps {
        sh 'dotnet build'
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'dotnet test --logger:xunit'
      }

      post {
        always {
          xunit(tools: [xUnitDotNet(pattern: '**/TestResults/*.xml')])
        }
      }
    }

    stage('Staging') {
      environment {
        HELLOMVC_APP_NAME = "${HELLOMVC_APP_NAME}Staging"
        HELLOMVC_IDENTIFIER = "${HELLOMVC_IDENTIFIER}-staging"
        HELLOMVC_PUBLISH_TO = "${HELLOMVC_PUBLISH_TO}-staging"
        HELLOMVC_PATH_BASE = "${HELLOMVC_PATH_BASE}/staging"
        HELLOMVC_ENVIRONMENT = "Staging"
      }

      steps {
        sh 'sh ./jenkins/scripts/publish-hellomvc.sh'
        sh 'sh ./jenkins/scripts/hellomvc-service-configure.sh'
      }
    }

    stage('Deploy') {
      agent {
        label 'master'
      }

      when {
        beforeInput true
        beforeAgent true
        tag 'release-*'
      }

      input {
        message "Deploy ${env.TAG_NAME} to production servers?"
      }

      environment {
        HELLOMVC_ENVIRONMENT = "Production"
      }

      steps {
        sh 'sh ./jenkins/scripts/publish-hellomvc.sh'
        sh 'sh ./jenkins/scripts/hellomvc-service-configure.sh'
      }
    }
  }
}
