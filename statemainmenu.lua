StateMainMenu = class("StateMainMenu", State);

local CASE_START, CASE_MENU, CASE_SETTINGS = 0, 1, 2;
local MENU_PLAY, MENU_SETTINGS, MENU_CREDITS, MENU_QUIT = 0, 1, 2, 3;

function StateMainMenu:initialize()
  State.initialize(self, "mainmenu");
  -- self.path = love.filesystem.getDirectoryItems("maps");
  -- self.meta, self.metaLength = love.filesystem.read("maps/" .. self.path[1] .. "/meta.starm");

  self.time = 0;

  self.gui = {};
  self.gui.items = {};
  self:setupGUIItems();

  self.gui.stars = {};
  self:setupStars();

  self.gui.tweens = {};
  table.insert(self.gui.tweens, tween.new(1.5, self.gui.items.logo, {y = 60, opacity = 1}, 'outElastic'));
  table.insert(self.gui.tweens, tween.new(1.5, self.gui.items.start, {y = 120}, 'outElastic'));
  table.insert(self.gui.tweens, tween.new(1.5, self.gui.items.startSelector, {y = 120}, 'outElastic'));
  table.insert(self.gui.tweens, tween.new(1, self.gui.items.shutterA, {y = -81}, 'outExpo'));
  table.insert(self.gui.tweens, tween.new(1, self.gui.items.shutterB, {y = 161}, 'outExpo'));

  self.case = CASE_START;

  self.menu = {};
  self.menu.selector = {
    x = 0,
    y = 22,
    width = 100,
    height = 17,
    color = {
      r = 245 /255,
      g = 66 / 255,
      b = 111 / 255
    }
  };
  self.menu.items = {
    {"Play", MENU_PLAY},
    {"Settings", MENU_SETTINGS},
    {"Credits", MENU_CREDITS},
    {"Quit Game", MENU_QUIT}
  };

  self.selector = {};
  self.selector.source = 0;
  self.selector.calculated = 0;
end

function StateMainMenu:setupGUIItems()
  self.gui.items.logo = {
    x = 240 / 2,
    y = -30,
    opacity = 0,
    originX = math.floor(resources.graphics.menu.logo:getWidth() / 2),
    originY = math.floor(resources.graphics.menu.logo:getHeight() / 2)
  };

  self.gui.items.start = {
    renderable = lg.newText(resources.fonts.default, "Press Start"),
    x = 120,
    y = 180,
    originX = 0,
    originY = 0
  };
  self.gui.items.start.originX = math.floor(self.gui.items.start.renderable:getWidth() / 2);
  self.gui.items.start.originY = math.floor(self.gui.items.start.renderable:getHeight() / 2);

  self.gui.items.startSelector = {
    x = 120,
    y = 180,
    width = 240,
    height = 17,
    opacity = 1,
    color = {
      r = 52 / 255,
      g = 229 / 255,
      b = 235 / 255
    }
  };

  self.gui.items.shutterA = {
    x = 0,
    y = 0
  }
  self.gui.items.shutterB = {
    x = 0,
    y = 80
  }
end

function StateMainMenu:setupStars()
  for i=0, 300, 1 do
    table.insert(self.gui.stars, {
      x = math.random(0, 240),
      y = math.random(0, 160),
      speed = math.random(10, 70),
      color = {
        r = math.random(0, 1),
        g = math.random(0, 1),
        b = math.random(0, 1);
      }
    });
  end
end

