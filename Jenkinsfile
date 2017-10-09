// vim: ft=groovy
pipeline {
  agent { dockerfile true }

  stages {
    stage("Test") {
      steps { sh "./ci" }
    }

    stage("Build") {
      steps { sh "./bin/release $BUILD_ID" }
    }

    stage("Deploy") {
      when { branch "master" }
      // TODO we need to find a more automatable way to deploy, since right now
      // it's fairly dependent on SSH. _maybe_ using ansible somehow? or we
      // could write more software to try and solve this, but not sure if I
      // want that.

      steps {
        sshagent credentials("jenkins-20170909")
        sh "ssh deploy@web01.he-fre1.blackieops.net sudo /usr/local/bin/blackieops-update watashi"
        sh "ssh deploy@web02.he-fre1.blackieops.net sudo /usr/local/bin/blackieops-update watashi"
      }
    }
  }
}
