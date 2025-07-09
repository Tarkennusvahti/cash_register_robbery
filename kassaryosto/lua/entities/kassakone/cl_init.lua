include('shared.lua')

surface.CreateFont('RegisterFont', {font = 'Coolvetica Rg', size = 80})
function ENT:Draw()
    self:DrawModel()
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= 360000 then
        local pos = self:GetPos() + Vector(0,0,5)
        local ang = Angle(0, 0, 90)
        local ply = LocalPlayer()
        local dir = (ply:GetPos() - pos):Angle()
        ang.Yaw = dir.Yaw + 90
        cam.Start3D2D(pos, ang, 0.12)
            draw.SimpleTextOutlined('Kassakone', 'RegisterFont', 0, -340, color_white, 1, 1, 2, color_black)
            if self:GetReward() > 0 then
                draw.SimpleTextOutlined(DarkRP.formatMoney(self:GetReward()), 'RegisterFont', 0, -270, Color(20, 150, 20, 255), 1, 1, 2, color_black)
            end
            local status = self:GetStatus()
            if status == 1 then
                draw.SimpleTextOutlined('Kassakonetta ryöstetään!', 'RegisterFont', 0, -180, Color(255, 0, 0), 1, 1, 2, color_black)
            elseif status == 2 then
                draw.SimpleTextOutlined('Juuri ryöstetty!', 'RegisterFont', 0, -180, Color(255, 150, 0), 1, 1, 2, color_black)
            end
        cam.End3D2D()
    end
end