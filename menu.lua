local background = nil

function loadMenu()
    background = love.graphics.newImage("assets/images/ui/MenuPressAnyButton.png")
end

function updateMenu(dt)
end

function drawMenu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(0, 0, 0)
    -- love.graphics.print("MENU")
end