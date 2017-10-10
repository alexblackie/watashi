pipeline {
  agent { dockerfile true }

  stages {
    stage("Test") {
      steps { sh "./.ci" }
    }

    stage("Deploy") {
      when { branch "master" }

      steps {
        // Build the RPM
        sh "./bin/release $BUILD_ID"

        // Load the deploy ssh key
        sshagent(credentials: ["jenkins-20170909"]) {
          // Upload RPM and update repo
          sh "scp -o StrictHostKeyChecking=no rpmbuild/RPMS/x86_64/watashi-*.rpm deploy@repo.blackieops.com:inbox/"
        }
      }
    }

    stage("Clean") {
      when { branch "master" }
      sh "rm -v rpmbuild/RPMS/x86_64/watashi-*.rpm"
    }
  }
}
