local resource = GetCurrentResourceName()
local releasesUrl = 'https://github.com/troyscripts/ts_nohelmet/releases'
local apiUrl = 'https://api.github.com/repos/troyscripts/ts_nohelmet/releases/latest'

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
                log('Versiecontrole: geen publieke release gevonden. Controleer of de repository openbaar is en een stabiele release heeft.')
            else
                log(('Versiecontrole niet beschikbaar (HTTP %s). Het script blijft werken.'):format(tostring(status)))
            end
            return
        end

        local ok, release = pcall(json.decode, body or '')
        if not ok or type(release) ~= 'table' or release.draft or release.prerelease then
            log('Versiecontrole: ongeldige releasegegevens ontvangen.')
            return
        end

        local latest = parseVersion(release.tag_name)
        if not latest then
            log('Versiecontrole: de releasetag moet het formaat v1.0.1 of 1.0.1 hebben.')
            return
        end

        for index = 1, 3 do
            if latest[index] > installed[index] then
                log(('Update beschikbaar: %s -> %s. Download: %s'):format(current, release.tag_name, releasesUrl))
                return
            elseif latest[index] < installed[index] then
                log(('Lokale versie %s is nieuwer dan de laatste publieke release (%s).'):format(current, release.tag_name))
                return
            end
        end

        log(('Versie %s is up-to-date.'):format(current))
    end, 'GET', '', {
        ['Accept'] = 'application/vnd.github+json',
        ['User-Agent'] = 'TroyScripts-ts_nohelmet-version-check'
    })
end)

