pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
       stage('code cloning'){
         steps{
             sh 'rm -rf node-app'
            sh 'git clone https://github.com/anilkumarpuli/node-app.git'
               }
           }
         stage('code build by maven'){
               steps{
               sh'mvn install'
           }
          } 
        
        stage('Build Docker Image'){
            steps{
                sh "docker build . -t anilkumblepuli/vprofile1:${DOCKER_TAG}"
            }
        }
        stage('DockerHub Push'){
            steps{
withCredentials([string(credentialsId: 'docker-tub1', variable: 'docker-tub')]) {
    sh "docker login -u anilkumblepuli -p ${docker-tub}"
    sh "docker push anilkumblepuli/vprofile1:${DOCKER_TAG}"
                }
            }
        }
        stage('Deploy to k8s'){
            steps{
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sshagent(['k8s-machine']) {
                    sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ubuntu@52.66.186.30:/home/ubuntu/"
                    script{
                        try{
                            sh "ssh ubuntu@52.66.186.30 kubectl apply -f ."
                        }catch(error){
                            sh "ubuntu@52.66.186.30 kubectl create -f ."
                        }
                    }
                }
            }
        }
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
