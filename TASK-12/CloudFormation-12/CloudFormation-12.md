- CloudFormation is a method of provisioning AWS infrastructure using code. 
- It allows you to model a collection of related resources, both AWS and third party, to provision them quickly and consistently. 
- AWS CloudFormation also provides you with a mechanism to manage the resources through their lifecycle.

- The created CF stack template is available in the cloudformation directory under the name cf-instances.yaml
- The following is an explanation of individual parts of the code:

```
AWSTemplateFormatVersion: "2010-09-09"
Description: Setup enivorment with EC2 instances using CF
Parameters:
  KeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access
    Type: 'AWS::EC2::KeyPair::KeyName'
    Default: packer-proba
Mappings:  RegionMap:
    eu-central-1:
      test: "ami-04b1adb4a712e44e0" 
```

- U **KeyName** definisemo kljuc za SSH povezivanje sa nasom EC2 instancom.

- **Mappings** je koristen kako bi se omogucilo da, u zavisnosti od regiona izaberemo zeljeni AMI Image jer je isti ogranicen na region, pa da izbjegnemo hardcodiranje.
### Security Group

```
Resources:
  WebInstanceSG:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP/SSH Access
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
```

- U dijelu **Resources** krecemo sa kreiranjem logickih resursa koji ce postati nasi fizicki resursi.
- Ovdje je kreirana SG za webserver instancu kojoj je dozvoljen Inbound saobracaj po portu 22 i 80 za SSH/HTTP.

## Creating instances

```
webserver:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !FindInMap ["RegionMap", !Ref "AWS::Region", "test" ]
      InstanceType: t2.micro
      KeyName: !Ref "KeyName"
      SecurityGroupIds:
        - !Ref WebInstanceSG
      
      Tags:
        - Key: Name
          Value: task-12-web-server-cf
        - Key: CreatedBy
          Value: david.kljajo
        - Key: Project
          Value: task-12 
        - Key: IaC 
          Value: CloudFormation 
        - Key: "env"
          Value: "dev"
        - Key: "app"
          Value: "web"
```

-  U ovom dijelu koristena je Intrinsic Functions !Ref kako bi se referencirali na neke resurse iz koda.
-  Kao i funckija !FindInMap da bi se preuzeo odgovarajuci AMI ID za region u kojem se Stack kreira
- Tagovi koji su neophodni, kao i dodatni tagovi radi kreiranja dinamickog inventory file-a za Ansible playbook.

### Output kreiranja Stack-a

```
Outputs:
  StackName:
    Description: CF Stack Name
    Value: !Ref "AWS::StackName"
  WebInstancePublicIP:
    Description: Web Instance Public IP adress
    Value: !GetAtt webserver.PublicIp
  DbInstancePublicIP:
    Description: DB Instance Public IP adress
    Value: !GetAtt dbserver.PublicIp
```

* * *

![13](/home/david/Desktop/CloudFormation-12/13.png)

 - Uspjesno kreiran stack:

![14](/home/david/Desktop/CloudFormation-12/14.png)

 - Uspjesno kreirani web server i db server:

![16](/home/david/Desktop/CloudFormation-12/16.png)


