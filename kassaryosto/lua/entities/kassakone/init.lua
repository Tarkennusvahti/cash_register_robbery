
AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')
if not KASSA_LANG then
    include("kassa_lang.lua")
end

local function isAllowed(ply)
    return KASSA_CONFIG.Robbers[team.GetName(ply:Team())]
end

local function teamsCount(policeTable)
    local count = 0
    for _, v in ipairs(player.GetAll()) do
        local teamName = team.GetName(v:Team())
        if policeTable[teamName] then
            count = count + 1
        end
    end
    return count >= KASSA_CONFIG.MinPolice
end

function ENT:Initialize()
    self:SetModel('models/props_c17/cashregister01a.mdl')
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.DoorOpened = false
    self.playerRobber = nil
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion(false)
    end
    self:SetCollisionBounds(Vector(-32, -32, 0), Vector(32, 32, 64))
end

function ENT:lockpickFinished(ply, success)
    if not success then return end
    if self.DoorOpened then return end
    self.DoorOpened = true
    DarkRP.notify(ply, 0, 3, KASSA_LANG.Get("register_opened"))

    if self.AutoLockTimer then timer.Remove(self.AutoLockTimer) end
    self.AutoLockTimer = "kassa_autolock_" .. self:EntIndex()
    timer.Create(self.AutoLockTimer, 10, 1, function()
        if not IsValid(self) then return end
        if self.DoorOpened and self:GetStatus() == 0 and not self.playerRobber then
            self.DoorOpened = false
            DarkRP.notify(ply, 1, 3, KASSA_LANG.Get("too_slow_locked"))
        end
    end)
end

function ENT:Use(ply)
    local enoughPolice = teamsCount(KASSA_CONFIG.Police)

    if not self.DoorOpened then
        DarkRP.notify(ply, 1, 3, KASSA_LANG.Get("not_opened"))
        return end
    if self:GetStatus() ~= 0 then return end
    if not isAllowed(ply) then 
        DarkRP.notify(ply, 1, 3, string.format(KASSA_LANG.Get("not_robber"), team.GetName(ply:Team())))
        return end
    if not enoughPolice then
        DarkRP.notify(ply, 1, 3, KASSA_LANG.Get("no_police"))
        return end
    if self.playerRobber then
        DarkRP.notify(ply, 1, 3, KASSA_LANG.Get("already_robbed"))
        return end

    if self.AutoLockTimer then timer.Remove(self.AutoLockTimer) self.AutoLockTimer = nil end
    self:StartRobbery(ply)
    self:EmitSound("kassakone/cash.wav", 75, 100, 1, CHAN_AUTO, 0, 60)
end

function ENT:StartRobbery(ply)
    local name = ply:GetName()
    self.playerRobber = ply

    self:SetStatus(1)
    self:SetNextAction(CurTime() + (KASSA_CONFIG.RobberyTime))
    DarkRP.notify(ply, 0, 3, KASSA_LANG.Get("robbery_started"))
    local robberyPly = ply
    local robberyEnt = self
    local robberyTimerID = "robbery_distance_" .. self:EntIndex()
    local robberyTime = KASSA_CONFIG.RobberyTime
    local maxDist = KASSA_CONFIG.RobberyDistance
    timer.Create(robberyTimerID, 0.2, 0, function()
        if not IsValid(robberyPly) or not IsValid(robberyEnt) or robberyEnt:GetStatus() ~= 1 then
            robberyEnt.playerRobber = nil
            timer.Remove(robberyTimerID)
            return
        end
        if robberyPly:GetPos():DistToSqr(robberyEnt:GetPos()) > maxDist*maxDist then
            DarkRP.notify(robberyPly, 1, 4, KASSA_LANG.Get("too_far"))
            robberyEnt:SetStatus(0)
            robberyEnt:SetNextAction(CurTime())
            robberyEnt.DoorOpened = false
            robberyEnt.playerRobber = nil
            timer.Remove(robberyTimerID)
        end
    end)
    timer.Simple(robberyTime, function()
        timer.Remove(robberyTimerID)
        if not IsValid(self) or self:GetStatus() ~= 1 then self.playerRobber = nil return end
        self:SetStatus(2)
        self:SetNextAction(CurTime() + KASSA_CONFIG.CooldownTime)
        ply:addMoney(self:GetReward())
        DarkRP.notify(ply, 0, 5, string.format(KASSA_LANG.Get("reward"), DarkRP.formatMoney(self:GetReward())))
        self.DoorOpened = false
        self:SetReward(0)
        self.playerRobber = nil
        timer.Simple(KASSA_CONFIG.CooldownTime, function()
            if IsValid(self) then
                self:SetStatus(0)
                self:SetReward(math.random(KASSA_CONFIG.BaseReward, KASSA_CONFIG.MaxReward))
            end
        end)
    end)
end

