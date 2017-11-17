node{
  environment{
    GROUP = 'infracloudio'
  }
  checkout scm
  
  stage('Run build'){
    
    sh("scripts/build.sh")
  }
}