To complete this task you need to complete AWS Tools GitFlow Workshop available on the following link:
AWS Tools GitFlow Workshop

IAM User 1 ce svoje resurse da kreira unutar eu-central-1 regiona.
IAM User 2 ce svoje resurse da kreira unutar us-east-1 regiona.
IAM User 3 ce svoje resurse da kreira unutar eu-west-1 regiona

Please pay attention to the following:

You will execute workshop tasks inside your own AWS Account, where you see the part explaining Create an AWS Account (skip that part since you already have an IAM User and AWS Account).
Adjust workshop to the region in which you are working, for example when it say Launch AWS Cloud9 in US-EAST-1 you should do it in the region which is stated above for your IAM user.
You need to follow steps inside AWS Cloudformation (for this task you will not follow AWS CDK Steps)
Ticket outcomes:

Through this workshop, you should try not just to blindly follow steps but also to analyze and understand the commands you are executing.
You should carefully read all posts referenced in this workshop, for example (https://nvie.com/posts/a-successful-git-branching-model/ )
You should create a directory inside your DevOps Mentorship Program repo and all files used for this task put under one directory and put a pull request as a comment to this ticket.

<br/>

* * *

## CloudFormation

- In this module you will use AWS Cloudformation to set up your application and the infrastructure associated with it. You will leverage AWS Elastic Beanstalk to simplify things.

![1](./1.png)

<br/>

## 1.Master Branch

### 1.1 Elastic Beanstalk

- To simplify the process of setting up and configuring EC2 instances for this tutorial, you will spin up a nodejs environment using AWS Elastic Beanstalk. Elastic Beanstalk lets you easily host web applications without needing to launch, configure, or operate virtual servers on your own. It automatically provisions and operates the infrastructure (e.g. virtual servers, load balancers, etc.) and provides the application stack (e.g. OS, language and framework, web and application server, etc.)

<br/>

![2](./2.png)

- Stage 1: Create Code Commit Repo

<br/>



![4](./4.png)

<br/>

- bash script

![5](./5.png)

<br/>

`bash resize.sh 30`


![6](./6.png)

<br/>

`df -h`

![7](./7.png)

<br/>



![10](./10.png)

<br/>

`ASSETURL="https://static.us-east-1.prod.workshops.aws/public/442d5fda-58ca-41f0-9fbe-558b6ff4c71a/assets/workshop-assets.zip"; wget -O gitflow.zip "$ASSETURL"`

![12](./12.png)

<br/>

` unzip gitflow.zip -d gitflow-workshop/ `

![13](./13.png)

<br/>

`cd gitflow-workshop`
`git add -A`
`git commit -m "Initial Commit"`

![14](./14.png)

<br/>

`git push origin master`

![15](./15.png)

<br/>

### Create Elastic Beanstalk Application

`aws cloudformation create-stack --template-body file://envcreate.yaml --parameters file://parameters.json --capabilities CAPABILITY_IAM --stack-name gitflow-eb-master`

![16](./16.png)

<br/>

### Lambda

<br/>

![40][./40.png)

<br/>

![41](./41.png)

<br/>

### CloudFormation

<br/>

![17](./17.png)

<br/>

![18](./18.png)

<br/>

## Elastic BeanStalk

![19](./19.png)

<br/>

![20](./20.png)

<br/>

![21](./21.png)

<br/>

![22](./22.png)

<br/>

![23](./23.png)

<br/>

![24](./24.png)

<br/>

![25](./25.png)

<br/>

![26](./26.png)

<br/>

![27](./27.png)

<br/>

![28](./28.png)

## CodePipeline

<br/>

![29](./29.png)

<br/>

![30](./30.png)

<br/>

![33](./33.png)

<br/>

![34](./34.png)

<br/>
- Final web page 

![35](./35.png)


