pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Build') {
            agent any
            steps {
                script {
                    retry(3) {
                      docker.withRegistry('https://registry.loopback.it', 'andrea-registry') {
                        def imageName = "registry.loopback.it/splunklight:${env.BUILD_ID}"
                        //def currentBuild = docker.build(imageName)
                        // workaround #JENKINS-31507
                        sh "docker build -t ${imageName} ."
                        def currentBuild = docker.image(imageName)
                        retry(3) {
                            currentBuild.push()
                        }
                        retry(3) {
                            currentBuild.push('latest')
                        }
                      }
                    }
                }
            }
        }
    }
}
