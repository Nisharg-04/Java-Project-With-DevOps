@Library('Shared') _
pipeline {
    agent any
    tools {
        jdk 'JDK'
        maven 'maven3'
    }
    environment {
        SONAR_HOME = tool "Sonar"
    }

    stages {
        stage('Code Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Nisharg-04/Java-Project-With-DevOps.git'
            }
        }
        stage('Compile the Code') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test the Code') {
            steps {
                sh "mvn test"
            }
        }
        stage('Scan the Code') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        stage("SonarQube: Code Analysis") {
            steps {
                withSonarQubeEnv('Sonar') {
                    sh "${SONAR_HOME}/bin/sonar-scanner -Dsonar.projectKey=wanderlust -Dsonar.sources=src -Dsonar.java.binaries=target"
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings') {
                    sh "mvn deploy"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t nishargsoni/boardgame:latest ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                
                    script{
                        withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker push nishargsoni/boardgame:latest"
                    }
                        
                        }
                
            }
        }
        
        stage('Deploy To Kubernetes') {
            steps {
               withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.8.146:6443') {
                        sh "kubectl apply -f deployment-service.yaml"
                }
            }
        }
        
        stage('Verify the Deployment') {
            steps {
               withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.8.146:6443') {
                        sh "kubectl get pods -n webapps"
                        sh "kubectl get svc -n webapps"
                }
            }
        }
    }
    post {
        always {
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'SUCCESS'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'

                def body = """
                    <html>
                    <body>
                    <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                    <h2>${jobName} - Build ${buildNumber}</h2>
                    <div style="background-color: ${bannerColor}; padding: 10px;">
                    <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                    </div>
                    <p>Check the <a href="${env.BUILD_URL}">console output</a>.</p>
                    </div>
                    </body>
                    </html>
                """

                emailext (
                    subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                    body: body,
                    to: 'ncsoni04@gmail.com',
                    from: 'jenkins@example.com',
                    replyTo: 'jenkins@example.com',
                    mimeType: 'text/html'
                )
            }
        }
    }
}
