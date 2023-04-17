Description: TASK-7: Autoscaling Group and Load Balancer 

- Task obuhvata:

-  Kreiranje AMI image-a od instance ec2-ime-prezime-web-server. AMI image imenovati ami-prezime-ime-web-server.
 - Kreirati Application Load Balancer naziva alb-web-servers koji ce biti povezan sa Target Group tg-web-servers.
-  Kreirati ASG sa MIN 2 i MAX 4 instance. Tip instance koji cete koristiti unutar ASG je t2.micro ili t3.micro gdje cemo koristiit alb-web-servers Load Balancer. ASG bi trebala da skalira prema gore (scale-up) kad CPU predje 18% i skalira prema dole (scale down) kad god CPU Utilisation padne ispod 18%.
-  Security grupe dozvoljavaju najmanje potrebne otvorene portove.
 -  Kreiran account na lucidchart.com i napravljen dijagram infrastrukture.
-  Simulirana visoka dostupnost na nacin da su terminirane instance.
- Simuliran CPU load.

<br/>
- Graf infrastrukture:


![graph-dijagram](/home/david/Desktop/week-8/Graf.jpg)

- Load Balancer DNS record:

![graph-dijagram](/home/david/Desktop/week-8/Load-balancer.jpg)
