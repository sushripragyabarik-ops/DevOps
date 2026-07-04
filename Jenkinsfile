
pipeline {
    agent any

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mywebsite .'
            }
        }

        stage('Remove Old Container') {
            steps {
                sh 'docker rm -f website || true'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 8081:80 --name website mywebsite'
            }
        }

        stage('Verify Running Container') {
            steps {
                sh 'docker ps'
            }
        }

    }

    post {
        success {
            echo 'Docker image built and container started successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
