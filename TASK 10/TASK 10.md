# TASK -10 : Serverless and Application Services

 - Architecture Deep Dive Part 1
 - Architecture Deep Dive Part 2
 - AWS Lambda Part 1
 - AWS Lambda Part 2
 - AWS Lambda Part 3
 - CludWatchEvents and Event Bridge
 - Automated EC2 Control using lambda and events Part 1 (DEMO)
 - Automated EC2 Control using lambda and events Part 2 (DEMO)
 - Serverless Architecture
 - Simple Notification Service (SNS)
 - Step Functions
 - API Gateway 101
 - Build a serverless app part 1
 -  Build a serverless app part 2
 - Build a serverless app part 3
 - Build a serverless app part 4
 - Build a serverless app part 5
 - Build a serverless app part 6
 - Simple Queue Service (SQS)
 - SQS Stadanard vs FIFO Queus
 - SQS Delay Queues

# 1. Arhitecture Deep Dive - part 1

### Monolitna arhitektura

1. Ako jedan dio "padne" , onda propada i cijela arhitektura
2. Dijelovi takodjer skaliraju zajedno, jer ne mozes jedan sloj skalirati bez ostalih.
Generalno, u monolitnoj arhitekturi moramo vertikalno skalirati sistem, jer sve radi na istom dijelu hardware-a.
3. Najvazniji aspekti monolitne arhitekture je: da se dijelovi naplacuju zajedno, jer kapacitet sistema treba biti dovoljan da bi se pokretalo sve zajedno. 
Zato oni moraju uvijek imati alocirane resurse, iako ih ne "konzumiraju" zajedno.
<br/>
- Za razliku od monolitne arhitekture imamo i **slojevitu arhitekturu**.
Monolitna arhitektura je razdvojena u zasebne dijelove ili slojeve.
Svaki od tih slojeva moze biti na istom serveru, ali i na razlicitim serverima. 
U ovoj arhitekturi razlicite komponente su i dalje povezane zajedno, jer svaki od slojeva pokazuje na isti "endpoint" od drugog sloja.

![0](./0.png)

<br/>

### Slojevita arhitektura

 - Kod slojevite arhitekture svaki od slojeva moze biti i vertikalno skaliran zasebno.
Npr. ako sloj procesiranja zahtijeva vise kapaciteta procesora (CPU) , onda moze biti povecan bez da budu povecani i ostali slojevi.
- Ali slojevita arhitektura je evoluirala i dalje : 
Umjesto da je svaki sloj direktno povezan sa drugim mozemo pokrenuti **load balancer-e** locirane izmedju npr. : 3 sloja .
To znaci da oni ne komuniciraju direktno vec preko **internih load balancera** koji onda omogucavaju i **horizontalno skaliranje** sto znaci da se dodatne instance mogu dodavati i uklanjati. I to onda omogucava **visoku dostupnost (highly available)**
Ako jedna instanca "padne" , load balancer redistribuira veze prema drugim "zivim" instancama.
- Ova arhitektura ipak nije savrsena zbog dva vazna razloga:
1. Slojevi su i dalje povezani, jedan od slojeva ocekuje da je njegov susjedni sloj dostupan za odgovore;
2. Ako nema poslova koji bi trebali biti procesirani, sloj za procesiranje mora imati nesto pokrenuto da bi aplikacija funkcionirala.

* * *
# 2. Arhitecture Deep Dive - part 2

- Prethodna arhitektura moze biti unaprijedjena koristenjem redova (queues).
- Red je sistem koji prima poruke (messages).
- Poruke mogu biti unaprijedjene koristenjem reda.
- Poruke mogu biti primljene u red ili izvucene iz reda.
- Poruke se primaju u FIFO arhitekturi (First-In-First-Out).
- FIFO koristi asinkronu komunikaciju: 
dok jedan sloj radi u pozadini, drugi koji zavrsi svoj posao, sprema ga u FIFO arhitekturu .
<br/>

