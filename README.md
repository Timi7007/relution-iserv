# Integration des IServ LDAP in Relution
### zur Übernahme der Nutzer und Gruppen aus IServ z.B. um BYOD-Geräte und Apps diesen zuzuordnen oder von Relution aus den IServ-Accounts managed bzw. "verwaltete" Apple-IDs generieren zu lassen.

Wir, als kommunaler Schulträger, verwenden für unsere Schulen [IServ](https://iserv.de/) um vielen Anforderungen der IT, Schulleitung, Mitarbeiter, Schüler, Eltern und des Kollegiums gerecht zu werden.  
Hierfür werden aus [Sibank](https://haneke.de/sibank-schulverwaltungs-Software.html) Tabellen der Schülernamen mit Klassenzuordnung exportiert und per Import im IServ die Schüler angelegt bzw. die Klassenzugehörigkeit einsortiert.  
Damit erhalten die Schüler einen Account mit umfangreichen Funktionen wie Emails, Cloud-Dateiablage, Videokonferenzen, Hausaufgaben etc. sowie zur Anmeldung an den schuleigenen Rechnern und dem WLAN.

Als Mobile-Device-Management (MDM) bzw. Unified-Endpoint-Management für die schuleigenen iPads (Klassensätze, Lehrergeräte und für bedürftige Schüler) sowie eine vielzahl von Bring-Your-Own-Device (BYOD)-Geräten setzen wir allerdings nicht die IServ-eigene Verwaltung (wie bei Windows-PCs) ein, sondern [Relution](https://relution.io/).   
Dieses wird auf einem dedizierten Server betrieben, der mit Hilfe der in diesem Repository vorhandenen Konfigurationsdateien betrieben werden kann. **Insbesondere ist diese Konfiguration darauf ausgelegt die Nutzer und Gruppen aus dem IServ in Relution zu übernehmen um so eine Mehrarbeit bei der Datenpflege zu vermeiden.**    
Des Weiteren ist Relution in der Lage aus den in Relution vorhandenen Accounts mittels Apples SFTP-Upload automatisch managed bzw. "verwaltete" Apple-IDs zu generieren welche dann z.B. für Shared-iPads oder 200GB gratis Speicher in der iCloud pro Schüler genutzt werden können.

## Installation des Relution-Systems via Docker Compose auf einem Ubuntu Server 20.04 Host
* [Docker installieren.](https://docs.docker.com/engine/install/ubuntu/)
* [Docker Compose installieren.](https://docs.docker.com/compose/install/)
* ```sudo docker network create nat```
* Den Inhalt des "opt"-Ordners aus dem Repo nach ```/opt``` auf Host kopieren.
* Die Variablen in allen Konfig-Dateien anpassen. [TODO: Variablen klar kennzeichnen!]
  * Die Konfig-Dateien basieren auf den [offiziellen Vorlagen von Relution](https://github.com/relution-io/relution-setup/tree/master/docker/Linux/opt/relution), es wird jedoch [Caddy](https://caddyserver.com/) statt Nginx als Reverse-Proxy genutzt, um Konfigurationsaufwand (insbesondere im Bezug auf TLS-Zertifikate für HTTPS) zu vermeiden. Es wird automatisch ein [Let’s Encrypt](https://letsencrypt.org/)-Zertifikat erstellt.
* Relution starten: ```sudo ./relution-start.sh```.

Weitere Infos in der [offiziellen Relution-Dokumentation](https://repo.relution.io/docs/latest/relution-installguide/docker_installation/Docker_Compose_Linux.html).

## Firewall einstellen (optional)
* UFW installieren: ```sudo apt update && sudo apt install ufw -y```.
* Alles verbieten: ```sudo ufw default deny```
* Ausnahmen für tatsächlich genutzte Ports hinzufügen:
~~~
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
~~~
* Firewall aktivieren: ```sudo ufw show && sudo ufw enable && sudo ufw status```

## Autostart & -update (optional)
* ```sudo crontab -e```
* Mittels des gewählten Editors folgende Einträge anlegen:
  * ```@reboot /pfad/zu/relution-start.sh``` startet Relution beim Hochfahren des Hosts.
  * ```0 2 * * * /pfad/zu/relution-stop.sh && /pfad/zu/relution-start.sh >/dev/null 2>&1``` startet Relution jeden Morgen um 02:00 Uhr neu. Hierdurch werden auch Updates gemacht.
    * Automatische Updates lassen sich durch das Anpassen der ```relution-start.sh``` deaktivieren. Für Testserver mögen diese sinnvoll sein, im Produktivbetrieb jedoch nicht unbedingt.

### LDAP-Abgleich!
*Hier ist noch einiges an Dokumentation nachzuholen.*
* Auf dem IServ muss ein Nutzer mit dem Benutzernamen ```ldap.relution``` erstellt werden, dazu einfach ```ldap``` als Vornamen nehmen, ```relution``` als Nachnamen. Der Nutzer benötigt ein permanentes Passwort, welches z.B. durch eine einmalige Anmeldung erstellt werden kann. Dieses sollte als System-Passwort entsprechend sicher gewählt sein.
* Dieses Kennwort muss in der ```/opt/relution/application.yml``` unter ```_ldap_password:``` auf dem Docker-Host hinterlegt werden.
* Die Datei ```set-ldap-peers.sh``` wird auf dem IServ platziert und in Zeile 2 statt ```relution.test``` die tatsächliche Adresse (FQDN) des Relution-Servers hinterlegt.
* Auf dem IServ muss nun ein Cronjob angelegt werden welcher das Script regelmäßig ausführt:
  * ```sudo crontab -e```
  * ```3 * * * * /pfad/zu/set-ldap-peers.sh >/dev/null 2>&1``` führt das Script immer 3 Minuten nach jeder vollen Stunde als root (Administrator) aus.

Nun sollte der IServ-Server einmal die Stunde die IP-Adresse des Relution-Servers ermitteln und ihr durch den Nutzer ```ldap.relution```, mit dem vergebenen Passwort, Rechte auf die gesamte Nutzerdatenbank geben. Dies nutzt Relution dann um die Daten abzurufen und in die eigene Datenbank aufzunehmen. Das Script prüft wiederrum ob sich in der Log-Datei des LDAP-Servers die IP des Relution-Servers findet und informiert den Administrator per E-Mail wenn es keinen Zugriff durch Relution gab, was auf ein Syncronisationsproblem hindeutet.

Ein manueller Abgleich der Datenbanken (Syncronisation) lässt sich im Relution Webinterface anstoßen:

[TODO] Screenshot
