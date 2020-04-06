Automaton = class("Automaton");

function Automaton:initialize(stateName, payload)
  self.state = nil;
  self.isLoading = true;

  self:switch(stateName, payload);
end

function Automaton:switch(stateName, payload)
  self.isLoading = true;
  if(stateName == "mainmenu") then
    self.state = StateMainMenu:new(payload);
  elseif(stateName == "game") then
    self.state = StateGame:new(payload);
  elseif(stateName == "songselect") then
    self.state = StateSongSelect:new(payload);
  else
    self.state = State:new(payload);
  end
  self.isLoading = false;
end

function Automaton:update(dt)
  if(self.isLoading == false) then
    if(self.state.errorRaised == false) then
      self.state:constantKeyCheck(dt);
      self.state:update(dt);
    end
  end
end

function Automaton:draw()
  if(self.isLoading == false) then
    if(self.state.errorRaised == false) then
      self.state:draw();
      -- self.state:drawDebug();
    else
      self.state:drawErrors();
    end
  end
end

function Automaton:keypressed(k)
  if(self.isLoading == false) then
    if(self.state.errorRaised == false) then
      self.state:keypressed(k);
    end
  end
end

function Automaton:constantKeyCheck(dt)
  if(self.isLoading == false) then
    if(self.state.errorRaised == false) then
      self.state:constantKeyCheck(dt);
    end
  end
end