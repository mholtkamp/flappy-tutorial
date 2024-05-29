Bird = {}

function Bird:Create()

    self.velocity = Vec()
    self.gravity = -50
    self.flapSpeedY = 30
    self.alive = true 
    self.controlEnabled = false 
    self.yFloor = -10.0
    self.yCeiling = 10.0

    self.dingSound = LoadAsset('SW_Ding')

end

function Bird:GatherProperties()

    return 
    {
        { name = "yFloor", type = DatumType.Float },
        { name = "yCeiling", type = DatumType.Float },
        { name = "dingSound", type = DatumType.Asset }
    }

end

function Bird:Start()

    self.mesh = self:FindChild('Mesh', true)
    self.mesh:PlayAnimation("Idle", true, 1.0, 1.0, 1)
    
end

function Bird:Tick(deltaTime)

    if (not self.controlEnabled) then
        return 
    end

    -- Update Gravity
    self.velocity.y = self.velocity.y + self.gravity * deltaTime

    -- Update Velocity
    if (Input.IsKeyPressed(Key.Space) or
        Input.IsGamepadPressed(Gamepad.A) or
        Input.IsMousePressed(Mouse.Left)) then

        self.mesh:PlayAnimation('Flap', false, 1.0, 1.0, 2)
        self.velocity.y = self.flapSpeedY
    end

    -- Update position
    local newPos = self:GetWorldPosition()
    newPos = newPos + self.velocity * deltaTime
    newPos.y = math.min(newPos.y, self.yCeiling)
    self:SetWorldPosition(newPos)

    if (newPos.y <= self.yFloor) then
        self:Kill()
    end

    -- Adjust orientation of bird mesh based on y velocity
    local meshRot = self.mesh:GetRotation()
    local pitchAlpha = Math.Clamp((self.velocity.y + 25)/ 10, 0.0, 1.0)
    local targetPitch = Math.Lerp(60.0, -30.0, pitchAlpha)
    meshRot.x = Math.Damp(meshRot.x, targetPitch, 0.0005, deltaTime)
    self.mesh:SetRotation(meshRot)

end

function Bird:Stop()

end

function Bird:Kill()

    self.alive = false
    self.controlEnabled = false 
    self.mesh:SetAnimationPaused(true)

end

function Bird:Reset()

    self.alive = true 
    self.controlEnabled = false 

    -- Reset position to the middle of the screen
    local resetPos = self:GetPosition()
    resetPos.y = 0
    self:SetPosition(resetPos)

    -- Reset mesh rotation
    local meshRot = self.mesh:GetRotation()
    meshRot.x = 0.0
    self.mesh:SetRotation(meshRot)

    -- Resume animation
    self.mesh:SetAnimationPaused(false)
    self.mesh:PlayAnimation("Idle", true, 1.0, 1.0, 1);

end 

function Bird:BeginOverlap(this, other)

    if (this == self) then
        if (other:GetName() == 'KillBox') then 
            self:Kill()
        elseif (other:GetName() == 'PointBox') then
            local game = self:GetParent()
            game:SetScore(game:GetScore() + 1)
            local pitchMod = Math.RandRange(0.9, 1.1)
            Audio.PlaySound2D(self.dingSound, 1.0, pitchMod)
        end
    end

end