local function spawnSavedCashRegisters()
    local read = file.Read('kassakone/'..game.GetMap()..'.txt', 'DATA')
    if read then
        local data = util.JSONToTable(read)
        for k, v in pairs(data) do
            local ent = ents.Create('kassakone')
            ent:SetPos(v.pos)
            ent:SetAngles(v.ang)
            ent:Spawn()
        end
        MsgC(Color(0, 255, 0), '[Kassakone] ', Color(255, 255, 0), #data..' kassakonetta ladattu kartalle '..game.GetMap()..'.\n')
    else
        MsgC(Color(0, 255, 0), '[Kassakone] ', Color(255, 255, 0), 'Tallennettua dataa ei löytynyt kartalle '..game.GetMap()..'.\n')
    end
end

hook.Add('InitPostEntity', 'Kassakone_SpawnSaved', function()
    spawnSavedCashRegisters()
end)

hook.Add('PostCleanupMap', 'Kassakone_RespawnSaved', function()
    MsgC(Color(0, 255, 0), '[Kassakone] ', Color(255, 255, 0), 'Cleanup havaittu! Ladataan kassakoneet uudelleen...\n')
    spawnSavedCashRegisters()
end)

concommand.Add('kassakone_save', function(ply)
    if not IsValid(ply) or ply:IsSuperAdmin() then
        local found = ents.FindByClass('kassakone')
        if #found > 0 then
            local data = {}
            for k, v in pairs(found) do
                table.insert(data, {pos = v:GetPos(), ang = v:GetAngles()})
            end
            if not file.Exists('kassakone', 'DATA') then
                file.CreateDir('kassakone')
            end
            file.Write('kassakone/'..game.GetMap()..'.txt', util.TableToJSON(data))
            if IsValid(ply) then
                DarkRP.notify(ply, 0, 10, string.format(KASSA_LANG.Get("saved"), #found))
            end
            MsgC(Color(0, 255, 0), '[Kassakone] ', Color(255, 255, 0), string.format(KASSA_LANG.Get("saved_console"), #found, game.GetMap())..'\n')
        else
            if IsValid(ply) then
                DarkRP.notify(ply, 1, 5, KASSA_LANG.Get("not_found"))
            end
        end
    end
end)

concommand.Add('kassakone_wipe', function(ply)
    if not IsValid(ply) or ply:IsSuperAdmin() then
        local read = file.Read('kassakone/'..game.GetMap()..'.txt', 'DATA')
        if read then
            file.Delete('kassakone/'..game.GetMap()..'.txt')
            if IsValid(ply) then
                DarkRP.notify(ply, 0, 10, KASSA_LANG.Get("data_deleted"))
            end
            MsgC(Color(0, 255, 0), '[Kassakone] ', Color(255, 255, 0), KASSA_LANG.Get("data_deleted_console")..'\n')
        else
            if IsValid(ply) then
                DarkRP.notify(ply, 1, 5, KASSA_LANG.Get("data_not_found_console"))
            end
        end
    end
end)

if SERVER then
    hook.Add('canLockpick', 'AllowCashRegisterLockpick', function(ply, ent)
        if IsValid(ent) and ent:GetClass() == 'kassakone' then
            return true
        end
    end)
    hook.Add("onLockpickCompleted", "ForceCashRegisterLockpick", function(ply, success, ent)
        if IsValid(ent) and ent:GetClass() == "kassakone" and success then
            if ent.lockpickFinished then
                ent:lockpickFinished(ply, true)
            end
        end
    end)
    hook.Add("lockpickStarted", "KassaLockpickWanted", function(ply, ent)
        if IsValid(ent) and ent:GetClass() == "kassakone" then
            if not ply:isWanted() then
                ply:wanted(nil, KASSA_LANG.Get("wanted"), 1800)
            end
            if KASSA_CONFIG.LoopSiren then
                local timerName = "kassa_siren_loop_" .. ent:EntIndex()
                timer.Create(timerName, 8, 0, function() -- Modify '8' to the length of your siren.wav file in seconds.
                    if not IsValid(ent) then timer.Remove(timerName) return end
                    
                    if ent.LockpickCompleted then
                        if ent.SirenLoopsLeft and ent.SirenLoopsLeft > 0 then
                            ent:EmitSound("kassakone/siren.wav", 75, 100, 1, CHAN_AUTO, 0, 60)
                            ent.SirenLoopsLeft = ent.SirenLoopsLeft - 1
                        else
                            timer.Remove(timerName)
                            ent:StopSound("kassakone/siren.wav")
                            ent.SirenTimer = nil
                            ent.LockpickCompleted = nil
                            ent.SirenLoopsLeft = nil
                        end
                    else
                        if ent:GetStatus() ~= 0 then 
                            timer.Remove(timerName) 
                            ent.SirenTimer = nil
                            return 
                        end
                        ent:EmitSound("kassakone/siren.wav", 75, 100, 1, CHAN_AUTO, 0, 60)
                    end
                end)
                ent:EmitSound("kassakone/siren.wav", 75, 100, 1, CHAN_AUTO, 0, 60)
                ent.SirenTimer = timerName
            else
                ent:EmitSound("kassakone/siren.wav", 75, 100, 1, CHAN_AUTO, 0, 60)
            end
        end
    end)
    hook.Add("onLockpickCompleted", "KassaLockpickSirenStop", function(ply, success, ent)
        if IsValid(ent) and ent:GetClass() == "kassakone" then
            if ent.SirenTimer then
                if ent.SirenStopTimer then return end
                ent.SirenLoopsLeft = 4
                ent.LockpickCompleted = true
            end
        end
    end)
end