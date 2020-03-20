-- RESTREPO
-- 3-15-2020 8:01pm

moonshine = require 'libraries/moonshine';
class = require 'libraries/middleclass';
tween = require 'libraries/tween';

require "snippets";
require "settings";
require "renderer";
require "conductor";

function love.load()
  fontDefault = lg.newFont("fonts/CodersCrux.ttf", 16);
  
  lg.setFont(fontDefault);
  r = Renderer:new();
  c = Conductor:new("sounds/selftest/ok.wav", 128);
end

function love.update(dt)
  c:update(dt);
end

function love.keypressed(k)
  
end

function love.draw()
  r:push();
    lg.printf("quaranta-032020a", 0, 0, 300);
    c:draw();
  r:pop();
  
  r:draw();
  
end