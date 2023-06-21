# Task - 13: AWS Code Family Workshop
* * *

- AWS Cloud9 is a cloud-based integrated development environment (IDE) that lets you to write, run and debug code with just a browser. It includes a code editor, debugger, and terminal.

**- In this task we will create CI/CD pipeline for Java application , which is deployed on EC2 instance.**

## Setup AWS Cloud9 IDE

![1](/home/david/Desktop/Task-13/1.png)


![2](/home/david/Desktop/Task-13/2.png)

* * *

## Create a web app

Now that we have our Cloud9 development environment up and running, let's create our simple Java web application.

### Install Maven & Java
1.
`sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo`
`sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo`
`sudo yum install -y apache-maven`

2.
`sudo amazon-linux-extras enable corretto8`
`sudo yum install -y java-1.8.0-amazon-corretto-devel`
`export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64`
`export PATH=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre/bin/:$PATH`

3.
`java -version`
`mvn -v`

### Create the Application

`mvn archetype:generate \
    -DgroupId=com.wildrydes.app \
    -DartifactId=unicorn-web-project \
    -DarchetypeArtifactId=maven-archetype-webapp \
    -DinteractiveMode=false`
	

![3](/home/david/Desktop/Task-13/3.png)

* * *
# Lab 1: AWS CodeCommit
* * *
- AWS CodeCommit is a secure, highly scalable, managed source control service that hosts private Git repositories. CodeCommit eliminates the need for you to manage your own source control system or about scaling its infrastructure.

### Create a Repository

![5](/home/david/Desktop/Task-13/5.png)

### Commit your Code

`https://git-codecommit.us-east-1.amazonaws.com/v1/repos/unicorn-web-project`

`git config --global user.name "David Kljajo"`

`git config --global user.email davidkljajo@gmail.com`

`cd ~/environment/unicorn-web-project`

`git init -b main`

`git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/unicorn-web-project`

`git add *`

`git commit -m "Initial commit"`

`git push -u origin main`

![6](/home/david/Desktop/Task-13/6.png)

* * *
# Lab 2: AWS CodeArtifact
* * *

- AWS CodeArtifact is a fully managed artifact repository service that makes it easy for organizations of any size to securely fetch, store, publish, and share software packages used in their software development process.

#### Create Domain and Repository

![7](/home/david/Desktop/Task-13/7.png)

### Connect the CodeArtifact repository

` export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain unicorns --domain-owner 645921973070 --region us-east-1 --query authorizationToken --output text` `

`cd ~/environment/unicorn-web-project`

`echo $'<settings>\n</settings>' > settings.xml`

![13](/home/david/Desktop/Task-13/13.png)

`mvn -s settings.xml compile`

![9](/home/david/Desktop/Task-13/9.png)

### IAM Policy for consuming CodeArtifact

![10](/home/david/Desktop/Task-13/10.png)

* * *
# AWS CodeBuild

* * *

- AWS CodeBuild is a fully managed continuous integration service that compiles source code, runs tests, and produces software packages that are ready to deploy. You can get started quickly with prepackaged build environments, or you can create custom build environments that use your own build tools.

## Create an S3 bucket

### buildspec.yml

![11](/home/david/Desktop/Task-13/11.png)

`cd ~/environment/unicorn-web-project`

`git add *`

`git commit -m "Adding buildspec.yml file"`

`git push -u origin main`

![12](/home/david/Desktop/Task-13/12.png)

`cd ~/environment/unicorn-web-project`
`git add *`
`git commit -m "Adding buildspec.yml file"`
`git push -u origin main`

- edited buildspec.yml:

![14](/home/david/Desktop/Task-13/14.png)

- CodeBuild successfully finished:

![15](/home/david/Desktop/Task-13/15.png)

- So we verify that we  have a packaged WAR file inside a zip named unicorn-web-project.zip:

![16](/home/david/Desktop/Task-13/16.png)

* * *
# 4. AWS CodeDeploy
* * *

- AWS CodeDeploy is a fully managed deployment service that automates software deployments to a variety of compute services such as Amazon EC2, AWS Fargate, AWS Lambda, and even on-premise services. You can use AWS CodeDeploy to automate software deployments, eliminating the need for error-prone manual operations.

## Create deployment
1. Log into the AWS Console and search for CloudFormation.
2. Download the provided CloudFormation YAML Template
3. Create stack > with new resources (standard).
4. Upload a template file and click Choose file. Select the yaml file downloaded in step 2


- Successfully created CloudFormation Stack:

![28](/home/david/Desktop/Task-13/28.png)


 - Shell scripts:
* * *
1.

![19](/home/david/Desktop/Task-13/19.png)

2. 

![20](/home/david/Desktop/Task-13/20.png)

3.

![21](/home/david/Desktop/Task-13/21.png)

4.

![22](/home/david/Desktop/Task-13/22.png)

- edited bulidspac.yml file:

![23](/home/david/Desktop/Task-13/23.png)

- commit all changes to CodeCommit:

`cd ~/environment/unicorn-web-project`
`git add *`
`git commit -m "Adding CodeDeploy files"`
`git push -u origin main`

- output push on main branch:

![29](/home/david/Desktop/Task-13/29.png)

- Updated CodeBuild configuration successfully completed:

![24](/home/david/Desktop/Task-13/24.png)


- Added new CodeDeploy IAM Role:

![25](/home/david/Desktop/Task-13/25.png)

## Create a CodeDeploy application

1. Under the unicorn-web-deploy application in the Deployment groups tab click Create deployment group.

2. Configure the following options:

Name = unicorn-web-deploy-group
Service role = arn:aws:iam::<aws-account-id>:role/UnicornCodeDeployRole
Deployment type = In-place
Environment configuration = Amazon EC2 instances
Tag group 1 Key = role
Tag group 1 Value = webserver
Install AWS CodeDeploy Agent = Now and schedule updates (14 days)
Deployment settings = CodeDeployDefault.AllAtOnce
Load balancer = Uncheck Enable load balancing (we just have one server)

![26](/home/david/Desktop/Task-13/26.png)


- Created unicorn-web-deploy-group:

![27](/home/david/Desktop/Task-13/27.png)

- Successfully created code deploy of application:

![30](/home/david/Desktop/Task-13/30.png)

![31](/home/david/Desktop/Task-13/31.png)
* * *

# 5. Lab 5: AWS CodePipeline
* * *

- AWS CodePipeline is a fully managed continuous delivery service that helps you automate your release pipelines for fast and reliable application and infrastructure updates. You only pay for what you use.

## Create the pipeline

- Pipeline name: `unicorn-code-pipeline`
- Role name: `AWSCodePipelineServiceRole-eu-central-1-unicorn-web-pipeline`
* * *
## Update the CloudFormation stack

- Output stack after update:

![32](/home/david/Desktop/Task-13/32.png)

## Add an additional CodeDeploy deployment group

![33](/home/david/Desktop/Task-13/33.png)

- SNS Subscription :

![34](/home/david/Desktop/Task-13/34.png)

- Complete CI/CD Pipeline with manual approval :

![35](/home/david/Desktop/Task-13/35.png)


- Deploy process on EC2 instance:

![36](/home/david/Desktop/Task-13/36.png)
* * *
# Clean all AWS resources!
* * *
## Delete CloudFormation stack

## Delete the Cloud9 environment

## Delete CodePipeline

## Delete the CodeCommit repository

## Delete the CodeArtifact repository and domain

## Delete CodeBuild projects

## Delete CodeDeploy application

## Delete SNS topic and subscription

## Empty and delete buckets created in S3

## Delete IAM Policies and Roles

## Delete CloudWatch Logs group






