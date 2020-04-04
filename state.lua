State = class("State");

function State:initialize(name)
  self.name = name or "NOSTATE";
  self.identifier = math.random(0, 1000000);
  self.timeInitialized = os.clock();
  self.errors = {};
  self.errorRaised = false;
end

State.static.stateLinkedList = {};

function State:raise(errorTab)
  -- error format {errorCode: "KILLED_FORCEFULLY", message: "A kill event was pushed to the state."}
  table.insert(self.error, errorTab);
end

function State:kill()
  self.errorRaised = true;
end

function State:drawErrors()
  lg.print(self.name .. "(" .. self.identifier .. ")", 0, 0);
  lg.print("AN ERROR HAS OCCURED.", 0, 15);
end

function State:drawDebug()
  lg.print(self.name .. "(" .. self.identifier .. ")", 0, 0);
end

function State:update(dt)
  -- no super required
end

function State:draw()
  -- no super required
end

function State:keypressed(k)
  -- no super required
end

function State:constantKeyCheck(dt)
  -- no super required
end