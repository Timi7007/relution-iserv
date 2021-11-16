# Integration des IServ LDAP in Relution
### zur Übernahme der Nutzer und Gruppen aus IServ z.B. um BYOD-Geräte und Apps diesen zuzuordnen oder von Relution aus den IServ-Accounts managed bzw. "verwaltete" Apple-IDs generieren zu lassen.

Wir, als kommunaler Schulträger, verwenden für unsere Schulen [IServ](https://iserv.de/) um vielen Anforderungen der IT, Schulleitung, Mitarbeiter, Schüler, Eltern und des Kollegiums gerecht zu werden.  
Hierfür werden aus [Sibank](https://haneke.de/sibank-schulverwaltungs-Software.html) Tabellen der Schülernamen mit Klassenzuordnung exportiert und per Import im IServ die Schüler angelegt bzw. die Klassenzugehörigkeit einsortiert.  
Damit erhalten die Schüler einen Account mit umfangreichen Funktionen wie Emails, Cloud-Dateiablage, Videokonferenzen, Hausaufgaben etc. sowie zur Anmeldung an den schuleigenen Rechnern und dem WLAN.

Als Mobile-Device-Management (MDM) bzw. Unified-Endpoint-Management für die schuleigenen iPads (Klassensätze, Lehrergeräte und für bedürftige Schüler) sowie eine vielzahl von Bring-Your-Own-Device (BYOD)-Geräten setzen wir allerdings nicht die IServ-eigene Verwaltung (wie bei Windows-PCs) ein sondern [Relution](https://relution.io/).   
Dieses wird auf einem dedizierten Server betrieben, der mit Hilfe der in diesem Repository vorhandenen Konfigurationsdateien betrieben werden kann. **Insbesondere ist diese Konfiguration darauf ausgelegt die Nutzer und Gruppen aus dem IServ in Relution zu übernehmen um so eine Mehrarbeit bei der Datenpflege zu vermeiden.** Des Weiteren ist Relution in der Lage aus den in Relution vorhandenen Accounts mittels Apples SFTP-Upload automatisch managed bzw. "verwaltete" Apple-IDs zu generieren welche dann z.B. für Shared-iPads oder 200GB gratis Speicher in der iCloud pro Schüler genutzt werden können.

### Eine Schritt-für-Schritt-Anleitung der Relution-Installation sowie dem LDAP-Abgleich folgt bei Zeiten.
