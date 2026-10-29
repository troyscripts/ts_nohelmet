# Installatie — ts_nohelmet 1.0.5

## Benodigd

FiveM voor GTA V, ox_lib en **ts_bridge 1.0.9 of nieuwer**. Installeer de bridge onder de resourcenaam `ts_bridge`, ook al heet de GitHub-repository `ts_brigde`. ts_nohelmet heeft zelf geen ESX-, inventory- of databasekoppeling. Houd voor de overige bridgefuncties de bestaande serverinstellingen aan.

## Installeren / bijwerken

1. Maak een back-up van beide resources en je eigen bridgeconfiguratie/webhooks.
2. Stop `ts_nohelmet`.
3. Installeer eerst de bridge-update. Het bridgeconfigschema blijft **0.0.8**; de bestanden in `config/` zijn niet gewijzigd en kunnen behouden blijven.
4. Vervang ts_nohelmet door versie 1.0.5, inclusief de nieuwe map `config`.
5. Neem ook de bijgewerkte `ts_nohelmet/config/config.lua` over (aangepaste menutekst en meldingen) en zet je eigen instellingen terug.
6. Start resources in deze volgorde:

```cfg
ensure ox_lib
ensure ts_bridge
ensure ts_nohelmet
```

Bij een bestaande server: gebruik `refresh` na uploaden en plan een volledige serverherstart, omdat ook andere scripts van ts_bridge afhankelijk zijn. Er is geen SQL-migratie nodig. Plaats `fxmanifest.lua` rechtstreeks in iedere resource-map; vermijd dubbele submappen.

## Gebruik

- Als de bestuurder uitstapt of doodgaat, schuif je niet automatisch door.
- Gebruik `/schuif` vanaf de voorste passagiersstoel om naar de bestuurdersstoel te gaan, of vanaf de bestuurdersstoel om terug naar de passagiersstoel te gaan.
- Of open je ox_lib-radiaalmenu en kies **Wissel voorstoel**.
- De andere voorstoel moet vrij zijn. Ook een overleden inzittende telt als bezet totdat die uit het voertuig is gehaald.
- Dode/bewusteloze spelers kunnen niet schuiven. De bridge gebruikt hiervoor native doodstatus plus de geconfigureerde `DeadStateKeys`.
- Je blijft afhankelijk van de bestaande voertuig-/sleutelscripts om te kunnen rijden.
- Achterpassagiers worden niet naar voren geteleporteerd. De GTA-schuifanimatie moet door het voertuig worden ondersteund.

## Configuratie

| Instelling | Standaard | Betekenis |
| --- | --- | --- |
| `DisableAutomaticHelmet` | `true` | Automatische GTA-helm voorkomen |
| `PreventAutoShuffle` | `true` | Automatisch doorschuiven voorkomen |
| `ShuffleCommand` | `'schuif'` | Command zonder slash; `false` schakelt alleen het command uit |
| `ShuffleTimeoutMs` | `8000` | Positieve duur in milliseconden voor een schuifpoging |
| `Radial.Enabled` | `true` | Radiaaloptie aan/uit |
| `Radial.Label` / `Radial.Icon` | Tekst / `chair` | Menunaam en Font Awesome-icoon |
| `Messages` | Nederlands | Meldingen aanpassen |

Herstart ts_nohelmet na wijzigingen. Schuiven kan ook handmatig wanneer de automatische blokkering is uitgezet.

Voor de optionele versiecontrole geldt dezelfde serverinstelling als in 1.0.1:

```cfg
set ts_nohelmet_version_check 0
```

`0` = uit; `1` = aan. Plaats dit boven `ensure ts_nohelmet`. De checker meldt fouten alleen in de serverconsole en verandert geen bestanden.

## Controle na installatie

1. Test met twee spelers: één rijdt, één zit rechtsvoor. Laat de bestuurder uitstappen; de passagier moet blijven zitten.
2. Herhaal met een overleden bestuurder. Zolang de stoel nog bezet is, mag `/schuif` niemand verwijderen. Haal de bestuurder uit het voertuig en controleer dat de passagier nog steeds blijft zitten.
3. Gebruik `/schuif` en controleer de animatie naar de bestuurdersstoel.
4. Herhaal via het radiaalmenu. De optie verdwijnt tijdens het schuiven, bij uitstappen of als de andere voorstoel bezet is. Test ook de terugweg naar de passagiersstoel: je moet daar blijven zitten zonder automatisch terug te schuiven.
5. Test een bezette stoel, achterbank, doodstatus en herhaald commandgebruik.
6. Test respawn/personagewissel en een resource-herstart. Controleer ook de automatische motorhelm.

## Probleemoplossing

| Probleem | Controle |
| --- | --- |
| Geen radiaaloptie / export ontbreekt | Installeer ts_bridge 1.1.1+ (fix voor exportcallbacks), controleer `Radial.Enabled` en of je op een voorstoel zit en de andere voorstoel vrij is. |
| Resource start niet | Controleer ox_lib, ts_bridge, de manifestbestanden en de startvolgorde. |
| Dode speler kan toch schuiven | Controleer `DeadStateKeys` in de bridge voor jouw ambulancescript. |
| Stoel is bezet | De andere voorstoel moet vrij zijn; dit script verwijdert geen inzittenden. |
| Schuiven mislukt | Voertuig ondersteunt mogelijk geen shuffle of een ander script onderbreekt de animatie. |
| Automatisch schuiven gebeurt nog | Controleer `PreventAutoShuffle` en andere scripts die configflag 184 of stoelposities aanpassen. |
| Een bestaande helm blijft staan | Verwacht: alleen automatisch opzetten wordt uitgeschakeld. |
| Versiechecker meldt HTTP 404 / netwerkfout | Geen publieke release bereikbaar; gameplay blijft werken. |

## Verwijderen

Stop ts_nohelmet en verwijder de `ensure`-regel. De eigen radiaaloptie wordt verwijderd en de eerder opgeslagen stoelvlag hersteld. Een helmstatus kan op de huidige ped blijven staan tot een herverbinding. Verwijder ts_bridge niet als andere resources die gebruiken.
