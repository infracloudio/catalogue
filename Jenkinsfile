env.GROUP = 'infracloudio'
node{
  
  checkout scm
  
  stage('Run build'){
    
    sh("scripts/build.sh")
  }
}