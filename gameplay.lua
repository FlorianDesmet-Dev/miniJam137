local screenWidth = 0
local screenHeight = 0

local background = love.graphics.newImage("assets/images/sol.png")
local backgroundVignette = love.graphics.newImage("assets/images/vignette.png")
spawnArena = 
{
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local gameover = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local win = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local player = 
{
    image = nil,
    width = 0,
    height = 0,
    speed = 0,
    x = 0,
    y = 0,
    vx = 0,
    vy = 0
}

-- ANIMs
local frame = 1

local playerAnim = {}

local animStates = {
    idle = 1,
    walk = 2,
    takeTomatoes = 3,
    sad = 4,
    happy = 5
}

playerAnim[animStates.idle] = {
    first = 1,
    last = 6,
    speed = 12,
    loop = true
}

playerAnim[animStates.walk] = {
    first = 7,
    last = 14,
    speed = 17,
    loop = true
}

playerAnim[animStates.takeTomatoes] = {
    first = 9,
    last = 13,
    speed = 3,
    loop = false
}

playerAnim[animStates.sad] = {
    first = 13,
    last = 17,
    speed = 3,
    loop = false
}

playerAnim[animStates.happy] = {
    first = 13,
    last = 17,
    speed = 3,
    loop = false
}

local currentAnimation = 0

local currentClient = {}

local nbTomatoes = 10
local listTomatoes = {}
local listGetTomatoes = {}
local imageTomatoes = 
{
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
}

local cursor = 
{
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local caddy = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local pancarte = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local coin = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local fleche = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local timer = 
{
    image = nil,
    width = 0,
    height = 0,
    x = 0,
    y = 0
}

local clients = 
{
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {}
}

tuto1 = love.graphics.newImage("assets/images/tuto1.png")
tuto2 = love.graphics.newImage("assets/images/tuto2.png")
tuto3 = love.graphics.newImage("assets/images/tuto3.png")
tuto4 = love.graphics.newImage("assets/images/tuto4.png")
tuto5 = love.graphics.newImage("assets/images/tuto5.png")
tuto6 = love.graphics.newImage("assets/images/tuto6.png")
tuto7 = love.graphics.newImage("assets/images/tuto7.png")
tuto8 = love.graphics.newImage("assets/images/tuto8.png")

local getTomatoes = false
local mousepressed = false

local timeLeft = 0
local currentCoin = 0
local coinEarn = currentCoin
local order = 0
local listOrder = {}
local addCoin = 0
local timerCoinAdded = 0
local numberClient = 0
local stateGameover = false
local stateWin = false
local coinTotal = 0
drawTutos = 0

-- SFX
local soundDragTomato = love.audio.newSource("assets/sounds/Ramassage_tomate_1.wav", "static")
local soundGoodTomato1 = love.audio.newSource("assets/sounds/Validation_tomate_1.wav", "static")
local soundBadTomato1 = love.audio.newSource("assets/sounds/Mauvaise_tomate_1.wav", "static")
local soundClientHappy1 = love.audio.newSource("assets/sounds/Client_content_1.wav", "static")
local soundClientSad1 = love.audio.newSource("assets/sounds/Client_mecontent_1.wav", "static")

function CreateTomatoes()
    local newTomatoes = {}
    newTomatoes.state = love.math.random(1, 7)
    newTomatoes.timeStateTomatoes = 0
    newTomatoes.timeStateTomatoesMax = love.math.random(5, 15)
    newTomatoes.isGround = true
    if newTomatoes.state == 1 then
        newTomatoes.image = imageTomatoes[1]
    elseif newTomatoes.state == 2 then
        newTomatoes.image = imageTomatoes[2]
    elseif newTomatoes.state == 3 then
        newTomatoes.image = imageTomatoes[3]
    elseif newTomatoes.state == 4 then
        newTomatoes.image = imageTomatoes[4]
    elseif newTomatoes.state == 5 then
        newTomatoes.image = imageTomatoes[5]
    elseif newTomatoes.state == 6 then
        newTomatoes.image = imageTomatoes[6]
    elseif newTomatoes.state == 7 then
        newTomatoes.image = imageTomatoes[7]
    end
    newTomatoes.width = newTomatoes.image:getWidth()
    newTomatoes.height = newTomatoes.image:getHeight()
    newTomatoes.x = love.math.random(0 + 35, spawnArena.width - newTomatoes.width)
    newTomatoes.y = love.math.random(0 + 35, spawnArena.height - newTomatoes.height)
    
    return newTomatoes
end

function CreateClient(pN)
    local newClient = {}
    newClient.image = love.graphics.newImage("assets/images/Client"..pN..".png")
    newClient.width = newClient.image:getWidth()
    newClient.height = newClient.image:getHeight()
    newClient.x = 0 - newClient.width
    newClient.y = screenHeight - newClient.height
    newClient.order = love.math.random(5, 15)
    newClient.speed = 500

    newClient.orderStateTomatoes = CreateTomatoes()
    newClient.orderStateTomatoes.state = math.random(1, 7)
    if newClient.orderStateTomatoes.state == 1 then
        newClient.orderStateTomatoes.image = imageTomatoes[1]
    elseif newClient.orderStateTomatoes.state == 2 then
        newClient.orderStateTomatoes.image = imageTomatoes[2]
    elseif newClient.orderStateTomatoes.state == 3 then
        newClient.orderStateTomatoes.image = imageTomatoes[3]
    elseif newClient.orderStateTomatoes.state == 4 then
        newClient.orderStateTomatoes.image = imageTomatoes[4]
    elseif newClient.orderStateTomatoes.state == 5 then
        newClient.orderStateTomatoes.image = imageTomatoes[5]
    elseif newClient.orderStateTomatoes.state == 6 then
        newClient.orderStateTomatoes.image = imageTomatoes[6]
    elseif newClient.orderStateTomatoes.state == 7 then
        newClient.orderStateTomatoes.image = imageTomatoes[7]
    end
    newClient.orderStateTomatoes.x = caddy.x + (caddy.width / 2 - 25)
    newClient.orderStateTomatoes.y = caddy.y + (caddy.height / 2 + 55)

    return newClient
end

function ChangeAnimation(pAnim)
    if currentAnimation ~= pAnim then
        currentAnimation = pAnim
        frame = playerAnim[currentAnimation].first
    end
end

function UpdateAnimation(dt)
    frame = frame + dt * playerAnim[currentAnimation].speed
    if frame >= playerAnim[currentAnimation].last + 1 then
        if playerAnim[currentAnimation].loop then
            frame = playerAnim[currentAnimation].first
        else
            frame = playerAnim[currentAnimation].last
        end
    end
end

function loadGameplay()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    spawnArena.width = 1850
    spawnArena.height = 810
    spawnArena.x = screenWidth / 2 - spawnArena.width / 2
    spawnArena.y = 35

    local mouse_x = love.mouse.getX()
    local mouse_y = love.mouse.getY()

    win.image = love.graphics.newImage("assets/images/ui/YouWin.png")
    win.width = win.image:getWidth()
    win.height = win.image:getHeight()
    win.x = screenWidth / 2 - win.width / 2
    win.y = screenHeight / 2 - win.height / 2

    gameover.image = love.graphics.newImage("assets/images/ui/YouLoose.png")
    gameover.width = gameover.image:getWidth()
    gameover.height = gameover.image:getHeight()
    gameover.x = screenWidth / 2 - gameover.width / 2
    gameover.y = screenHeight / 2 - gameover.height / 2
    
    listTomatoes = {}

    timeLeft = 180
    coinEarn = 0
    currentCoin = 0
    coinTotal = 300

    cursor.width = 192
    cursor.height = 192

    -- PLAYER POSITIONS START
    player.listQuads = {}
    -- IDLE
    player.image = love.graphics.newImage("assets/images/perso.png")
    player.width = 600
    player.height = 600

    local l, c
    local imageWidth = player.image:getWidth()
    local imageHeight = player.image:getHeight()
    local lines = imageHeight / player.height
    local columns = imageWidth / player.width
    local id = 1
    for l = 1, lines do
        for c = 1, columns do
            local quad = love.graphics.newQuad(
                (c - 1) * player.width, 
                (l - 1) * player.height,
                player.width,
                player.height,
                player.image:getWidth(),
                player.image:getHeight()
            )
            player.listQuads[id] = quad
            print(id, (c - 1) * player.width, (l - 1) * player.height)
            id = id + 1
        end
    end
    
    player.speed = 850
    player.x = screenWidth / 2
    player.y = screenHeight / 2
    player.direction = 1

    -- CREATE TOMATOES
    for n = 1, 7 do
        imageTomatoes[n] = love.graphics.newImage("assets/images/tomates"..n..".png")
    end
    
    while #listTomatoes < nbTomatoes do
        local newTomatoes = CreateTomatoes()

        local insertTomatoes = true
        for k,v in ipairs(listTomatoes) do
            if CheckCollision(newTomatoes.x, newTomatoes.y, newTomatoes.width, newTomatoes.height, v.x, v.y, v.width, v.height) then
                insertTomatoes = false
                break
            end
        end

        if insertTomatoes == true then
            table.insert(listTomatoes, newTomatoes)
        end
    end

    -- GUI
    caddy.image = love.graphics.newImage("assets/images/panier.png")
    caddy.width = caddy.image:getWidth()
    caddy.height = caddy.image:getHeight()
    caddy.x = screenWidth / 2 - caddy.width
    caddy.y = screenHeight - caddy.height

    pancarte.image = love.graphics.newImage("assets/images/pancarte.png")
    pancarte.width = pancarte.image:getWidth()
    pancarte.height = pancarte.image:getHeight()
    pancarte.x = screenWidth - pancarte.width
    pancarte.y = screenHeight - pancarte.height

    coin.image = love.graphics.newImage("assets/images/coin.png")
    coin.width = coin.image:getWidth()
    coin.height = coin.image:getHeight()
    coin.x = pancarte.x + 25
    coin.y = pancarte.y + 25

    fleche.image = love.graphics.newImage("assets/images/fleche.png")
    fleche.width = fleche.image:getWidth()
    fleche.height = fleche.image:getHeight()
    fleche.x = caddy.x + 50
    fleche.y = caddy.y + caddy.height / 2 - 15

    timer.image = love.graphics.newImage("assets/images/timer.png")
    timer.width = timer.image:getWidth()
    timer.height = timer.image:getHeight()
    timer.x = coin.x
    timer.y = coin.y + coin.height

    -- CREATE CLIENTS
    numberClient = love.math.random(1, 4)
    currentClient = CreateClient(numberClient)

    stateGameover = false
    stateWin = false
    drawTutos = 1
end

function updateGameplay(dt)
    if drawTutos == 9 then
        local mouse_x = love.mouse.getX()
        local mouse_y = love.mouse.getY()

        if love.mouse.isDown(1) then
            mousepressed = true
        else
            mousepressed = false
        end

        -- PLAYER FOLLOW MOUSE
        local angle = math.angle(player.x, player.y, mouse_x, mouse_y)
        local distance = math.dist(player.x, player.y, mouse_x, mouse_y)
        player.vx = player.speed * math.cos(angle)
        player.vy = player.speed * math.sin(angle)
        player.x = player.x + player.vx * dt
        player.y = player.y + player.vy * dt
        if distance < 18.8 then
            player.x = mouse_x
            player.y = mouse_y
            ChangeAnimation(animStates.idle)
        elseif distance > 20.2 then
            ChangeAnimation(animStates.walk)
        end

        -- PLAY ANIMATIONS
        UpdateAnimation(dt)

        if mouse_x > player.x + 50 then
            player.direction = 1
        elseif mouse_x < player.x - 50 then
            player.direction = 2
        end

        cursor.x = player.x - cursor.width / 2
        cursor.y = player.y - cursor.height / 2
        
        if stateGameover == false and stateWin == false then
            -- GET TOMATOES
            for n = #listTomatoes, 1, -1 do
                local v = listTomatoes[n]
                if v.isGround == true then
                    v.timeStateTomatoes = v.timeStateTomatoes + 1 * dt
                    if v.timeStateTomatoes >= v.timeStateTomatoesMax and v.state <= 6 then
                        v.state = v.state + 1
                        v.timeStateTomatoes = 0
                        v.timeStateTomatoesMax = love.math.random(5, 15)
                    end
                end

                if CheckCollision(cursor.x, cursor.y, cursor.width, cursor.height, v.x, v.y, v.width, v.height) then
                    if getTomatoes == false and mousepressed then
                        love.audio.setVolume(1)
                        soundDragTomato:play()
                        local newTomato = CreateTomatoes()
                        newTomato.state = v.state
                        if player.direction == 1 then
                            v.x = player.x - 100
                        elseif player.direction == 2 then
                            v.x = player.x + 100
                        end
                        v.y = player.y - 37
                        table.insert(listGetTomatoes, newTomato)
                        table.remove(listTomatoes, n)             
                        break
                    end
                end
            end
            
            -- LIST GET TOMATOES
            for n = #listGetTomatoes, 1, -1 do
                local v = listGetTomatoes[n]
                if mousepressed then
                    getTomatoes = true
                    v.isGround = false
                    if player.direction == 1 then
                        v.x = player.x - 100
                    elseif player.direction == 2 then
                        v.x = player.x + 100
                    end
                    v.y = player.y - 37
                else
                    if CheckCollision(player.x, player.y, player.width - 300, player.height - 300, caddy.x, caddy.y, caddy.width, caddy.height) then
                        v.y = v.y + 500 * dt
                    else
                        table.remove(listGetTomatoes, n)
                        while #listTomatoes < nbTomatoes do
                            local newTomatoes = CreateTomatoes()
                            local insertTomatoes = true
                            for k,v in ipairs(listTomatoes) do
                                if CheckCollision(newTomatoes.x, newTomatoes.y, newTomatoes.width, newTomatoes.height, v.x, v.y, v.width, v.height) then
                                    insertTomatoes = false
                                    break
                                end
                            end
                    
                            if insertTomatoes == true then
                                table.insert(listTomatoes, newTomatoes)
                            end
                        end
                    end
                    if v.y > screenHeight + v.height / 2 then
                        table.remove(listGetTomatoes, n)
                        while #listTomatoes < nbTomatoes do
                            local newTomatoes = CreateTomatoes()
                            local insertTomatoes = true
                            for k,v in ipairs(listTomatoes) do
                                if CheckCollision(newTomatoes.x, newTomatoes.y, newTomatoes.width, newTomatoes.height, v.x, v.y, v.width, v.height) then
                                    insertTomatoes = false
                                    break
                                end
                            end
                    
                            if insertTomatoes == true then
                                table.insert(listTomatoes, newTomatoes)
                            end
                        end
                    end

                    getTomatoes = false
                end

                -- ADD TOMATOES INTO CADDY
                if CheckCollision(v.x, v.y, v.width, v.height, caddy.x, caddy.y + caddy.height - 100, caddy.width, caddy.height / 2) then
                    if currentClient.order > 0 then
                        table.insert(listOrder, n)
                        currentClient.order = currentClient.order - 1
                        if v.state == currentClient.orderStateTomatoes.state then
                            love.audio.setVolume(1)
                            soundGoodTomato1:play()
                            soundClientHappy1:play()
                            currentCoin = currentCoin + 10
                            addCoin = 1
                        elseif v.state == currentClient.orderStateTomatoes.state + 1 or v.state == currentClient.orderStateTomatoes.state - 1 then
                            love.audio.setVolume(1)
                            soundGoodTomato1:play()
                            soundClientHappy1:play()
                            currentCoin = currentCoin + 5
                            addCoin = 2
                        else
                            love.audio.setVolume(1)
                            soundBadTomato1:play()
                            soundClientSad1:play()
                            currentCoin = currentCoin + 0
                            addCoin = 3
                        end
                    end
                    
                    table.remove(listGetTomatoes, n)
                    getTomatoes = false

                    while #listTomatoes < nbTomatoes do
                        newTomatoes = CreateTomatoes()
                
                        local insertTomatoes = true
                        for k,v in ipairs(listTomatoes) do
                            if CheckCollision(newTomatoes.x, newTomatoes.y, newTomatoes.width, newTomatoes.height, v.x, v.y, v.width, v.height) then
                                insertTomatoes = false
                                break
                            end
                        end
                
                        if insertTomatoes == true then
                            table.insert(listTomatoes, newTomatoes)
                        end
                    end
                end
            end

            if addCoin == 1 or addCoin == 2 or addCoin == 3 then
                timerCoinAdded = timerCoinAdded + 1 * dt
                if timerCoinAdded >= 2 then
                    timerCoinAdded = 0
                    addCoin = 0
                end
            end

            if currentClient.order > 0 then
                if currentClient.x <= caddy.x - currentClient.width then
                    currentClient.x = currentClient.x + currentClient.speed * dt
                end

                if currentClient.x >= caddy.x - currentClient.width then
                    currentClient.x = caddy.x - currentClient.width
                end
            end

            if currentClient.order == 0 then
                coinEarn = coinEarn + currentCoin
                currentCoin = 0
                currentClient.x = currentClient.x - currentClient.speed * dt
                if currentClient.x <= 0 - currentClient.width then
                    numberClient = love.math.random(1, 4)
                    currentClient = CreateClient(numberClient)
                end
            end

            if coinEarn >= coinTotal then
                stateWin = true
            else
                stateWin = false
            end

            -- LIMIT
            if player.x + 143 >= screenWidth then
                player.x = screenWidth - 143
            elseif player.x - 143 <= 0 then
                player.x = 0 + 143
            elseif player.y + 143 >= screenHeight then
                player.y = screenHeight - 143
            elseif player.y - 143 <= 0 then
                player.y = 0 + 143
            end

            -- TIMELEFT
            timeLeft = timeLeft - 1 * dt
            if timeLeft <= 0 then
                timeLeft = 0
                stateGameover = true
            else
                stateGameover = false
            end
        end
    end
end

function drawGameplay()
    local mainFont = love.graphics.newFont("assets/font/impact.ttf", 75)
    love.graphics.setFont(mainFont)

    -- DISPLAY BACKGROUND
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(backgroundVignette, 0, 0)
    --[[ love.graphics.setColor(1, 1, 1, .5)
    love.graphics.rectangle("fill", spawnArena.x, spawnArena.y, spawnArena.width, spawnArena.height) ]]
    love.graphics.setColor(0, 0, 0, 1)

    --DISPLAY TOMATOES
    for k,v in ipairs(listTomatoes) do
        love.graphics.setColor(1, 1, 1)
        if v.state == 1 then
            love.graphics.draw(imageTomatoes[1], v.x, v.y)
        elseif v.state == 2 then
            love.graphics.draw(imageTomatoes[2], v.x, v.y)
        elseif v.state == 3 then
            love.graphics.draw(imageTomatoes[3], v.x, v.y)
        elseif v.state == 4 then
            love.graphics.draw(imageTomatoes[4], v.x, v.y)
        elseif v.state == 5 then
            love.graphics.draw(imageTomatoes[5], v.x, v.y)
        elseif v.state == 6 then
            love.graphics.draw(imageTomatoes[6], v.x, v.y)
        elseif v.state == 7 then
            love.graphics.draw(imageTomatoes[7], v.x, v.y)
        end
        love.graphics.setColor(0, 0, 0)
    end

    --DISPLAY GET TOMATOES
    for k,v in ipairs(listGetTomatoes) do
        love.graphics.setColor(1, 1, 1)
        if v.state == 1 then
            love.graphics.draw(imageTomatoes[1], v.x, v.y, 0, 1, 1, imageTomatoes[1]:getWidth() / 2, imageTomatoes[1]:getHeight() / 2)
        elseif v.state == 2 then
            love.graphics.draw(imageTomatoes[2], v.x, v.y, 0, 1, 1, imageTomatoes[2]:getWidth() / 2, imageTomatoes[2]:getHeight() / 2)
        elseif v.state == 3 then
            love.graphics.draw(imageTomatoes[3], v.x, v.y, 0, 1, 1, imageTomatoes[3]:getWidth() / 2, imageTomatoes[3]:getHeight() / 2)
        elseif v.state == 4 then
            love.graphics.draw(imageTomatoes[4], v.x, v.y, 0, 1, 1, imageTomatoes[4]:getWidth() / 2, imageTomatoes[4]:getHeight() / 2)
        elseif v.state == 5 then
            love.graphics.draw(imageTomatoes[5], v.x, v.y, 0, 1, 1, imageTomatoes[5]:getWidth() / 2, imageTomatoes[5]:getHeight() / 2)
        elseif v.state == 6 then
            love.graphics.draw(imageTomatoes[6], v.x, v.y, 0, 1, 1, imageTomatoes[6]:getWidth() / 2, imageTomatoes[6]:getHeight() / 2)
        elseif v.state == 7 then
            love.graphics.draw(imageTomatoes[7], v.x, v.y, 0, 1, 1, imageTomatoes[7]:getWidth() / 2, imageTomatoes[7]:getHeight() / 2)
        end
        love.graphics.setColor(0, 0, 0)
    end
    
    -- DISPLAY PLAYER
    local sens = 1
    if player.direction == 2 then
        sens = -1
    end
    love.graphics.setColor(1, 1, 1)
    local currentFrame = math.floor(frame)
    love.graphics.draw(player.image, player.listQuads[currentFrame], player.x, player.y, 0, sens, 1, player.width / 2, player.height / 2)
    love.graphics.setColor(0, 0, 0)

    -- GUI
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(caddy.image, caddy.x, caddy.y)
    love.graphics.draw(pancarte.image, pancarte.x, pancarte.y)
    love.graphics.draw(coin.image, coin.x, coin.y)
    love.graphics.draw(fleche.image, fleche.x, fleche.y)
    love.graphics.draw(timer.image, timer.x, timer.y)

    if addCoin == 1 then
        love.graphics.print("+10", caddy.x + caddy.width / 2 + 75, caddy.y)
    elseif addCoin == 2 then
        love.graphics.print("+5", caddy.x + caddy.width / 2 + 75, caddy.y)
    elseif addCoin == 3 then
        love.graphics.print("+0", caddy.x + caddy.width / 2 + 75, caddy.y)
    end
    love.graphics.setColor(0, 0, 0)
    
    mainFont = love.graphics.newFont("assets/font/impact.ttf", 26)
    love.graphics.setFont(mainFont)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(currentClient.orderStateTomatoes.image, currentClient.orderStateTomatoes.x, currentClient.orderStateTomatoes.y, 0, .8, .8, currentClient.orderStateTomatoes.image:getWidth() / 2, currentClient.orderStateTomatoes.image:getWidth() / 2)
    love.graphics.print("Coin Earn = "..coinEarn.."/ "..coinTotal, coin.x + coin.width + 20, coin.y + 20)
    love.graphics.print("Time Left = "..DecimalsToMinutes(timeLeft), coin.x + coin.width + 20, timer.y + 20)
    love.graphics.setColor(0, 0, 0)


    mainFont = love.graphics.newFont("assets/font/impact.ttf", 70)
    love.graphics.setFont(mainFont)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("X "..currentClient.order, caddy.x + caddy.width / 2 + 50, caddy.y + caddy.height / 2)
    love.graphics.setColor(0, 0, 0)

    -- DISPLAY CURSOR
    --[[ love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", cursor.x, cursor.y, cursor.width, cursor.height)
    love.graphics.setColor(0, 0, 0) ]]

    -- DISPLAY CLIENTS
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(currentClient.image, currentClient.x, currentClient.y)
    love.graphics.setColor(0, 0, 0)

    -- GAME WIN OR GAMEOVER
    love.graphics.setColor(1, 1, 1)
    if stateWin then
        love.graphics.draw(win.image, win.x, win.y)
    elseif stateGameover then
        love.graphics.draw(gameover.image, gameover.x, gameover.y)
    end
    love.graphics.setColor(0, 0, 0)
    
    if drawTutos == 1 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto1, screenWidth / 2 - tuto1:getWidth() / 2, screenHeight / 2 - tuto1:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 2 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto2, screenWidth / 2 - tuto2:getWidth() / 2, screenHeight / 2 - tuto2:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 3 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto3, screenWidth / 2 - tuto3:getWidth() / 2, screenHeight / 2 - tuto3:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 4 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto4, screenWidth / 2 - tuto4:getWidth() / 2, screenHeight / 2 - tuto4:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 5 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto5, screenWidth / 2 - tuto5:getWidth() / 2, screenHeight / 2 - tuto5:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 6 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto6, screenWidth / 2 - tuto6:getWidth() / 2, screenHeight / 2 - tuto6:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 7 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto7, screenWidth / 2 - tuto7:getWidth() / 2, screenHeight / 2 - tuto7:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    elseif drawTutos == 8 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(tuto8, screenWidth / 2 - tuto8:getWidth() / 2, screenHeight / 2 - tuto8:getHeight() / 2)
        love.graphics.setColor(0, 0, 0)
    end

    local infosFont = love.graphics.newFont(12)
    love.graphics.setFont(infosFont)

    --[[ love.graphics.setColor(1, 1, 1)
    love.graphics.print("Mouse x = "..tostring(love.mouse.getX()).. " Mouse y = "..tostring(love.mouse.getY()), 1, 1)
    love.graphics.print("Player x = "..tostring(math.floor(player.x)).. " Player y = "..tostring(math.floor(player.y)), 1, 17)
    love.graphics.print("Dist = "..tostring(math.floor(math.dist(player.x, player.y, love.mouse.getX(), love.mouse.getY()))), 1, 35)
    love.graphics.print("Get Tomatoes = "..tostring(getTomatoes), 1, 51)
    love.graphics.print("Current coin = "..tostring(currentCoin), 1, 67)
    love.graphics.setColor(0, 0, 0) ]]
end
