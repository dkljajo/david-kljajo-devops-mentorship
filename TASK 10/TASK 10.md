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
- Za razliku od monolitne arhitekture imamo i slojevitu arhitekturu.
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

- Lambda funkcionira kao usluga ili brzi protokol, a to znaci da sa njom pruzamo specijalizirani kratki kod Lambdi i onda ona preuzima brigu da ga pokrece i naplacuje ti samo ono sto potrosis.
- Lambda funkcija je u biti dio koda koji ona pokrece i svaka Lambda funkcija uzima podrzano vrijeme izvrsavanja (npr. : Python 3.8.)
- Znaci da su funkcije preuzete i pokrenute u okruzenje vremena izvrsavanja, koje je specificno kreirano da pokrece kod koristeci odredzeno vrijeme izvrsavanja i odredjeni programski jezik.
- Kada kreiramo Lambda funkciju ujedno definiramo i odredjene resurse koji su pokrenuti u vremenu izvrsavanja , tako da alociramo direktno i odredjeni dio memorije i na osnovu te memorije i odredjeni dio CPU-a.
- Lambda naplacuje samo period vremena koji ta funkcija koristi.
- Lambda je kljucni dio serverless ili event-driven arhitekture.
- Kada zamisljamo kako Lambda funkcionira treba je zamisliti kao kod plus sve asocirane biblioteke i konfiguracije.
- Kada pokrenemo Lambdu definiramo i jezik u kojem je ta funkcija napisana.
- Kad je Lambda funkcija pozvana , ustvari se dogadja da paket za "deplojanje" je preuzet i izvrsen u njegovom vremenu izvrsavanja.
- Lambda podrzava mnogo programskih jezika:
Python, Ruby , Java, Go, C#, Rust,...
- Docker je u biti suprotan Lambdi.
- Lambda moze koristiti Docker slike, ali se to mora razlikovati od znacenja rijeci Docker, jer su to dvije potpuno razlicite stvari.
- Docker se u biti odnosi na rad sa kontejnerima, tj. Docker sliku koristimo u okruzenju kontejnera , kao sto je ECS.
- Svaki put kada je Lambda pozvana novo vrijeme izvrsavanja (runtime) je kreirano sa svim komponentama koje Lambda treba.
- Lambda funkcije su stateless , sto znaci da nijedan podatak nije ostavljen iz prethodnog poziva funkcije.
- Svaki put kada je Lambda pozvana, onda se kreira novi runtime (vrijeme izvrsavanja) .
- Svaki put za Lambdu alociramo i odredjene resurse.
- Mi sa Lambdom direktno kontroliramo alociranu memorijuod njene funkcije, ali tamo gdje je virtualni CPU alociran indirektno, sto zanci da vise memorije povlaci za sobom i vise virtualnog CPU kapaciteta.
- Takodjer je alociran i odredjeni dio storage-a (hard disk), koji moze skalirati, ali to je samo trenutno (temporary).
- Lambde mogu trajati do 900 sekundi ili 15 minuta, i to je jako bitan podatak.
- Svaka Lambda funkcija ima i svoju Rolu, koju kacimo na specificnu funkciju.

<br/>

- Lambda USE CASES:
1. Serverless aplikacije: S3, API Gateway, Lambda;
2. Procesiranje dokumenata : S3, S3 Events, Lambda;
3. Trigeri baza podataka: DynamoDB, Streamovi, Lambda;
4. Serverless CRON jobovi: Event Bridge;
5. Procesiranje podataka u realnom vremenu sa Lambdom: (Kinesis + Lambda)

* * *
# 3. AWS Lambda - part 2

- Lambda moze funkcionirati u 2 mrezna moda:
1. javni (public) mod - koji je default;
2. VPC (Virtual Private Cloud).

1. Na javnom pristupu moze pristupiti javnim AWS servisima i javnom Internetu.
- Javni mrezni pristup pruza najbolje performanse jer specificni korisnicki VPC nije potreban. Ali zato Lambda funkcije nemaju pristup VPC orjentiranim servisima, jedino u slucaju ako imaju javnu IP adresu i dozvoljene permisijevanjskom pristupu, i to je veliki hendikep.
2. Ako je Lamda konfigurirana unutar VPC-ija i subneta, Lambda funkcije se pridrzavaju svih VPC mreznih pravila i mogu pristupiti svim resursima unutar tog VPC. Ali zato ne mogu pristupiti svim resursima van VPC, osim u slucaju preko gateway endpointa ili preko NAT Gateway-a.
<br/>

