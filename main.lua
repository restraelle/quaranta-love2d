
-- 888                                       
-- 888                                       
-- 888                                       
-- 888888 .d88b.  888  888 888  888 888  888 
-- 888   d88""88b `Y8bd8P' `Y8bd8P' 888  888 
-- 888   888  888   X88K     X88K   888  888 
-- Y88b. Y88..88P .d8""8b. .d8""8b. Y88b 888 
--  "Y888 "Y88P"  888  888 888  888  "Y88888 
--                                       888 
--                                  Y8b d88P 
--                                   "Y88P"  


-- RESTREPO
-- 3-15-2020 8:01pm

moonshine = require 'libraries/moonshine';
class = require 'libraries/middleclass';
tween = require 'libraries/tween';
json = require 'libraries/json';

require "snippets";
require "state";
require "statemainmenu";
require "stategame";
require "automaton";
require "resources";
require "settings";
require "renderer";
require "conductor";
require "stage";

function love.load()
  -- seeding and popping rng
  math.randomseed(os.time());math.random();math.random();math.random();
  
  resources.loadCore();
  r = Renderer:new(3);
    -- c = Conductor:new("sounds/selftest/ok.wav", 128, -0.9);

  a = Automaton:new("mainmenu", {source="sounds/selftest/ok.wav", bpm=128, offset=-0.9});
end

function love.update(dt)
  a:update(dt);
end

function love.draw()
  r:push();
    -- lg.printf("quaranta-032020a", 0, 0, 300);
    a:draw();
  r:pop();

  r:draw();
end

function love.keypressed(k)
  a:keypressed(k);
  
  if(k == "escape") then
    love.event.quit(0);
  end
  if(k == "f4") then
    a:switch("");
  end
end
