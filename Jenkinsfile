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
        stage("Workspace cleanup") {
            steps {
                cleanWs()
            }
        }
        
        stage('Code Checkout') {
            steps {
                script {
                    code_checkout("https://github.com/Nisharg-04/Java-Project-With-DevOps.git", "main")
                }
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
                script {
                    trivy_scan()
                }
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "Java App", "Java App")
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

        stage('Scan Docker Image with Trivy') {
            steps {
                script {
                    sh "trivy image --exit-code 1 --severity HIGH,CRITICAL nishargsoni/boardgame:latest"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker push nishargsoni/boardgame:latest"
                    }
                }
            }
        }

        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    sh """
                    sed -i 's|image: .*|image: nishargsoni/boardgame:latest|' deployment-service.yaml
                    """
                }
            }
        }

        stage('Push to Git for ArgoCD') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-cred', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        sh """
                        git config user.name "Jenkins"
                        git config user.email "jenkins@example.com"
                        git add deployment-service.yaml
                        git commit -m "Update deployment to latest Docker image"
                        git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/Nisharg-04/Java-Project-With-DevOps.git main
                        """
                    }
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

                emailext(
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
