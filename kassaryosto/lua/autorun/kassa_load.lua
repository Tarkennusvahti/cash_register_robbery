if SERVER then
    AddCSLuaFile('kassa_config.lua')
    AddCSLuaFile('kassa_lang.lua')
    include('kassa_config.lua')
    resource.AddFile('resource/fonts/coolvetica-rg.ttf')
    resource.AddFile('sound/kassakone/siren.wav')
    resource.AddFile('sound/kassakone/cash.wav')
else
    include('kassa_config.lua')
    include('kassa_lang.lua')
end