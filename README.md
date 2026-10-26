# Troy Scripts — ts_nohelmet

**Versie 1.0.1** · Standalone FiveM-resource voor GTA V

Voorkom dat GTA V automatisch een motorhelm opzet wanneer een speler op een motor of scooter stapt. Handig voor roleplayservers waarop spelers hun eigen kleding en hoofddeksels kiezen.

## Wat doet het script?

- Schakelt de automatische helmfunctie uit voor de lokale speler.
- Past dit elke seconde opnieuw toe op de huidige speler-ped, ook na een personagewissel of respawn.
- Werkt zonder commands, menu's of database.
- Controleert bij iedere resource-start één keer server-side op een nieuwe stabiele GitHub-release.

Het script verwijdert geen bestaande helm of kledingaccessoires. Het blokkeert ook geen helm die een ander script expliciet aantrekt. De bestaande clientwerking blijft in 1.0.1 gelijk.

## Wat heb je nodig?

| Onderdeel | Vereist? |
| --- | --- |
| Werkende FiveM-server voor GTA V met actuele FXServer-artifacts | Ja |
| Toegang tot `resources` en `server.cfg` of je resources-config | Ja |
| ESX / QBCore | Nee, werkt standalone en naast beide frameworks |
| ox_lib / ox_inventory / ts_bridge | Nee |
| Database / SQL / extra npm-packages | Nee |
| Uitgaand HTTPS-verkeer naar `api.github.com` | Alleen voor de versiecontrole |

Dit is een serverresource met clientcode: installeer hem op je FiveM-server, niet in de GTA V-map van spelers. De server levert de clientcode aan aangesloten spelers. Alleen de versiechecker draait op de server.

## Snel installeren

1. Download de [laatste release](https://github.com/troyscripts/ts_nohelmet/releases).
2. Pak de resource uit naar `resources/[standalone]/ts_nohelmet`.
3. Zorg dat `fxmanifest.lua` direct in `ts_nohelmet` staat.
4. Voeg aan je `server.cfg` of ingeladen resources-config toe:

```cfg
ensure ts_nohelmet
```

5. Herstart de server, of voer `refresh` en daarna `ensure ts_nohelmet` uit in de serverconsole.

Zie **[de volledige installatiehandleiding](docs/INSTALLATIE.md)** voor updaten, controle, probleemoplossing en het publiceren van releases.

## Versiecontrole

De checker vergelijkt de manifestversie met de tag van de laatste stabiele GitHub-release. Updates worden alleen gemeld in de serverconsole; er worden geen bestanden automatisch gedownload of uitgevoerd. Drafts en prereleases worden niet gebruikt.

De repository en de release moeten publiek bereikbaar zijn. Bij een privérepository, ontbrekende release, netwerkfout of GitHub-limiet blijft de helmfunctie gewoon werken. Er is geen GitHub-token nodig en er worden geen spelergegevens meegestuurd.

Optioneel uitschakelen, **boven** `ensure ts_nohelmet`:

```cfg
set ts_nohelmet_version_check 0
ensure ts_nohelmet
```

Standaard is de controle ingeschakeld (`1`). Herstart de resource na een wijziging.

## Bestanden

| Bestand | Functie |
| --- | --- |
| `fxmanifest.lua` | Resourcegegevens en versienummer |
| `client.lua` | Automatische helm uitschakelen |
| `server/version_check.lua` | Controle op nieuwe releases |
| `docs/INSTALLATIE.md` | Uitgebreide installatie en beheer |
| `CHANGELOG.md` | Wijzigingen per versie |

## Ondersteuning

Meld problemen via [GitHub Issues](https://github.com/troyscripts/ts_nohelmet/issues). Vermeld je scriptversie, de consolemelding en eventuele kleding- of helmscripts die tegelijk draaien.

[Changelog bekijken](CHANGELOG.md)
