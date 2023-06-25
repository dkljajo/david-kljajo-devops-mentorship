# Packer
* * *

- Packer is part of the HashiCorp open source suite of toools.
- It is an open source command-line tool that allows us to create custom VM images of any OS on several platforms from a JSON file.
- Packer's operation is simple and it is based on the basic OS provided by the different cloud providers and configures a temporary VM by executing the scripts described in the JSON or HCL template.
- From this temporary VM, Packer generates a custom image ready to be used to provision VMs.
- Apart from VM images, Packer also provides other types of images such as Docker images.
* * *
## Packer templates - Demo

- `01_first_ami.json`  and 
- `packer build <naziv-json-file>`

- `01_first_ami.json` : 

```
{
    "builders": [{
      "type": "amazon-ebs",
	    "access_key": "AKIAIOSFODNN7EXAMPLE",
      "secret_key": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
      "region": "us-east-1",
      "source_ami": "ami-0889a44b331db0194",
      "instance_type": "t2.micro",
      "ssh_username": "ec2-user",
      "temporary_key_pair_type": "ed25519",
      "ami_name": "packer-devops-mentorship {{timestamp}}"
    }]
}
```

![3](/home/david/Desktop/Packer/3.png)

* * *
## Packer - task 12
* * *

- Packer tool is used to create Custom AMI image from Amazon Linux 3 AMI, where it is necessary to install and enable necessary yum repositories for nginx and mysql database installation.

- packer-provisioners.json :
![7](/home/david/Desktop/Packer/7.png)

- install-mysql.sh:

![9](/home/david/Desktop/Packer/9.png)

-  instal-nginx.sh
-
![10](/home/david/Desktop/Packer/10.png)

 - Building Packer AMI successfulll:

![11](/home/david/Desktop/Packer/11.png)

- Created ec2 instance of web sever with nginx sever and MySQL database:

![12](/home/david/Desktop/Packer/12.png)

