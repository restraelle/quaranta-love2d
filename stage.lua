Stage = class('Stage');

function Stage:initialize(conductor)
  self.conductor = Conductor:new("sounds/selftest/ok.wav", 128, -0.9);
  self.conductor:play();
  
  
  
  -- master game settings
  self.speed = 6;
  self.fretSize = 16;
  self.spacing = 0;
  
  self.fret = {};
  self.fret.x = 150;
  self.fret.y = 135;
  
  self.threshold = {};
  self.threshold.killZone = 200;
  self.threshold.limiter = 100;
  
  
  
  -- state management
  self.buttons = {};
  
  self.buttons.a = {};
  self.buttons.a.state = false;
  self.buttons.a.processed = false;
  
  self.buttons.b = {};
  self.buttons.b.state = false;
  self.buttons.b.processed = false;
  
  self.buttons.c = {};
  self.buttons.c.state = false;
  self.buttons.c.processed = false;
  
  self.buttons.d = {};
  self.buttons.d.state = false;
  self.buttons.d.processed = false;
  
  
  
  -- note management
  self.beatLength = (60 / self.conductor.bpm);

  self.notes = {
      
  };
  
  
  
  -- debug management
  self.debug = false;
  self.lastNoteJudgement = 0;
  self.score = 0;
  
  
  -- editing management
  self.lines = {};



  -- initializing
  self:initializeLines();
  self:initializeNotes();
end

function Stage:initializeLines()
  for i = 0, 300, 1 do
    table.insert(self.lines, {
      y = i * (1000 * self.beatLength)
    });
  end
end

function Stage:initializeNotes()
  for i=0, 300, 1 do
    table.insert(self.notes, {
      y = math.floor(i * (1000 * (self.beatLength/2))),
      note = math.random(0, 3),
      alive = true,
      judgement = -10
    });
  end
end

function Stage:update(deltaTime)
  self:constantKeyChecks();
  self:gradeNotes();
  self.conductor:update(deltaTime);
end

function Stage:constantKeyChecks()
  if(lk.isDown(settings.controls.a)) then
    self.buttons.a.state = true;
  else
    self.buttons.a.state = false;
  end
  
  if(lk.isDown(settings.controls.b)) then
    self.buttons.b.state = true;
  else
    self.buttons.b.state = false;
  end
  
  if(lk.isDown(settings.controls.c)) then
    self.buttons.c.state = true;
  else
    self.buttons.c.state = false;
  end
  
  if(lk.isDown(settings.controls.d)) then
    self.buttons.d.state = true;
  else
    self.buttons.d.state = false;
  end
end

function Stage:processNote(button, noteNum)
  for i, v in pairs(self.notes) do
    if(v.note == noteNum and v.alive == true and v.y > (self.conductor.clock - self.threshold.killZone)) then
      if(self.conductor.clock >= (v.y - self.threshold.limiter)) then
        v.alive = false;
        v.judgement = (self.conductor.clock - v.y) / 100;
        button.processed = true;
        self.score = self.score + (100 * (1 - clamp(math.abs(v.judgement), 0, 1)));
        self.lastNoteJudgement = v.judgement;
        break;
      end
    end
  end
end

function Stage:gradeNotes()
  if(self.buttons.a.state == true) then
    if(self.buttons.a.processed == false) then
      self:processNote(self.buttons.a, 0);
    end
  else
    self.buttons.a.processed = false;
  end
  
  if(self.buttons.b.state == true) then
    if(self.buttons.b.processed == false) then
      self:processNote(self.buttons.b, 1);
    end
  else
    self.buttons.b.processed = false;
  end
  
  if(self.buttons.c.state == true) then
    if(self.buttons.c.processed == false) then
      self:processNote(self.buttons.c, 2);
    end
  else
    self.buttons.c.processed = false;
  end
  
  if(self.buttons.d.state == true) then
    if(self.buttons.d.processed == false) then
      self:processNote(self.buttons.d, 3);
    end
  else
    self.buttons.d.processed = false;
  end

end

function Stage:drawNotes()
  for i, v in pairs(self.notes) do
    if(v.alive == false) then
      lg.setColor(1, 0, 0);
    else
      lg.setColor(1, 1, 1);
    end
    
    lg.draw(
      resources.graphics.game.note,
      self.fret.x + (self.fretSize+self.spacing) * v.note,
      self.fret.y + (self.fretSize/2) - (v.y/self.speed) + (self.conductor.clock/self.speed),
      0,
      1,
      1,
      0,
      self.fretSize/2
    );
    
    if(self.debug == true) then
      lg.print(
        v.y,
        self.fret.x + (self.fretSize+self.spacing) * v.note,
        self.fret.y + (self.fretSize/2) - (v.y/self.speed) + (self.conductor.clock/self.speed)
      );
    end
    
    
    
    lg.setColor(1, 1, 1);
  end
end

function Stage:drawLine()
  for i, v in pairs(self.lines) do
    lg.line(
      self.fret.x,
      self.fret.y + (self.fretSize/2) - (v.y/self.speed) + (self.conductor.clock/self.speed),
      self.fret.x + 64,
      self.fret.y + (self.fretSize/2) - (v.y/self.speed) + (self.conductor.clock/self.speed)
    );
    lg.print(v.y, self.fret.x + 66, self.fret.y + (self.fretSize/2) - (v.y/self.speed) + (self.conductor.clock/self.speed));
  end
end

function Stage:draw()
  self:drawLine();
  self:drawNotes();
  self.conductor:draw();
  
  lg.print("a s: " .. tostring(self.buttons.a.state), 5, 20);
  lg.print("a p: " .. tostring(self.buttons.a.processed), 5, 35);
  lg.print("lng: " .. self.lastNoteJudgement, 5, 65);
  lg.print("score: " .. self.score, 5, 80);

  
  if(self.buttons.a.state == true) then
    lg.draw(resources.graphics.game.fretPressed, self.fret.x + ((self.spacing + self.fretSize) * 0), self.fret.y);
  else
    lg.draw(resources.graphics.game.fret, self.fret.x + ((self.spacing + self.fretSize) * 0), self.fret.y);
  end
  
  if(self.buttons.b.state == true) then
    lg.draw(resources.graphics.game.fretPressed, self.fret.x + ((self.spacing + self.fretSize) * 1), self.fret.y);
  else
    lg.draw(resources.graphics.game.fret, self.fret.x + ((self.spacing + self.fretSize) * 1), self.fret.y);
  end
  
  if(self.buttons.c.state == true) then
    lg.draw(resources.graphics.game.fretPressed, self.fret.x + ((self.spacing + self.fretSize) * 2), self.fret.y);
  else
    lg.draw(resources.graphics.game.fret, self.fret.x + ((self.spacing + self.fretSize) * 2), self.fret.y);
  end
  
  if(self.buttons.d.state == true) then
    lg.draw(resources.graphics.game.fretPressed, self.fret.x + ((self.spacing + self.fretSize) * 3), self.fret.y);
  else
    lg.draw(resources.graphics.game.fret, self.fret.x + ((self.spacing + self.fretSize) * 3), self.fret.y);
  end
  
  
end