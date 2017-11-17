node{
  def appName = "catalogue"
  def group = "infracloudio"
  checkout scm
  
  stage('Run build'){
    sh("scripts/build.sh")
  }
}