GameState = 
{
    Waiting = 0,
    Playing = 1,
    Finished = 2,
}

Game = {}

function Game:Create()

    self.state = GameState.Waiting
    self.score = 0 
    self.highScore = 0

end

function Game:Start()

    self.bird = self.world:FindNode('Bird')
    self.pipeScroller = self.world:FindNode('PipeScroller')
    self.scoreText = self.world:FindNode('ScoreText')
    self.gameOver = self.world:FindNode("GameOver")

    self.bgmSound = LoadAsset('SW_Bgm')
    Audio.PlaySound2D(self.bgmSound, 1.0, 1.0, 0.0, true, 100)

    if(self.bird == nil) then
        Log.Error("Can't find bird!!")
    end

    self:Reset()

end

function Game:Tick(deltaTime)

    local pressed = Input.IsKeyPressed(Key.Space) or
                    Input.IsGamepadPressed(Gamepad.A) or
                    Input.IsMousePressed(Mouse.Left)

    if (self.state == GameState.Waiting) then
        if (pressed) then
            self.state = GameState.Playing 
            self.bird.controlEnabled = true 
            self.pipeScroller.scrollEnabled = true
        end

    elseif (self.state == GameState.Playing) then

        if (not self.bird.alive) then
            self:Finish() 
        end

    elseif (self.state == GameState.Finished) then

        if (pressed) then
            self:Reset()
        end

    end


end

function Game:Finish()

    self.state = GameState.Finished 
    self.pipeScroller.scrollEnabled = false 
    
    self.highScore = math.max(self.score, self.highScore)
    self.gameOver:FindChild('ScoreText', true):SetText(self.score)
    self.gameOver:FindChild('HighScoreText', true):SetText(self.highScore)
    self.gameOver:SetVisible(true)

end

function Game:Reset()

    self.state = GameState.Waiting
    self:SetScore(0)
    self.bird:Reset() 
    self.pipeScroller:Reset()
    self.gameOver:SetVisible(false)
end

function Game:SetScore(newScore)

    self.score = newScore 
    self.scoreText:SetText(tostring(self.score))

end

function Game:GetScore()
    return self.score 
end

