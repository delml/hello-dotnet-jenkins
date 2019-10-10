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
      stages {
        stage('Passing Tests') {
          environment {
            TEST_RESULT_PATH = "TestResults/passing_tests.xml"
          }

          steps {
            sh "dotnet test --logger:'xunit;LogFilePath=${TEST_RESULT_PATH}' --filter Fails!=True"
          }
        }

        stage('Failing Tests') {
          environment {
            TEST_RESULT_PATH = 'TestResults/failing_tests.xml'
          }

          steps {
            sh (
              script: "dotnet test --logger:\"xunit;LogFilePath=${TEST_RESULT_PATH}\" --filter Fails=True",
              returnStatus: true
            )
          }
        }
      }

      post {
        always {
          xunit(
            tools: [xUnitDotNet(pattern: "**/TestResults/*.xml")],
            thresholds: [
              failed(unstableThreshold: '0')
            ]
          )
        }

        unsuccessful {
          mail(
            to: 'derek@3dresourcing.com.au,email6078@gmail.com',
            subject: "UNSUCCESSFUL build ${env.BRANCH_NAME}${env.BUILD_DISPLAY_NAME}",
            body: "Bad build is bad: ${env.BUILD_URL}",
          )
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

        // Check build is successful so far
        expression { currentBuild.result == null }
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
