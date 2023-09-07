-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

-- Returns the distance between two points.
function math.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

-- Returns the angle between two vectors assuming the same origin.
function math.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

-- Set a random seed
love.math.setRandomSeed(love.timer.getTime())

function DecimalsToMinutes(dec)
    local ms = tonumber(dec)
    return math.floor(ms / 60).." : "..math.floor(ms % 60)
end

-- Debug Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Display traces in console during runtime
io.stdout:setvbuf("no")

local musicMenu = love.audio.newSource("assets/sounds/TomatesMenu_finale.mp3", "stream")
local musicGameplay = love.audio.newSource("assets/sounds/TomatesExpress_finale.mp3", "stream")
local musicAmbiance = love.audio.newSource("assets/sounds/Ambiance.wav", "stream")

require("menu")
require("gameplay")

scene = "menu"

function love.load()
    love.window.setMode(1920, 1080)
    loadMenu()
end

function love.update(dt)
    if scene == "menu" then
        updateMenu(dt)
        musicGameplay:stop()
        -- musicAmbiance:stop()

        love.audio.setVolume(0.4)
        musicMenu:setLooping(true)
        musicMenu:play()
    elseif scene == "gameplay" then
        updateGameplay(dt)
        musicMenu:stop()

        love.audio.setVolume(0.4)
        musicGameplay:setLooping(true)
        musicGameplay:play()
        -- musicAmbiance:setLooping(true)
        -- musicAmbiance:play()
    end
end

function love.draw()
    if scene == "menu" then
        drawMenu()
    elseif scene == "gameplay" then
        drawGameplay()
    end
end

function love.keypressed(key)
    print("Touche enfoncée : " .. key)
    if key and scene == "menu" and key ~= "escape" then
        scene = "gameplay"
        -- soundStart:play()
        loadGameplay()
    end
    if key == "escape" and scene == "gameplay" then
        scene = "menu"
        loadMenu()
    elseif key == "escape" and scene == "menu" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button, istouch)
    if scene == "menu" and button == 1 then
        scene = "gameplay"
        -- soundStart:play()
        loadGameplay()
    elseif scene == "gameplay" and button == 1 then
        if drawTutos == 0 then
            drawTutos = 1
        elseif drawTutos == 1 then
            drawTutos = 2
        elseif drawTutos == 2 then
            drawTutos = 3
        elseif drawTutos == 3 then
            drawTutos = 4
        elseif drawTutos == 4 then
            drawTutos = 5
        elseif drawTutos == 5 then
            drawTutos = 6
        elseif drawTutos == 6 then
            drawTutos = 7
        elseif drawTutos == 7 then
            drawTutos = 8
        elseif drawTutos == 8 then
            drawTutos = 9
        end
    end
 end
