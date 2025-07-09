ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Kassakone'
ENT.Author = 'Negative'
ENT.Category = 'Negative'
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:isLockable() return true end
function ENT:isDoor() return false end
function ENT:DarkRPCanLockpick() return true end
function ENT:getLockpickTime() return 1 end

function ENT:SetupDataTables()
    self:NetworkVar('Float', 0, 'NextAction')
    self:NetworkVar('Int', 0, 'Reward')
    self:NetworkVar('Int', 1, 'Status')
    if SERVER then
        self:SetReward(math.random(KASSA_CONFIG.BaseReward, KASSA_CONFIG.MaxReward))
        self:SetStatus(0)
    end
end