- Lambda se u VPC tretira kao bilo koji drugi resurs unutar VPC-ija.
<br/>

### Sigurnost Lambda funkcija:

- Po defaultu Lambda ima "egzekucijsku" rolu za sigurnost, slicnu kao sto ima EC2 instanca svoju rolu.
- Ali Lambda ima i policy resursa koji kontroliraji:
- STA servisi i nalozi mogu POKRENUTI od Lambda funkcija.
- Permisije se mogu rucno promjenuti kroz CLI ili API.

### Logovi

- Lambda za logove koristi: Cloudwatch, Cloudwatch logs i X-Ray
- Cloudwatch Logs koji zahtjevaju permisije preko EXecution role;
Logovi iz Lambda egzekucija idu na CLoudwatch Logs.
- Metrke su pohranjene u Cloudwatch.
- Lambda moze biti integrirana sa X-Ray.

* * *
# 5. AWS Lambda - part 3

Postoje 3 metode za pozivanje Lambde :
1. Sinkrono pozivanje;
2. Asinkrono pozivanje;
3. Event-source mapiranje.

1. Kod sinkronog pozivanja Lambde preko CLI/API pozivamo Lambda funkcije, prosljedjujuci podatke i cekajuci odgovor.
Lambda tada vraca podatke bili oni uspjesni ili neuspjesni.
Moguce je i pozivanje Lambde kroz API Gateway , ali je princip isti:
rezultat se vraca kao uspjesan ili neuspjesan i vracen je za vrijeme request-a.
Sinkorna komunikacija je izvrsena kada covjek direktno ili indirektno poziva Lambda funkciju.
2. Asinkrona komunikacija se tipicno dogadja kada AWS servis poziva Lambda funkciju.
- Primjer je kada S3 poziva Lambdu, koji tada ne ceka nikakav odgovor.
Dogadjaj (event ) je generiran i S3 prestaje pracenje.
Recimo da Lambda koristi DynamoDB kao nerelacionu bazu podataka.
Ako procesiranje dogadjaja padne, Lambda ce pokusati ponovno izmedju 0 i 2 puta kao sto je i podeseno.
- Inace, Lambda koristi logiku ponavljanja.
- Kod mora biti "idempotent" , a to znaci da koliko god se puta izvrsava, izlaz mora biti isti.
- Idealno bi bilo kada bi Lambda zavrsila u pozeljnom stanju (desired state).
- Novi feature Lambde je mogucnost da kreira destinacije (SQS, SNS, Lambda i Event Bridge), gdje uspjesan ili neuspjesan dogadjaj moze biti poslan.
3. Event Source mapiranje
- Ono je tipicno uradjeno za strimanje ili redove (queues).
- Primjer je kada  Kinesis strimanje podataka posalje batch iz izvora u Event Source mapping, te ga onda prosljedjuje kao batch dogadjaja Lambdi.
- 
<br/>

### Lambda verzije

- Mozemo imati verzije funkcije Lambda: V1, V2, V3,...
- Verzija je u biti: kod + konfiguracija Lambda funkcije.
- Verzije su nepromjenjive - jednom kad je publicirana nikad se vise ne mjenja i ima svoj ARN.
- $Latest - pokazuje na zadnju verziju.
- Aliasi se mogu mjenjati i pokazuju na odredjenu verziju, npr: DEV, STAGE, PROD.
- Kada je Lambda pozvana (recimo iz S3), taj koncept ekzekucije mora biti napravljen i kofiguriran.
Prvo se kreira okruzenje, a onda se skida zadnja verzija programskog jezika (npr: Python 3.8).
Zatim se skida paket deploymenta i instalira se - i taj proces se zove COLD START (cca. 100 mili sekundi).
Poslije slijedi proces koji se zove WARM START, koji ne treba pravljenje okruzenja ili skidanje paketa, itd.
Tu onda dogadjaj (Event) pocinje odmah procesiranje (cca: 1-2 mili sekunde).
Moze se tada upotrijebiti proces "Provisioned concurrency" da se nebi stvarao COLD START vise puta i on kreira i sacuvava WARM START kontekst , koji je spreman za upotrebu i tako znacajno unapredjuje brzinu samog starta.
