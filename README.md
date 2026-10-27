# Troy Scripts — ts_nohelmet

**Versie 1.0.4** · FiveM voor GTA V

Voorkomt de automatische motorhelm én het automatisch doorschuiven naar de bestuurdersstoel wanneer de bestuurder uitstapt of overlijdt. Passagiers blijven op hun eigen plek. Wil je zelf van voorstoel wisselen? Gebruik **`/schuif`** of **Wissel voorstoel** in het ox_lib-radiaalmenu, gekoppeld via ts_bridge.

## Functies

- Automatische GTA-motorhelm uitschakelen; bestaande kleding blijft behouden.
- Automatisch doorschuiven naar de bestuurdersstoel blokkeren.
- Handmatig met de GTA-animatie wisselen tussen de bestuurdersstoel en de voorste passagiersstoel, in beide richtingen.
- De radiaaloptie verschijnt alleen wanneer schuiven beschikbaar is.
- Controle op overlijden/laststand via ts_bridge, bezette stoel en instappen; maximaal één schuifpoging tegelijk.
- Versiechecker: controleert één keer bij de resource-start op een nieuwe stabiele GitHub-release. Geen automatische installatie.

De andere voorstoel moet vrij zijn. Ook een overleden inzittende houdt die stoel bezet. Het script verwijdert of verplaatst geen andere spelers. Achterpassagiers kunnen niet met `/schuif` naar voren teleporteren. Het script geeft geen voertuigsleutels en verandert geen voertuigtoegang.

## Vereisten

| Onderdeel | Vereist |
| --- | --- |
| Werkende FiveM-server voor GTA V met actuele FXServer-artifacts | Ja |
| ts_bridge 1.0.9 of nieuwer | Ja, resource-map moet `ts_bridge` heten |
| ox_lib | Ja, voor ts_bridge en het radiaalmenu |
| ESX / QBCore | Niet direct door ts_nohelmet; de bridge moet passend geconfigureerd zijn |
| ox_target / ox_inventory / SQL | Geen directe dependency van ts_nohelmet |
| Uitgaand HTTPS naar api.github.com | Alleen voor de versiechecker |

De standaardconfiguratie van ts_bridge bevat ESX- en andere integraties. Gebruik de bestaande bridgeconfiguratie van je server; zet ongebruikte modules passend uit op een standalone server. Zie de bridgehandleiding.

## Installeren

1. Installeer ox_lib en de bijgewerkte ts_bridge.
2. Pak de map `ts_nohelmet` uit in je serverresources.
3. Controleer `config/config.lua` en zet de startvolgorde in je serverconfig:

```cfg
ensure ox_lib
ensure ts_bridge
ensure ts_nohelmet
```

De standaardtoets voor het ox_lib-radiaalmenu is doorgaans `Z`; een eigen keybinding kan daarvan afwijken. Gebruik het bestaande ox_lib-menu op je server. Koppeling met een ander radiaalmenu is niet inbegrepen.

**[Volledige installatiehandleiding](docs/INSTALLATIE.md)** · **[Changelog](docs/CHANGELOG.md)**

## Instellingen

Alle gameplay-instellingen, het command, de menutekst en meldingen staan in `config/config.lua`. De automatische helm en stoelblokkering zijn afzonderlijk aan/uit te zetten. `/schuif` en het radiaalmenu zijn ook afzonderlijk uit te schakelen.

De versiecheck kan via de serverconfig worden uitgezet, boven `ensure ts_nohelmet`:

```cfg
set ts_nohelmet_version_check 0
```

Zonder bereikbare publieke GitHub-release meldt de checker dit in de serverconsole; de gameplay blijft werken.

## Bestanden

| Bestand | Functie |
| --- | --- |
| `fxmanifest.lua` | Versie, scripts en bridge-dependency |
| `config/config.lua` | Gameplay, command, radiaaloptie en teksten |
| `client.lua` | Helm, stoelblokkering en handmatig schuiven |
| `server/version_check.lua` | Versiecontrole |
| `docs/INSTALLATIE.md` | Installeren, updaten en controleren |
| `docs/CHANGELOG.md` | Versiegeschiedenis |

Andere scripts die de helm of ped-configflag 184 overschrijven of stoelwissels afdwingen kunnen conflicteren. Gebruik één script voor deze automatische stoelblokkering.

Problemen melden: [GitHub Issues](https://github.com/troyscripts/ts_nohelmet/issues). Vermeld beide scriptversies en de relevante consolemelding.

Na terugschuiven naar de passagiersstoel wordt de automatische stoelblokkering direct hersteld. Je schuift dus niet vanzelf weer naar de bestuurdersstoel. Op voertuigen zonder geschikte schuifanimatie stopt de poging na de ingestelde time-out.
