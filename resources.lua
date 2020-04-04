resources = {};

resources.graphics = {};
resources.graphics.game = {};
resources.graphics.game.fret = lg.newImage("graphics/fret.png");
resources.graphics.game.fretPressed = lg.newImage("graphics/fret_pressed.png");
resources.graphics.game.note = lg.newImage("graphics/note.png");
resources.graphics.menu = {};
resources.graphics.menu.logo = lg.newImage("graphics/menu/logo.png");
resources.graphics.menu.background = lg.newImage("graphics/menu/background.png");

resources.fonts = {};
resources.fonts.default = lg.newFont("fonts/CodersCrux.ttf", 16);
resources.fonts.retro = {};
resources.fonts.retro.small = lg.newFont("fonts/GABRWFFR.TTF", 16);
resources.fonts.retro.large = lg.newFont("fonts/GABRWFFR.TTF", 32);

function resources.loadCore()
  lg.setFont(resources.fonts.default);
end
