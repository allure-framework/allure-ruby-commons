pipeline {
  agent { docker 'ruby:2.6.3' }
  parameters {
    booleanParam(name: 'RELEASE', defaultValue: false, description: 'Perform release?')
    string(name: 'RELEASE_VERSION', defaultValue: '', description: 'Release version')
  }
  stages {
    stage('Install') {
      steps { sh 'bundle install' }
    }
    stage('Lint') {
      steps { sh 'bundle exec rubocop' }
    }
    stage('Test') {
      steps { sh 'bundle exec rspec' }
    }
    stage('Release') {
      when { expression { return params.RELEASE } }
      steps {
        sh 'gem build allure-ruby-commons.gemspec'
        sh 'gem push allure-ruby-commons-${RELEASE_VERSION}.gem'
      }
    }
    post {
      always { deleteDir() }
      failure {
        slackSend message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} failed (<${env.BUILD_URL}|Open>)",
                color: 'danger', teamDomain: 'qameta', channel: 'allure', tokenCredentialId: 'allure-channel'
      }
    }
  }
}
