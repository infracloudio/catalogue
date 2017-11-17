node{
  def appName = "catalogue"
  def group = "infracloudio"
  checkout scm
  
  stage 'Run build'{
  sh("export GROUP=$group && scripts/build.sh")
  }
}