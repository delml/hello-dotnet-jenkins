pipeline {
  agent any

  environment {
    ASPNETCORE_TARGET_FRAMEWORK = 'netcoreapp3.0'
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
        HELLOMVC_APP_NAME = 'HelloMvcStaging'
        HELLOMVC_SERVICE_NAME = 'hellomvc-staging'
        HELLOMVC_APP_ENVIRONMENT = 'Staging'
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
        HELLOMVC_APP_NAME = 'HelloMvcProduction'
        HELLOMVC_SERVICE_NAME = 'hellomvc-production'
        HELLOMVC_APP_ENVIRONMENT = 'Production'
      }

      steps {
        sh 'sh ./jenkins/scripts/publish-hellomvc.sh'
        // sh 'sh ./jenkins/scripts/hellomvc-service-generate-config.sh'
        // sh 'sh ./jenkins/scripts/hellomvc-service-configure.sh'
      }
    }
  }
}
