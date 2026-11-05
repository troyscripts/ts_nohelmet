local resource = GetCurrentResourceName()
local repositoryUrl = 'https://github.com/troyscripts/ts_nohelmet'
local apiUrl = 'https://api.github.com/repos/troyscripts/ts_nohelmet/contents/fxmanifest.lua?ref=main'

local function log(message)
    print(('[%s] %s'):format(resource, message))
end

-- Alleen stabiele versies: 1.0.1 of v1.0.1. Vergelijk numeriek, niet als tekst.
local function parseVersion(value)
    if type(value) ~= 'string' then return nil end
    local major, minor, patch = value:match('^[vV]?(%d+)%.(%d+)%.(%d+)$')
    if not major then return nil end
    return { tonumber(major), tonumber(minor), tonumber(patch) }
end

CreateThread(function()
    if GetConvarInt('ts_nohelmet_version_check', 1) == 0 then return end

    local current = GetResourceMetadata(resource, 'version', 0)
    local installed = parseVersion(current)
    if not installed then
        log('Versiecontrole overgeslagen: ongeldige versie in fxmanifest.lua.')
        return
    end

    local finished = false
    SetTimeout(15000, function()
        if finished then return end
        finished = true
        log('Versiecontrole: GitHub reageert niet binnen 15 seconden. Het script blijft werken.')
    end)

    PerformHttpRequest(apiUrl, function(status, body)
        if finished then return end
        finished = true

        if status ~= 200 then
            if status == 404 then
                log('Versiecontrole: publiek fxmanifest.lua op main niet gevonden.')
            else
                log(('Versiecontrole niet beschikbaar (HTTP %s). Het script blijft werken.'):format(tostring(status)))
            end
            return
        end

        if type(body) ~= 'string' or #body > 16384 then
            log('Versiecontrole: ongeldig manifest ontvangen.')
            return
        end
        -- Lees uitsluitend een volledige version-regel; voer de ontvangen Lua nooit uit.
        local remote
        for line in (body .. '\n'):gmatch('([^\r\n]*)[\r\n]') do
            local value = line:match("^%s*version%s+'([vV]?%d+%.%d+%.%d+)'%s*$")
                or line:match('^%s*version%s+"([vV]?%d+%.%d+%.%d+)"%s*$')
            if value then
                if remote then log('Versiecontrole: meerdere version-regels ontvangen.'); return end
                remote = value
            end
        end
        local latest = parseVersion(remote)
        if not latest then
            log('Versiecontrole: geldige version-regel ontbreekt in het manifest.')
            return
        end

        for index = 1, 3 do
            if latest[index] > installed[index] then
                log(('Update beschikbaar: %s -> %s. Download: %s'):format(current, remote, repositoryUrl))
                return
            elseif latest[index] < installed[index] then
                log(('Lokale versie %s is nieuwer dan het publieke manifest (%s).'):format(current, remote))
                return
            end
        end

        log(('Versie %s is up-to-date.'):format(current))
    end, 'GET', '', {
        ['Accept'] = 'application/vnd.github.raw+json',
        ['User-Agent'] = 'TroyScripts-ts_nohelmet-version-check'
    })
end)

