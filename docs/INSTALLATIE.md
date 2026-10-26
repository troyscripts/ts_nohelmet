# Installatie — ts_nohelmet 1.0.1

## 1. Vereisten

Gebruik een werkende FiveM-server voor GTA V met actuele FXServer-artifacts. Je hebt toegang nodig tot de resources en de serverconfiguratie. ESX, QBCore, ox_lib, ts_bridge en een database zijn niet nodig.

Alleen de optionele versiechecker heeft uitgaand HTTPS-verkeer naar `api.github.com` nodig. De clientfunctie werkt ook wanneer GitHub onbereikbaar is.

## 2. Download en plaatsing

Download het pakket via [GitHub Releases](https://github.com/troyscripts/ts_nohelmet/releases). Pak het uit en noem de resource-map exact `ts_nohelmet`. Een GitHub-broncodearchief kan een mapnaam zoals `ts_nohelmet-1.0.1` hebben; hernoem die.

Plaats de map bijvoorbeeld onder `resources/[standalone]/ts_nohelmet`. Controleer deze paden:

- `resources/[standalone]/ts_nohelmet/fxmanifest.lua`
- `resources/[standalone]/ts_nohelmet/client.lua`
- `resources/[standalone]/ts_nohelmet/server/version_check.lua`
- `resources/[standalone]/ts_nohelmet/README.md`
- `resources/[standalone]/ts_nohelmet/CHANGELOG.md`
- `resources/[standalone]/ts_nohelmet/docs/INSTALLATIE.md`

Voorkom een dubbele map zoals `ts_nohelmet/ts_nohelmet/fxmanifest.lua`.

## 3. Starten

Voeg het volgende één keer toe aan `server.cfg`, of aan een resources-config die via `exec` wordt geladen:

```cfg
ensure ts_nohelmet
```

Er is geen framework-afhankelijke startvolgorde. Herstart de server of voer deze commands achter elkaar uit in de **serverconsole/txAdmin Live Console**:

```text
refresh
ensure ts_nohelmet
```

## 4. Controleren in het spel

1. Verbind met de server en gebruik een personage zonder helm.
2. Wacht minimaal één seconde zodat de clientlus is uitgevoerd.
3. Stap op een motor of scooter en wacht op het moment waarop GTA normaal een helm opzet.
4. Controleer dat er geen automatische helm verschijnt.
5. Herhaal na een respawn of personagewissel.

Een bestaande helm wordt niet verwijderd. Verwijder die eerst via je kledingmenu als je de automatische helm wilt testen. Andere scripts kunnen een helm expliciet aantrekken of de GTA-helmfunctie weer inschakelen.

## 5. Versiecontrole instellen

Standaard wordt één keer per resource-start de laatste stabiele release opgehaald. De checker gebruikt de `version` in `fxmanifest.lua` en vergelijkt de drie versiedelen numeriek: `1.0.10` is dus nieuwer dan `1.0.9`.

Uitschakelen:

```cfg
set ts_nohelmet_version_check 0
ensure ts_nohelmet
```

Weer inschakelen: verander `0` naar `1` en herstart de resource. Gebruik `set`, niet `setr`: de instelling is alleen voor de server.

Consolemeldingen kunnen aangeven dat de versie actueel is, dat er een update beschikbaar is, of dat de lokale versie vooruitloopt op de gepubliceerde release. Bij een onbereikbare API, een HTTP-fout of ongeldige gegevens wordt alleen een melding geschreven. Na 15 seconden stopt de checker met wachten op een bruikbaar resultaat; een late reactie wordt genegeerd. Er volgt geen herhaalde polling.

### Releases publiceren als beheerder

1. Neem de goedgekeurde releasebestanden op in `main`.
2. Controleer dat `fxmanifest.lua` de bedoelde versie bevat, voor deze release `1.0.1`.
3. Zorg dat de repository openbaar is als gebruikers de ingebouwde checker moeten kunnen gebruiken. Een privérepository geeft zonder authenticatie doorgaans HTTP 404.
4. Maak via GitHub Releases een release met tag `v1.0.1` op de juiste commit. Gebruik voor volgende versies bijvoorbeeld `v1.0.2`; ook `1.0.2` zonder `v` is toegestaan.
5. Publiceer als stabiele release, niet als draft of prerelease, en wijs de bedoelde nieuwste stabiele release aan als latest.
6. Controleer na een resource-herstart of de server de versie als actueel meldt.

Alleen een commit of tag maken is onvoldoende: de checker gebruikt **GitHub Releases**, niet de versie op `main`. Bewaar geen GitHub-token in deze resource. Als de code privé moet blijven, schakel de checker uit; een aparte publieke versiebron vereist een aanpassing van de checker.

## 6. Updaten

1. Maak een back-up van de bestaande resource en eventuele eigen wijzigingen.
2. Voer `stop ts_nohelmet` uit in de serverconsole.
3. Vervang de resourcebestanden door de nieuwe versie, inclusief de map `server`.
4. Behoud je instelling in `server.cfg` en voorkom dubbele `ensure`-regels.
5. Voer `refresh` en `ensure ts_nohelmet` uit.
6. Controleer de serverconsole en herhaal de test in het spel.

Voor de update naar 1.0.1 is geen SQL-migratie nodig.

## 7. Problemen oplossen

| Probleem | Controle / oplossing |
| --- | --- |
| Resource wordt niet gevonden | Controleer de mapnaam, dubbele submappen en voer `refresh` uit. |
| Serverbestand ontbreekt | Upload ook `server/version_check.lua`; alleen de client vervangen is niet voldoende. |
| Automatische helm verschijnt toch | Controleer of de resource draait, wacht één seconde en controleer andere helm-/kledingscripts. |
| Een bestaande helm blijft zichtbaar | Dat is verwacht: het script voorkomt automatisch opzetten en verwijdert geen accessoires. |
| Geen publieke release gevonden / HTTP 404 | Controleer of de repository openbaar is en een stabiele release heeft. |
| HTTP 403 of 429 | GitHub kan verzoeken beperken; probeer later opnieuw door de resource te herstarten. |
| Netwerkfout of time-out | Controleer DNS, firewall en uitgaande HTTPS-toegang naar `api.github.com`. |
| Geen versiecheckmelding | Controleer of `ts_nohelmet_version_check` op `0` staat en kijk in de serverconsole, niet F8. |

## 8. Uitschakelen / verwijderen

Verwijder `ensure ts_nohelmet` en stop de resource. De laatst ingestelde helmstatus kan op de huidige ped blijven staan; maak opnieuw verbinding om zonder deze resource te testen. Het script maakt geen databasegegevens aan.
