pipeline {

    agent {
        node { label 'python' }
    }

    environment {
        GIT_REPO    = "https://github.com/Rajan-Aggarwal/jenkins-flask-pipeline"
        GIT_BRANCH  = "master"
        PORT        = 8081
    }

    stages {
        stage('Get source code') {
            steps {
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
            }
        }
        stage('Install dependencies') {
            steps {
                sh """
                    pip install virtualenv
                    virtualenv --no-site-packages
                    source bin/activate
                    pip install -r app/requirements.pip
                    deactivate
                """
            }
        }
        stage('Testing using nosetest and JUnit') {
            steps {
                sh """
                    source bin/activate
                    nosetests app --with-xunit
                    deactivate
                """
                junit "nosetests.xml"
            }
        }
        stage('Build docker') {
            steps {
                sh "docker build -t flask-app-${BUILD_ID} ."
            }
        }
        stage('Run docker') {
            steps {
                sh "docker run -p ${PORT}:${PORT} -d flask-app-${BUILD_ID}"
            }
        }
    }
}