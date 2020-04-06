StateSongSelect = class("StateSongSelect", State);

local BINARY_MAPS_DIRECTORY = "maps/";

function StateSongSelect:initialize()
    State.initialize(self, "songselect");

    self.albumArtScale = 50;

    self.isLoaded = false;
    self.songList = {};
    self:loadSongs();

    self.selector = {};
    self.selector.source = 2;
    self.selector.calculated = 1;

    self.previewVolume = 0;

end

function StateSongSelect:loadSongs()
    local maps = love.filesystem.getDirectoryItems(BINARY_MAPS_DIRECTORY);

    for i, v in pairs(maps) do
        local meta = love.filesystem.read(BINARY_MAPS_DIRECTORY .. v .. "/meta.starm");
        local song = json.decode(meta);

        song.renderables = {};
        song.renderables.albumArt = {};
        song.renderables.albumArt.renderable = lg.newImage(BINARY_MAPS_DIRECTORY .. v .. "/" .. song.sources[tostring(0)].cover);
        song.renderables.albumArt.scaleX, song.renderables.albumArt.scaleY = resizeImageByScale(song.renderables.albumArt.renderable, self.albumArtScale, self.albumArtScale);

        song.renderables.audio = {};
        song.renderables.audio.renderable = la.newSource(BINARY_MAPS_DIRECTORY .. v .. "/" .. song.sources[tostring(0)].filename, "stream");
        song.renderables.audio.renderable:setVolume(settings.sound.volume.music);
        table.insert(self.songList, song);
    end

    self.isLoaded = true;
end

function StateSongSelect:update(dt)
    self.selector.calculated = lerp(self.selector.calculated, self.selector.source, 10, dt);
end

function StateSongSelect:drawCassette()
    lg.draw(resources.graphics.menu.cassette, -5, 10);
    if(self.isLoaded == true) then
        lg.setFont(resources.fonts.retro.small);
        lg.setColor(0.1, 0, 0.1, 0.9);
        lg.printf(self.songList[self.selector.source].meta.title, 23, 23, 100, "center");
        lg.setColor(1, 1, 1, 1);

        lg.setFont(resources.fonts.default);
        lg.setColor(0.25, 0.84, 0.96);
        lg.printf(self.songList[self.selector.source].meta.artist, 19, 66, 100, "center");
        lg.setColor(1, 1, 1, 1);
    end
end

function StateSongSelect:drawAlbumArt(x, y)
    if(self.isLoaded == true) then
        for i, v in pairs(self.songList) do
            local a = v.renderables.albumArt;
            lg.draw(a.renderable, x, y + ((i-1) * self.albumArtScale) - ((self.selector.calculated-1) * self.albumArtScale), 0, a.scaleX, a.scaleY);
        end
    end
end

function StateSongSelect:drawDebugSongList()
    for i, v in pairs(self.songList) do
        lg.printf(v.meta.title, 0, 10 + (i * 16), 240);
    end
end

function StateSongSelect:draw()
    self:drawCassette();
    self:drawAlbumArt(175, 30);
    -- self:drawDebugSongList();
end

function StateSongSelect:songMoveDown()
    if(self.selector.source < #self.songList) then
        self.songList[self.selector.source].renderables.audio.renderable:stop();
        self.selector.source = self.selector.source + 1;
        self.songList[self.selector.source].renderables.audio.renderable:seek(self.songList[self.selector.source].mapping.previewStart or 0, "seconds");
        self.songList[self.selector.source].renderables.audio.renderable:play();
    end
end

function StateSongSelect:songMoveUp()
    if(self.selector.source > 1) then
        self.songList[self.selector.source].renderables.audio.renderable:stop();
        self.selector.source = self.selector.source - 1;
        self.songList[self.selector.source].renderables.audio.renderable:seek(self.songList[self.selector.source].mapping.previewStart or 0, "seconds");
        self.songList[self.selector.source].renderables.audio.renderable:play();
    end
end

function StateSongSelect:keypressed(k)
    if(k == settings.controls.up) then
        self:songMoveUp();
    elseif(k == settings.controls.down) then
        self:songMoveDown();
    end
end