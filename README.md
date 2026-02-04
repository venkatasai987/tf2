sonar: Login to Sonar and generate Token. Create credentials in Jenkins And 
Configure sonar server cube url In Jenkins >>System
Download Sonor scanner plug in
Configure sonar scanner Jenkins >>tools
add Sonar properties file where our source code is.
ex:sonar-project.properties
sonar.verbose=true
sonar.organization=myorg-1
sonar.projectKey=myorgkey-1_twittertrend
sonar.projectName=twittertrend
soanr.language=java
sonar.sourceEncoding=UTF-8
sonar.sources=src,copybooks
sonar.java.binaries=target/classes
sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml

plugins:
Multi branch scan
Sonar scanner
