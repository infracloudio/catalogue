node{
  def appName = "catalogue"
  def group = "infracloudio"
  checkout scm
  
  stage('Run build'){
    steps{
      environment{
        GROUP = $group
      }
      
      sh("scripts/build.sh")
    }
  }
}