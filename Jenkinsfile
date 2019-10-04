pipeline {
  agent any

  environment {
    HELLOMVC_APP_NAME = "HelloMvc"
    HELLOMVC_DLL_NAME = "${HELLOMVC_APP_NAME}"
    HELLOMVC_IDENTIFIER = "hellomvc"
    HELLOMVC_PUBLISH_TO = "/var/www/${HELLOMVC_IDENTIFIER}"
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
        HELLOMVC_ENVIRONMENT = "Staging"
      }

      steps {
        sh 'sh ./jenkins/scripts/publish-hellomvc.sh'
        // FIXME: init service with auto-restart. Probably better to use Supervisor (Python).
        // sh 'sh ./jenkins/scripts/hellomvc-service-generate-config.sh'
        // sh 'sh ./jenkins/scripts/hellomvc-service-configure.sh'
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
        // sh 'sh ./jenkins/scripts/hellomvc-service-generate-config.sh'
        // sh 'sh ./jenkins/scripts/hellomvc-service-configure.sh'
      }
    }
  }
}
