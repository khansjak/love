--Load
function love.load()
    --Zombies World Setup
    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    --Placing our shooter at center of the screen
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180

    -- Zombies table to contain all zombies instances
    zombies = {}
    bullets = {}

end

--Update
function love.update(dt)
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt -- *dt is to sync with frame rate if drops below 60 FPS
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end

    for i, z in ipairs(zombies) do
        z.x = z.x + math.cos(zombiePlayerAngle(z))
        z.y = z.y + math.sin(zombiePlayerAngle(z))
        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            for i, z in ipairs(zombies) do
                zombies[i] = nil
            end

        end
    end

    for i, b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    for i, z in ipairs(zombies) do
        for j, b in ipairs(bullets) do
            if distanceBetween(z.x,z.y,b.x,b.y)<20 then
                z.dead = true
                b.dead = true
            end
        end
    end

    for i=#zombies , 1,-1 do
        local z = zombies[i]
        if z.dead==true then
            table.remove(zombies,i)
        end
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

end

--Draw
function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth() / 2,
        sprites.player:getHeight() / 2)

    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth() / 2,
            sprites.zombie:getHeight() / 2)
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5, sprites.bullet:getWidth() / 2,
            sprites.bullet:getHeight() / 2)
    end

end

function love.keypressed(key)
    if key == "space" then
        spwanZombie()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spwanBullet()
    end
end

--- Player Facing Mouse
function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

--- Zombie Facing Player
function zombiePlayerAngle(enemy)
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spwanZombie()
    local zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.speed = 100
    table.insert(zombies, zombie)
    zombie.dead = false
end

function spwanBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.direction = playerMouseAngle()
    table.insert(bullets, bullet)
    bullet.dead = false
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
