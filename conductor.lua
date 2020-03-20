Conductor = class('Conductor');

function Conductor:initialize(source, bpm)
  self.audioSource = la.newSource(source, "static");
  
  self.bpm = bpm;
  
  self.beat = {};
  self.beat.momentary = 0;
  self.beat.total = 0;
  
  self.measure = {};
  self.measure.momentary = 0;
  self.measure.total = 0;
  
  self.time = 0;
  
  self.tick = 0;
  self.tickLength = 0.1;
  
  self.calculationLerpTime = 1/10;
  self.offset = 0;
  
  self.samples = {};
  self.samples.source = self.audioSource:tell("samples");
  self.samples.calculated = 0;
  
  self.seconds = {};
  self.seconds.source = self.audioSource:tell("seconds");
  self.seconds.calculated = 0;
  self.seconds.real = 0;
  
  self.isPlaying = false;
  
  self.debug = {};

  self.debug.x = 0;
  self.debug.y = 16;
  self.debug.width = 400;
  self.debug.columnCharacterWidth = 20;
  self.debug.lineHeight = 8;
  
  self.audioSource:play();
  
end

Conductor.static.globalTimeStretch = 1;

function Conductor:update(deltaTime)
  
  -- keeps track of the time every frame
  self.time = self.time + deltaTime;
  self.tick = self.tick + deltaTime;
  
  -- tick state
  if(self.tick >= self.tickLength) then
    self.seconds.source = self.audioSource:tell("seconds");
    self.samples.source = self.audioSource:tell("samples");
    self.tick = 0;
  end
  
  -- calculating linear interpolation for seconds and samples
  self.seconds.calculated = refloat(lerp(self.seconds.calculated, self.seconds.source, (1 / self.calculationLerpTime), deltaTime), 4);
  self.samples.calculated = refloat(lerp(self.samples.calculated, self.samples.source, (1 / self.calculationLerpTime), deltaTime), 4);
  
  -- adjusting calculated time for start offset
  self.seconds.real = self.seconds.calculated + self.offset;
  
  -- calculating total beats
  self.beat.total = math.floor(self.seconds.real / (60 / self.bpm));
  self.beat.momentary = (self.beat.total % 4) + 1;
  self.measure.total = math.floor(self.beat.total / 4);
  
  self:updateDebugStack();
  
end

function Conductor:updateDebugStack()
  self.debug.stack = {
    {key="time", value=self.time},
    {key="tick", value=self.tick},
    {key="tick length", value=self.tickLength},
    {key="lerp calc time", value=self.calculationLerpTime},
    {key="seconds - source", value=self.seconds.source},
    {key="seconds - calc", value=self.seconds.calculated},
    {key="beat - total", value=self.beat.total},
    {key="beat - moment", value=self.beat.momentary},
    {key="measure - total", value=self.measure.total}
  };
end

function Conductor:printDebugStack()
  for i, v in pairs(self.debug.stack) do
    lg.printf(string.format("%-17s:%-14.3f", v.key, v.value), self.debug.x, self.debug.y + (self.debug.lineHeight * i), self.debug.width);
  end
end

function Conductor:drawBeatDisplay(x, y)
  boxScale = 5;
  spacing = 2;
  
  if(self.beat.momentary == 1) then
    lg.setColor(0, 0, 1);
  else
    lg.setColor(1, 1, 1);
  end
  lg.rectangle("fill", x + ((boxScale + spacing) * 0), y, boxScale, boxScale);
  
  if(self.beat.momentary == 2) then
    lg.setColor(0, 0, 1);
  else
    lg.setColor(1, 1, 1);
  end
  lg.rectangle("fill", x + ((boxScale + spacing) * 1), y, boxScale, boxScale);
  
  if(self.beat.momentary == 3) then
    lg.setColor(0, 0, 1);
  else
    lg.setColor(1, 1, 1);
  end
  lg.rectangle("fill", x + ((boxScale + spacing) * 2), y, boxScale, boxScale);
  
  if(self.beat.momentary == 4) then
    lg.setColor(0, 0, 1);
  else
    lg.setColor(1, 1, 1);
  end
  lg.rectangle("fill", x + ((boxScale + spacing) * 3), y, boxScale, boxScale);
  
  lg.setColor(1, 1, 1);
end

function Conductor:drawDebug()
  self:printDebugStack();
  self:drawBeatDisplay(0, 13);
end

function Conductor:draw()
  self:drawDebug();
end