# Integration des IServ LDAP in Relution
### zur Übernahme der Nutzer und Gruppen aus IServ z.B. um BYOD-Geräte und Apps diesen zuzuordnen oder von Relution aus den IServ-Accounts managed bzw. "verwaltete" Apple-IDs generieren zu lassen.

Wir, als kommunaler Schulträger, verwenden für unsere Schulen [IServ](https://iserv.de/) um vielen Anforderungen der IT, Schulleitung, Mitarbeiter, Schüler, Eltern und des Kollegiums gerecht zu werden.  
Hierfür werden aus [Sibank](https://haneke.de/sibank-schulverwaltungs-Software.html) Tabellen der Schülernamen mit Klassenzuordnung exportiert und per Import im IServ die Schüler angelegt bzw. die Klassenzugehörigkeit einsortiert.  
Damit erhalten die Schüler einen Account mit umfangreichen Funktionen wie Emails, Cloud-Dateiablage, Videokonferenzen, Hausaufgaben etc. sowie zur Anmeldung an den schuleigenen Rechnern und dem WLAN.

Als Mobile-Device-Management (MDM) bzw. Unified-Endpoint-Management für die schuleigenen iPads (Klassensätze, Lehrergeräte und für bedürftige Schüler) sowie eine vielzahl von Bring-Your-Own-Device (BYOD)-Geräten setzen wir allerdings nicht die IServ-eigene Verwaltung (wie bei Windows-PCs) ein sondern [Relution](https://relution.io/).   
Dieses wird auf einem dedizierten Server betrieben, der mit Hilfe der in diesem Repository vorhandenen Konfigurationsdateien betrieben werden kann. **Insbesondere ist diese Konfiguration darauf ausgelegt die Nutzer und Gruppen aus dem IServ in Relution zu übernehmen um so eine Mehrarbeit bei der Datenpflege zu vermeiden.**    
Des Weiteren ist Relution in der Lage aus den in Relution vorhandenen Accounts mittels Apples SFTP-Upload automatisch managed bzw. "verwaltete" Apple-IDs zu generieren welche dann z.B. für Shared-iPads oder 200GB gratis Speicher in der iCloud pro Schüler genutzt werden können.

## Installation des Relution-Systems via Docker Compose auf einem Ubuntu Server 20.04 Host
* [Docker installieren.](https://docs.docker.com/engine/install/ubuntu/)
* [Docker Compose installieren.](https://docs.docker.com/compose/install/)
* ```sudo docker network create nat```
* Den Inhalt des "opt"-Ordners aus dem Repo nach ```/opt``` auf Host kopieren.
* Die Variablen in allen Konfig-Dateien anpassen. [TODO: Variablen klar kennzeichnen!]
* Relution starten: ```sudo ./relution-start.sh```.

Weitere Infos in der [offiziellen Relution-Dokumentation](https://repo.relution.io/docs/latest/relution-installguide/docker_installation/Docker_Compose_Linux.html).

## Firewall einstellen
* UFW installieren: ```sudo apt update && sudo apt install ufw -y```.
* Alles verbieten: ```sudo ufw default deny```
* Ausnahmen für tatsächlich genutzte Ports hinzufügen:
~~~
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
~~~
* Firewall aktivieren: ```sudo ufw show && sudo ufw enable && sudo ufw status```

### TODO: Autostart, Caddy & LDAP-Abgleich!
