def DOCKER_IMAGE_NAME = "sjaeehoonllee"
//def DOCKER_IMAGE_TAGS = "batch-visualizer-auth"

podTemplate(label: 'docker-build', 
  containers: [
	containerTemplate(
	  name: 'gradle', 
	  image: 'gradle:7.4.1-jdk11', 
	  command: 'cat', 
	  ttyEnabled: true
	),
    containerTemplate(
      name: 'git',
      image: 'alpine/git',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [
	hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/home/admin/k8s/jenkins/.gradle'),
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
) {
    node('docker-build') {

		// docker Credential ID
        def dockerHubCred = 'root_docker'
        def appImage
        
        stage('Checkout'){
			echo 'Git Checkout'
            container('git'){
                checkout scm
            }
        }

		stage('Build Jar') {
			echo 'Build Gradle'
            container('gradle') {
				// container 안에서 스크립트 명령어 수행하려면 script를 붙여야하나
				script{
					sh "./gradlew clean build --exclude-task test"
				}
            }
        }
        
		// 여기서 태그를 제거 push할때 build number, latest 두개 이미지를 push
        stage('Build docker image'){
			echo 'Build Docker'
            container('docker'){
				script{
					appImage.inside {
						// appImage = docker build -t ${DOCKER_IMAGE_NAME}/${JOB_NAME} .
						appImage = docker.build("${DOCKER_IMAGE_NAME}/${JOB_NAME}")
					}
				}
			}
        }

        stage('Push Docker'){
            container('docker'){
				echo 'Push Docker'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCred){
                        appImage.push("${env.BUILD_NUMBER}")
                        appImage.push("latest")
                    }
                }
            }
        }
		
		// tear down을 해줘야 하나? 개발과정에서 images가 많이쌓여서 ec2 jenkins 용량을 많이 차지하면 그때 tear down 도입
    }
    
 }
