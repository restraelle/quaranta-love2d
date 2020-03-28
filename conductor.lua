Conductor = class('Conductor');

function Conductor:initialize(source, bpm, offset)
  self.audioSource = la.newSource(source, "static");
  self.audioSource:setVolume(settings.sound.volume.music * settings.sound.volume.master);
  
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
  self.offset = offset;
  
  self.samples = {};
  self.samples.source = self.audioSource:tell("samples");
  self.samples.calculated = 0;
  
  self.seconds = {};
  self.seconds.source = self.audioSource:tell("seconds");
  self.seconds.calculated = 0;
  self.seconds.real = 0;
  
  -- this is the important one
  self.clock = 0;
  
  self.isPlaying = false;
  
  self.debug = {};

  self.debug.x = 0;
  self.debug.y = 16;
  self.debug.width = 400;
  self.debug.columnCharacterWidth = 20;
  self.debug.lineHeight = 8;
end

Conductor.static.globalTimeStretch = 1;

function Conductor:play()
  self.audioSource:play();
  self.isPlaying = true;
end

function Conductor:pause()
  self.audioSource:pause();
  self.isPlaying = false;
end

function Conductor:stop()
  self.audioSource:stop();
end

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
  
  self.clock = math.floor(self.seconds.real * 1000);
  
  -- calculating total beats
  self.beat.total = math.floor(self.seconds.real / (60 / self.bpm));
  self.beat.momentary = (self.beat.total % 4) + 1;
  self.measure.total = math.floor(self.beat.total / 4);
  
  self:updateDebugStack();
  
end

function Conductor:updateDebugStack()
  -- defines stuff to monitor in debug stack and updates it every frame
  self.debug.stack = {
    {key="time", value=self.time},
    {key="tick", value=self.tick},
    {key="seconds - source", value=self.seconds.source},
    {key="seconds - calc", value=self.seconds.calculated},
    {key="beat - total", value=self.beat.total},
    {key="beat - moment", value=self.beat.momentary},
    {key="measure - total", value=self.measure.total},
    {key="clock", value=self.clock}
  };
end

function Conductor:printDebugStack()
  -- draws the debug stack;
  for i, v in pairs(self.debug.stack) do
    lg.printf(string.format("%-17s:%-14.1f", v.key, v.value), self.debug.x, self.debug.y + (self.debug.lineHeight * i), self.debug.width);
  end
end

function Conductor:drawBeatDisplay(x, y)
  -- for debugging purposes
  boxScale = 5;
  spacing = 2;
  
  if(self.beat.momentary == 1) then
    lg.setColor(1, 0, 0.3);
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
  --self:printDebugStack();
  self:drawBeatDisplay(0, 13);
end

function Conductor:draw()
  self:drawDebug();
end