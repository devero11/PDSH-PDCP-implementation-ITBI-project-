#DESCRIEREA PROBLEMEI



  de ce e nevoie?
    --operarea mai multor sisteme/noduri in acelasi timp/in masa
    --exemplu: serviciu de servere(amazon ec2), setup multiple sisteme intr-un office



  solutii posibile:
    --reimplementare pdsh(rulare comenzi), pdcp(upload fisiere), rpdcp(download fisiere)



#SPECIFICATIA SOLUTIEI

  obiective:
    --deployment usor al nodurilor de VMuri
    --reimplementare comenzi

  mediu de rulare
    --ruleaza in terminal

  cerinte:
    --linux
    --bash
    --python
    --ssh/scp
    --kvm and qemu

  limitari:
    --setup noduri nu adauga hostname in etc/hosts
    --probabil logging system limitat

  plan evaluare:
    -- script pentru teste cu use case-uri


#DESIGN


  diagrama:
                DHCP SERVER
                     |
              BRIDGE NETWORK
            /        |        \
          Tap 1     Tap..     TapN
            |        |         |
           VM1      VM..      VMn
            \        |        /
              PDSH/PDCP/RPDCP
                     |
                USER SYSTEM


  explicatii:
    --folosim bridge network cu un server DHCP pentru a avea ip static si unic pentru fiecare vm automat
    --in lipsa unui ip unic nu avem acces la VMuri

    --am ales metoda asta in defavoarea qemu-guest-agent deoarece aceasta metoda permite conectarea universala la vmuri si sisteme
    inafara spcificatiei proiectului

  descrierea mecanismelor:
    --DHCP server ruleaza pe bridge network pentru a forta VMurile sa aiba ip static unic si sa fie accesibile pentru USER
    --Comenzile pdsh/pdcp/rpdcp se folosesc de ssh/scp pentru conectare securizata in paralel la toate nodurile. Python(AWK?) e folosit
    pentru manipularea argumentelor primite de scripturile bash.



#IMPLEMENTARE

  Stack folosit:
    --python(awk?) -manipulare stringuri
    --ssh/scp - conectare securizata la noduri
    --qemu - interfata pentru rularea VMurilor folosind kvm
    --alpine linux - distro lightweight pentru VMuri
    --git/github - version control


  probleme aparute:
    --atribuirea ipurilor unice pt VMuri
    solutie: got good
    --server dhcp blocat de firewall
    solutie: adaugare exceptie in firewall pentru dhcp





# MOD DE FOLOSIRE

!!! Funcționalitate limitată, work in progress !!!

# Setup

<br>

## `copyVM`

<br>

Scriptul `./copyVM` creează un număr specificat de copii ale unei imagini VM date.
Clonele sunt indexate de la `1` la `n`. În cazul în care scriptul este rulat de mai multe ori, indexul continuă de la ultimul clone creat.

```bash
./copyVM -i path/to/image -n 10

```

<br>

`-i` : locația imaginii VM
`-n` : numărul de clone

<br>
<br>

## `startVMs`

Scriptul `./startVMs` pornește toate VM-urile dintr-un director specificat.
De asemenea, permite configurarea unei `bridge network` și a unor `tap-uri` pentru fiecare nod VM.

!!! Important

Pentru a te asigura că fiecare nod VM primește automat un `static ip`, trebuie să ai un `dhcp server` care rulează pe `bridge network`.
Scriptul nu include mapări în `/etc/hosts` pentru fiecare nod (nu este planificat momentan, sorry :3).
`Bridge network` nu este persistentă.

```bash
./startVMs -d directory -ns -b bridgeName

```

<br>

`-d` : locația nodurilor
`-ns` : setup pentru bridge network (dacă este omis, va fi necesar setup manual pentru fiecare nod)
`-b` : numele bridge network (dacă este omis, valoarea implicită este `megatron`)

<br>
<br>

