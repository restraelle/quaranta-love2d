StateGame = class("StateGame", State);

function StateGame:initialize(payload)
    State.initialize(self, "game");
    -- c = Conductor:new("sounds/selftest/ok.wav", 128, -0.9);
    c = Conductor:new(payload.source, payload.bpm, payload.offset);
    s = Stage:new(c);
end

function StateGame:update(dt)
    s:update(dt);
end

function StateGame:draw()
    s:draw();
end

function StateGame:keypressed(k)

end

function StateGame:constantKeyCheck()

end