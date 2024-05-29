
PipeScroller = {}

function PipeScroller:Create()

    self.scrollEnabled = false 
    self.scrollSpeed = 15.0
    self.pipeSpacing = 35.0 
    self.pipeGap = 10.0
    self.numPipes = 5 
    self.minX = -45 
    self.variationY = 12.0
    self.pipes = {} 

end

function PipeScroller:Start()

    local pipeScene = LoadAsset('SC_Pipe')

    for i = 1, self.numPipes do
        local pipe = pipeScene:Instantiate()
        self:AddChild(pipe)
        table.insert(self.pipes, pipe)
    end

    self:Reset()

end

function PipeScroller:Tick(deltaTime)

    if (not self.scrollEnabled) then
        return
    end

    -- Move pipes leftward
    for i = 1, self.numPipes do 
        local pipe = self.pipes[i] 

        local newPos = pipe:GetPosition()
        newPos.x = newPos.x - self.scrollSpeed * deltaTime 

        -- If pipe moves too far left, we want to put it in the back of the line
        if (newPos.x < self.minX) then 
            newPos.x = newPos.x + self.numPipes * self.pipeSpacing
            newPos.y = Math.RandRange(-self.variationY, self.variationY)
        end

        pipe:SetPosition(newPos)
    end 


end

function PipeScroller:Reset()

    self.scrollEnabled = false 

    for i = 1, self.numPipes do
        local pipe = self.pipes[i] 
        local x = i * self.pipeSpacing
        local y = Math.RandRange(-self.variationY, self.variationY)
        pipe:SetPosition(Vec(x, y, 0))
    end

end

