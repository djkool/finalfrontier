local sparkSounds = {
    "ambient/energy/spark1.wav",
    "ambient/energy/spark2.wav",
    "ambient/energy/spark3.wav",
    "ambient/energy/spark4.wav",
    "ambient/energy/spark5.wav",
    "ambient/energy/spark6.wav"
}

function EFFECT:Init(data)
    local target = data:GetEntity()
    if not IsValid(target) then return end

    local mag = math.max(1, data:GetMagnitude())
    local low, high = target:WorldSpaceAABB()

    local count = math.Clamp(math.sqrt(mag) * 4, 2, 16)
        
    local emitter = ParticleEmitter(target:GetPos())
    for i = 1, count do
        local pos = Vector(
            math.Rand(low.x, high.x),
            math.Rand(low.y, high.y),
            math.Rand(low.z, high.z) + 16
        )

        local particle = emitter:Add("effects/spark", pos)
        if particle then
            particle:SetVelocity((pos - target:GetPos())
                * (5 + math.random() * 5))

            particle:SetGravity(Vector(0, 0, -600))
            particle:SetAirResistance(100)
            particle:SetDieTime(math.Rand(0.5, 1.5))

            particle:SetLifeTime(0)
            particle:SetStartAlpha(math.Rand(191, 255))
            particle:SetEndAlpha(0)
            particle:SetStartSize(2)
            particle:SetEndSize(0)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(0)
            
            particle:SetCollide(true)
            particle:SetBounce(0.3)
        end
    end
    emitter:Finish()

    if data:GetFlags() ~= 1 then
        target:EmitSound(table.Random(sparkSounds), 85 + (30 / 16 * mag), 100)
    end
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
    return
end