![1](./1.png)

U nasem primjeru na kraju FIFO arhitekture nalazi Auto-Scaling grupa koja ima svoju velicinu reda (queue length) . 
Ta Auto-Scaling grupa koja ima svoju velicinu reda i setuje je na 2, tako da iz reda (Queue) izalze po 2 zadatka. Ali oni znaju i za lokaciju S3 bucketa i objekta u tom bucketu, i tako mogu primiti i glavni (master) video iz s3 bucketa.              Ove instance su procesirane i izbrisane iz reda (queue), tako da Auto Scaling grupa moze odluciti da skalira prema dole jer je pozeljna velicina reda = 2, a u redu ima samo jedna item. Zatim prime i posljednju poruku iz reda i zavrsava se sa tim procesiranjem poruke. Tada ona postavlja pozeljnu velicinu reda na 0, i to rezultira terminiranjem i zadnje instance.
<br/>
Koristenjem reda (queue) arhitekture izmedju ovih slojeva, ona u biti logicki razdvaja ove slojeve i takodjer omogucava visoku dostupnost i skaliranje, i nijedan sloj ne komunicira direktno.
To znaci da moze skalirati od 0 do beskonacno, ovisno kolika je velicina poruke u redu (queue).
Ovo je inace veoma popularna arhitektura jer koristi **asinkronu komunikaciju.**

<br/>

### Arhitektura mikroservisa

Ako nastavimo razbijati monolitnu aplikaciju na sve manje dijelove doci cemo do pojma **arhitekture mikroservisa** , koja je u sustini kolekcija mikroservisa.

Stvar koju mikroservisi primaju i daju arhitekturalno su dogadjaji (events).
Velike arhitekture mogu postati jako kompleksne i to vrlo brzo, gdje servisi trebaju da razmjenjuju podatkeizmedju partnerskih mikroservisa.
Ako bi to uradili sa redom - to bi radilo , ali bi bilo prekompleksno.

<br/>

### Event-Driven arhitektura

![2](./2.png)

Zato se uvodi pojam Event-Driven arhitekture koja je samo kolekcija od kreatora dogadjaja (events) koji mogu biti komponente aplikacije, ili sistem za nadzor komponenti i to je samo jedan dogadjaj . 
Proizvodjac (producer) su stvari koji proizvode dogadjaje , a suprotno od tog su potrosaci koji cekaju da se dogadjaj pojavi i ako vide dogadjaj, oni ce nesto poduzeti i pokrenuti taj dogadjaj i zavrsiti ga.
Oni ne konzumiraju resurse konstantno, jer bi to bilo previse.
Najbolja praksa je da izmedju njih postoji Event Router koji je visoko dostupan i centralno mjesto za razmjenjivanje dogadjaja , koji mozemo zamisliti kao konstantni protok informacija . 
Kad su dogadjaji generirani od Producer-a , Event Router koji je visoko dostupan ai cenralno mjesto za razmjenjivanje poruka, mozemo ga zamisliti kao konstantni protok informacija.
Kad su dogadjaji generirani od Producer-a, Event Router alocira te resurse i skalira komponente kako je potrebno.

<br/>

- Event-Driven arhitekture konzumiraju samo resurse kada su oni potrebni:
1. Zato nema nista da je konstantno pokrenuto ili da ceka neke stvari.
2. Producers generiraju dogadjaje kad se nesto dogodi.
3. Dogadjaji su dostavljeni Consumerima preko Event Routera.

**- Zakljucak:**
**Event-driven arhitektura konzumira samo resurse dok "hendla" dogadjaje!**
I to je kljucan dio **serverless arhitekture.**
* * *
# 3. AWS Lambda - part 1

- Lambda funkcionira kao usluga ili brzi protokol, a to znaci da sa njom pruzamo specijalizirani kratki kod Lambdi i onda ona preuzima brigu da ga pokrece i naplacuje ti samo ono sto potrosis 
