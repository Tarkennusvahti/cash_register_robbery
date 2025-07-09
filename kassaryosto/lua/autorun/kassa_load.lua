if SERVER then
    AddCSLuaFile('kassa_config.lua')
    include('kassa_config.lua')
    resource.AddFile('resource/fonts/coolvetica-rg.ttf')
	resource.AddFile('sound/kassakone/siren.wav')
else
    include('kassa_config.lua')
end