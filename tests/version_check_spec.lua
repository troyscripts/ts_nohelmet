local thread, response, timer, logs, requested = nil,nil,nil,{},0
local enabled, installed = 1, '1.0.6'
GetCurrentResourceName=function() return 'ts_nohelmet' end
GetConvarInt=function() return enabled end
GetResourceMetadata=function() return installed end
CreateThread=function(fn) thread=fn end
SetTimeout=function(_,fn) timer=fn end
print=function(msg) logs[#logs+1]=msg end
PerformHttpRequest=function(url,cb,method,body,headers)
    assert(url=='https://api.github.com/repos/troyscripts/ts_nohelmet/contents/fxmanifest.lua?ref=main')
    assert(headers.Accept=='application/vnd.github.raw+json')
    assert(method=='GET' and body=='')
    requested=requested+1; response=cb
end
local function run(status,body)
    logs={}; response=nil; timer=nil; requested=0
    dofile('server/version_check.lua'); thread()
    if response then response(status,body) end
end
local function contains(s) return logs[#logs] and logs[#logs]:find(s,1,true) end
run(200,"fx_version 'cerulean'\nversion '1.0.6'\n")
assert(contains('up-to-date'))
run(200,'version "1.0.7"\r\n'); assert(contains('Update beschikbaar'))
run(200,"version '1.0.5'"); assert(contains('nieuwer'))
run(200,"-- version '9.9.9'\nversion '1.0.6'\nerror('must not execute')")
assert(contains('up-to-date'))
run(200,"version '1.0.6'\nversion '9.9.9'"); assert(contains('meerdere'))
run(200,'{}'); assert(contains('ontbreekt'))
run(200,string.rep('a',16385)); assert(contains('ongeldig'))
run(404,''); assert(contains('manifest') or contains('fxmanifest'))
run(503,''); assert(contains('HTTP 503'))
logs={}; dofile('server/version_check.lua'); thread(); timer()
assert(contains('15 seconden')); local count=#logs
response(200,"version '9.9.9'"); assert(#logs==count, 'ignore late callback')
enabled=0; run(200,"version '9.9.9'"); assert(requested==0)
