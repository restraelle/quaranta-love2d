-- RESTREPO
-- 3-15-2020 8:01pm

moonshine = require 'libraries/moonshine';
class = require 'libraries/middleclass';
tween = require 'libraries/tween';
json = require 'libraries/json';

require "snippets";
require "resources";
require "settings";
require "renderer";
require "conductor";
require "stage";

function love.load()
  fontDefault = lg.newFont("fonts/CodersCrux.ttf", 16);
  
  lg.setFont(fontDefault);
  r = Renderer:new(3);
  s = Stage:new();
end

function love.update(dt)
  s:update(dt);
end

function love.draw()
  r:push();
    lg.printf("quaranta-032020a", 0, 0, 300);
    s:draw();
  r:pop();
  
  r:draw();
  
end

function love.keypressed(k)
  if(k == "escape") then
    love.event.quit(0);
  end
end