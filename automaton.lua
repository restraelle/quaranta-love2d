Automaton = class("Automaton");

function Automaton:initialize(stateName)
  self.state = nil;
  self.isLoading = true;

  self:switch(stateName);
end

function Automaton:switch(stateName)
  self.isLoading = true;
  if(stateName == "mainmenu") then
    self.state = StateMainMenu:new();
  else
    self.state = State:new();
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
    if(self.errorRaised == false) then
      self.state:drawDebug();
      self.state:draw();
    else
      self.state:drawErrors();
    end
  end
end

function Automaton:keypressed(k)
  if(self.isLoading == false) then
    if(self.errorRaised == false) then
      self.state:keypressed(k);
    end
  end
end

function Automaton:constantKeyCheck(dt)
  if(state.isLoading == false) then
    if(self.errorRaised == false) then
      self.state:constantKeyCheck(dt);
    end
  end
end