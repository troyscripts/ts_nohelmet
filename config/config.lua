Config = {
    DisableAutomaticHelmet = true, -- true = geen automatische GTA-motorhelm; bestaande kleding blijft staan.
    PreventAutoShuffle = true, -- true = passagier schuift niet automatisch naar de bestuurder.
    ShuffleCommand = 'schuif', -- Command zonder /; false = command uitschakelen.
    ShuffleTimeoutMs = 8000, -- Maximale duur van één schuifpoging in milliseconden.
    Radial = {
        Enabled = true, -- true = directe optie in het ox_lib-radiaalmenu via ts_bridge.
        Label = 'Schuif naar bestuurder',
        Icon = 'chair' -- Font Awesome-icoonnaam die ox_lib ondersteunt.
    },
    Messages = {
        NotInVehicle = 'Je zit niet in een voertuig.',
        Dead = 'Je kunt niet schuiven als je dood of buiten bewustzijn bent.',
        Driver = 'Je zit al op de bestuurdersstoel.',
        FrontPassenger = 'Je moet op de voorste passagiersstoel zitten.',
        Occupied = 'De bestuurdersstoel is nog bezet of iemand stapt in.',
        Unavailable = 'Je kunt nu niet van stoel wisselen.',
        Busy = 'Je bent al aan het schuiven.',
        Failed = 'Schuiven is niet gelukt of werd onderbroken.'
    }
}
