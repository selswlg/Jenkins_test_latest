pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
		    dockerId = "sjaeehoonllee"
        registryCredential = "root_docker"
        dockerImage = "${dockerId}/jaehoon"
		    job_name = "${JOB_NAME}"
        appImage = ""
    }

    stages {
        // git에서 repository clone
        stage('Prepare') {
          steps {
            echo 'Clonning Repository'
            git url: 'https://github.com/selswlg/Jenkins_test_latest.git',
              branch: 'main',
              credentialsId: 'jenkins_test_key'
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
        stage('Build Gradle') {
          agent any
          steps {
            echo 'Build Gradle'
            dir ("../${job_name}"){
                sh """
                chmod 777 gradlew 
                gradlew clean build --exclude-task test
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
        stage('Build Docker') {
          agent any
          steps {			
            echo 'Build Docker'
            dir ("../${job_name}"){
              script {
                appImage = docker.build("${dockerId}/jaehoon")
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
