pipeline {
  agent { dockerfile true }

  stages {
    stage("Test") {
      steps { sh "./.ci" }
    }

    stage("Deploy") {
      when { branch "master" }

      environment {
        GPG_KEY_DATA = credentials("signing_key_2017")
        GPG_OWNERTRUST = credentials("signing_key_trust")
      }

      steps {
        // Get the GPG key into the container
        // This is messy as fuck and I hate it
        sh 'echo "$GPG_KEY_DATA" > signing_key && echo "$GPG_OWNERTRUST" | gpg --import-ownertrust'
        sh "gpg --import signing_key && rm signing_key"

        // Build the RPM
        sh "./bin/release $BUILD_ID"

        // Load the deploy ssh key
        sshagent credentials("jenkins-20170909")

        // Upload RPM and update repo
        sh "scp rpmbuild/RPMS/x86_64/watashi-*.rpm deploy@repo.blackieops.com:/srv/repo/centos/7/"
        sh "ssh deploy@repo.blackieops.com createrepo --update /srv/repo/centos/7/"

        // Tell app servers to update
        // TODO: find a better way than just ssh
        sh "ssh deploy@web01.he-fre1.blackieops.net sudo /usr/local/bin/blackieops-update watashi"
        sh "ssh deploy@web02.he-fre1.blackieops.net sudo /usr/local/bin/blackieops-update watashi"

        // Clean up
        sh "rm -v rpmbuild/RPMS/x86_64/watashi-*.rpm"
      }
    }
  }
}
