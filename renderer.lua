Renderer = class('Renderer');

function Renderer:initialize(scale)
  lg.setDefaultFilter("nearest", "nearest", 1);
  
  self.scale = scale or 1;
  self.screen = {};
  
  -- 240 x 160
  self.screen.x = 240;
  self.screen.y = 160;
  
  self.canvas = lg.newCanvas(self.screen.x, self.screen.y);
  
  lw.setMode(self.screen.x * self.scale, self.screen.y * self.scale, {resizable=false});
end

function Renderer:updateMode()
  lw.setMode(self.screen.x * self.scale, self.screen.y * self.scale, {resizable=false});
end

function Renderer:setScale(scale)
  self.scale = scale;
  Renderer:updateMode();
end

function Renderer:push()
  lg.setCanvas(self.canvas);
  lg.clear();
end

function Renderer:pop()
  lg.setCanvas();
end

function Renderer:draw()
  lg.draw(self.canvas, 0, 0, 0, 1 * self.scale, 1 * self.scale);
end