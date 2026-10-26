# Publicatie-instructies voor Troy Scripts

Dit bestand is alleen voor de beheerder en hoort niet bij de installatiehandleiding voor gebruikers. Verwijder het vóór publicatie uit de releasebestanden. De resource werkt zonder dit bestand.

## Release publiceren

1. Neem de goedgekeurde releasebestanden op in `main`.
2. Controleer dat `fxmanifest.lua` de bedoelde versie bevat, voor deze release `1.0.1`.
3. Zorg dat de repository openbaar is als gebruikers de ingebouwde checker moeten kunnen gebruiken. Een privérepository geeft zonder authenticatie doorgaans HTTP 404.
4. Maak via GitHub Releases een release met tag `v1.0.1` op de juiste commit. Gebruik voor volgende versies bijvoorbeeld `v1.0.2`; ook `1.0.2` zonder `v` is toegestaan.
5. Publiceer als stabiele release, niet als draft of prerelease, en wijs de bedoelde nieuwste stabiele release aan als latest.
6. Controleer na een resource-herstart of de server de versie als actueel meldt.

Alleen een commit of tag maken is onvoldoende: de checker gebruikt **GitHub Releases**, niet de versie op `main`. Bewaar geen GitHub-token in deze resource. Als de code privé moet blijven, schakel de checker uit; een aparte publieke versiebron vereist een aanpassing van de checker.