function StateMainMenu:updateTweens(dt)
  if(#self.gui.tweens > 0) then
    for i, t in pairs(self.gui.tweens) do
      local done = t:update(dt);
      if(done) then
        table.remove(self.gui.tweens, i);
      end
    end
  end
end

function StateMainMenu:updateStars(dt)
  for i, v in pairs(self.gui.stars) do
    if(v.x > 240) then
      v.x = -1;
    end
    v.x = v.x + (v.speed * dt);
  end
end

function StateMainMenu:update(dt)
  self.time = self.time + dt;

  self:updateTweens(dt);
  self:updateStars(dt);

  self.gui.items.startSelector.opacity = 0.2 + ((math.sin(self.time * 10) + 1) / 2) / 3;
end

function StateMainMenu:drawStars()
  for i, v in pairs(self.gui.stars) do
    lg.setColor(v.color.r, v.color.g, v.color.b, 1);
    lg.rectangle("fill", v.x, v.y, 1, 1);
  end
  lg.setColor(1, 1, 1, 1);
end

function StateMainMenu:drawMenu(x, y)
  -- selector
  lg.setColor(self.menu.selector.color.r, self.menu.selector.color.g, self.menu.selector.color.b, 1);
  lg.rectangle("fill", self.menu.selector.x, self.menu.selector.y + (self.selector.source * 16), self.menu.selector.width, self.menu.selector.height);
  lg.setColor(1, 1, 1, 1);

  -- menu items
  for i, v in pairs(self.menu.items) do
    lg.printf(v[1], x, y + (16 * i), 200);
  end
end

function StateMainMenu:draw()
  -- blur background
  lg.draw(resources.graphics.menu.background, 0, 0);
  self:drawStars();

  -- logo
  lg.setColor(1, 1, 1, self.gui.items.logo.opacity);
  lg.draw(resources.graphics.menu.logo, self.gui.items.logo.x, self.gui.items.logo.y, 0, 1, 1, self.gui.items.logo.originX, self.gui.items.logo.originY);
  lg.setColor(1, 1, 1, 1);

  -- start selector
  lg.setColor(self.gui.items.startSelector.color.r, self.gui.items.startSelector.color.g, self.gui.items.startSelector.color.b, self.gui.items.startSelector.opacity);
  lg.rectangle("fill", self.gui.items.startSelector.x - (self.gui.items.startSelector.width / 2), self.gui.items.startSelector.y - (self.gui.items.startSelector.height / 2), self.gui.items.startSelector.width, self.gui.items.startSelector.height);
  lg.setColor(1, 1, 1, 1);
  
  -- start text
  lg.draw(self.gui.items.start.renderable, self.gui.items.start.x, self.gui.items.start.y, 0, 1, 1, self.gui.items.start.originX, self.gui.items.start.originY);

  -- shutters
  lg.setColor(0, 0, 0, 1);
  lg.rectangle("fill", self.gui.items.shutterA.x, self.gui.items.shutterA.y, 240, 80);
  lg.rectangle("fill", self.gui.items.shutterB.x, self.gui.items.shutterB.y, 240, 80);
  lg.setColor(1, 1, 1, 1);

  if(self.case == CASE_MENU) then
    self:drawMenu(10, 10);
  end

  -- copyright text
  lg.print("(c)2020 Toxxy. All rights reserved.", 0, 150);
end

function StateMainMenu:menuMoveUp()
  if(self.selector.source > 0) then
    self.selector.source = self.selector.source - 1;
  end
end

function StateMainMenu:menuMoveDown()
  if(self.selector.source+1 < #self.menu.items) then
    self.selector.source = self.selector.source + 1;
  end
end

function StateMainMenu:menuSelect()
  if(self.selector.source == MENU_QUIT) then
    love.event.quit(0);
  end
end

function StateMainMenu:keypressed(k)
  if(self.case == CASE_START) then
    if(#self.gui.tweens == 0) then
      if(k == settings.controls.start) then
        self.gui.tweens = {};
        table.insert(self.gui.tweens, tween.new(1.5, self.gui.items.logo, {y = -120, opacity = 1}, 'outElastic'));
        table.insert(self.gui.tweens, tween.new(1.5, self.gui.items.start, {y = 200}, 'outElastic'));
        table.insert(self.gui.tweens, tween.new(1.5, self.gui.items.startSelector, {y = 200}, 'outElastic'));
        self.case = CASE_MENU;
      end
    end
  elseif(self.case == CASE_MENU) then
    if(k == settings.controls.up) then
      self:menuMoveUp();
    elseif(k == settings.controls.down) then
      self:menuMoveDown();
    elseif(k == settings.controls.start) then
      self:menuSelect();
    end
  end
end