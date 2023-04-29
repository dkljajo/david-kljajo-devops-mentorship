Description: TASK-8

- Task obuhvata:

-  Kreiranje AMI image-a od instance ec2-ime-prezime-web-server. AMI image imenovati ami-prezime-ime-web-server.
 - Kreirati Application Load Balancer naziva alb-web-servers koji ce biti povezan sa Target Group tg-web-servers.
-  Kreirati ASG sa MIN 2 i MAX 4 instance. Tip instance koji cete koristiti unutar ASG je t2.micro ili t3.micro gdje cemo koristiit alb-web-servers Load Balancer. ASG bi trebala da skalira prema gore (scale-up) kad CPU predje 18% i skalira prema dole (scale down) kad god CPU Utilisation padne ispod 18%.
-  Security grupe dozvoljavaju najmanje potrebne otvorene portove.
 -  Kreiran account na lucidchart.com i napravljen dijagram infrastrukture.
-  Simulirana visoka dostupnost na nacin da su terminirane instance.
- Simuliran CPU load.

<br/>


`$ aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"david-kljajo.awsbosnia.com.","Type":"A","TTL":60,"ResourceRecords":[{"Value":"44.263.200.253"}]}}]}'`
- ![create-dns](./1.png)

<br/>

`aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "david-kljajo.awsbosnia.com.") | {Name, Value}'`
- ![list-record](./2.png)
<br/>
`sudo certbot certonly --nginx`
- ![10][./10.png)
<br/>
` ls -la /etc/letsencrypt/live/david-kljajo.awsbosnia.com/`
- ![lets-encrypt](/home/david/Desktop/13.png)

<br/>

- ![web1](./17.png)
<br/>
`echo | openssl s_client -showcerts -servername david-kljajo.awsbosnia.com -connect david-kljajo.awsbosnia.com:443 2>/dev/null | openssl x509 -inform pem -noout -text`
- ![20](./20.png)
<br/>
`openssl s_client -showcerts -connect david-kljajo.awsbosnia.com:443`
- ![21](./21.png)
<br/>
`cd /etc/letsencrypt/live/david-kljajo.awsbosnia.com/`
- ![24](./24.png)
<br/>

- ![node-app](./25.png)
<br/>
`node-app.conf # comment line in node-app.conf`
- ![graph-dijagram](./30.png)
-<br/>
`echo | openssl s_client -showcerts -servername david-kljajo.awsbosnia.com -connect david-kljajo.awsbosnia.com:443 2>/dev/null | openssl x509 -inform pem -noout -text`
- ![echo-openssl](./50.png)
<br/>

 - ![listeners](./70.png)
<br/>
  - ![web-amazon](./80.png)
<br/>
  - ![ami-image](./90.png)




