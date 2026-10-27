# Changelog

## 1.0.4

- `/schuif` en radiaaloptie werken in beide richtingen tussen de twee voorstoelen.
- Doelstoel wordt per poging vastgelegd en op bezetting gecontroleerd.
- Voorafgaande CanShuffleSeat- en generieke taakindex-2-blokkeringen verwijderd; de native voert de poging uit met een begrensde time-out.
- Automatische stoelblokkering wordt direct hersteld na terugschuiven.
- Configteksten en gebruikersdocumentatie aangepast voor beide richtingen.
- Bridge 1.0.9 blijft bruikbaar.


## 1.0.3

- Fout in de stoelcontrole opgelost: `CanShuffleSeat` ontvangt nu stoelindex 0 in plaats van het ped-ID.
- Herstelt onterechte blokkering van `/schuif` en de radiaaloptie.
- Bridge 1.0.9 en bestaande configuratie blijven bruikbaar.


## 1.0.2

- Automatische stoelwissel naar de bestuurder geblokkeerd.
- `/schuif` toegevoegd voor de voorste passagier met een vrije bestuurdersstoel.
- Contextafhankelijke radiaaloptie via ts_bridge toegevoegd.
- ts_bridge 1.0.9+ vereist; configuratie toegevoegd in `config/config.lua`.
- Controle op doodstatus, stoelbezetting, dubbele acties en een schuiftime-out.
- Documentatie bijgewerkt; changelog blijft in `docs`.

## 1.0.1

- Resourceversie, auteur en omschrijving toegevoegd aan `fxmanifest.lua`.
- Server-side versiechecker toegevoegd voor de laatste stabiele GitHub-release.
- Numerieke versievergelijking, foutafhandeling en een wachttijdlimiet toegevoegd.
- Versiecontrole uitschakelbaar via `set ts_nohelmet_version_check 0`.
- GitHub-README toegevoegd met werking, vereisten en snelle installatie.
- Uitgebreide installatie- en updatehandleiding toegevoegd in `docs/INSTALLATIE.md`.
- Bestaande clientwerking behouden.

## 1.0.0

- Eerste versie: automatische GTA V-helm uitschakelen via de client.

