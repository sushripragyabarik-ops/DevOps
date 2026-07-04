pipeline {
    agent any

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/sushripragyabarik-ops/DevOps.git'
            }
        }

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

        stage('Verify') {
            steps {
                sh 'docker ps'
            }
        }
    }
}
