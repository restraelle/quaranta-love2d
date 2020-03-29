resources = {};

resources.graphics = {};
resources.graphics.game = {};
resources.graphics.game.fret = lg.newImage("graphics/fret.png");
resources.graphics.game.fretPressed = lg.newImage("graphics/fret_pressed.png");
resources.graphics.game.note = lg.newImage("graphics/note.png");

resources.fonts = {};
resources.fonts.default = lg.newFont("fonts/CodersCrux.ttf", 16);

function resources.loadCore()
  lg.setFont(resources.fonts.default);
end
