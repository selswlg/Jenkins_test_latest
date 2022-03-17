pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
		    dockerId = "rkwoals524"
        registryCredential = "Jenkins_CI_Test"
        dockerImage = "${dockerId}/jaemin"
		    job_name = "${JOB_NAME}"
        appImage = ""
    }

    stages {
        // git에서 repository clone
        stage('Prepare') {
          steps {
            echo 'Clonning Repository'
            git url: 'https://github.com/AtTheFoodTruck/backend.git',
              branch: 'main',
              credentialsId: 'jenkins-github-token'
            }
            post {
             success { 
               echo 'Successfully Cloned Repository'
             }
           	 failure {
               error 'This pipeline stops here...'
             }
          }
        }

        // gradle build
        stage('Bulid Gradle') {
          agent any
          steps {
            echo 'Bulid Gradle'
            dir ("../${job_name}"){
                sh """
                sudo chmod 777 gradlew
                ./gradlew clean build --exclude-task test
                """
            }
          }
          post {
            failure {
              error 'This pipeline stops here...'
            }
          }
        }
        
        // docker build
        stage('Bulid Docker') {
          agent any
          steps {			
            echo 'Bulid Docker'
            dir ("../${job_name}"){
              script {
                appImage = docker.build("${dockerId}/jaemin")
              }
            }
          }
          post {
            failure {
              error 'This pipeline stops here...'
            }
          }
        }

        // docker push
        stage('Push Docker') {
          agent any
          steps {
            echo 'Push Docker'
            script {
                docker.withRegistry('https://registry.hub.docker.com', registryCredential) {                
                echo "${dockerImage}"
                appImage.push("${BUILD_NUMBER}")
                appImage.push("latest")
                }
            }
          }
          post {
            failure {
              error 'This pipeline stops here...'
            }
          }
        }
    }
}
