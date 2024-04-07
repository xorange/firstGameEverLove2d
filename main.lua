require('camera')

math.randomseed(os.time())
math.random()

function time_ms()
    return love.timer.getTime() * 1000
end

function circlesIntersect(aX, aY, aRadius, bX, bY, bRadius)
    return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
end

function love.load()
    mainHull = love.graphics.newImage('assets/images/Hull_01.png') -- 256x256
    mainGun  = love.graphics.newImage('assets/images/Gun_01_256x256.png')
    mainScale = 0.2

    mainPosX = 400
    mainPosY = 300

    mainCenterOffsetX = mainHull:getWidth() / 2
    mainCenterOffsetY = mainHull:getHeight() / 2 + 35

    hullAngle = -math.pi / 2
    gunAngle  = -math.pi / 2
    mainHullAngleOffset = -math.pi / 2
    mainGunAngleOffset = math.pi / 2

    gunLength = 180

    bullets = {}
    enemies = {}

    enemy_level = 1
    enemy_level_durations_ms = {10000, 5000, 5000, 5000, 0}
    enemy_level_intervals_ms = {2000, 1500, 1000, 500, 300}
    enemy_level_last_ms = time_ms()
    enemy_spawn_last_ms = enemy_level_last_ms
end

function love.draw()
    -- The transformation stack is reset every frame, so we must apply our changes every frame.

    camera:set()


    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(mainHull,
        mainPosX, mainPosY,                     -- pos
        hullAngle + mainHullAngleOffset,        -- rotation
        mainScale, mainScale,                   -- scale
        mainCenterOffsetX, mainCenterOffsetY    -- offset
    )
    love.graphics.draw(mainGun,
        mainPosX, mainPosY,
        gunAngle + mainGunAngleOffset,
        mainScale, mainScale,
        mainCenterOffsetX, mainCenterOffsetY
    )

    for bulletIndex, bullet in ipairs(bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.x, bullet.y, 4)
    end

    for enemyIdx, enemy in ipairs(enemies) do
        if enemy.health == 3 then
            love.graphics.setColor(0, 0, 1)
        elseif enemy.health == 2 then
            love.graphics.setColor(1, 1, 0)
        elseif enemy.health == 1 then
            love.graphics.setColor(1, 0, 0)
        end
        love.graphics.circle('fill', enemy.x, enemy.y, 8)
    end

    love.graphics.setColor(0, 1, 0)
    love.graphics.circle('fill', mainPosX, mainPosY, 2)

    love.graphics.setColor(1, 1, 1)
    camera:unset()
end

function spawn_enemy(radius)
    pi = 3.14159265
    spawn_angle = math.random()
    spawn_angle = spawn_angle * pi * 2

    table.insert(enemies, {
        x = mainPosX + math.cos(spawn_angle) * radius,
        y = mainPosY + math.sin(spawn_angle) * radius,
        health = 3,
    })
end

function update_enemy_spawn()
    t = time_ms()

    if enemy_level_durations_ms[enemy_level] ~= 0 then
        if (t - enemy_level_last_ms) > enemy_level_durations_ms[enemy_level] then
            enemy_level = enemy_level + 1
            if enemy_level > #enemy_level_durations_ms then
                enemy_level = #enemy_level_durations_ms
            end
            enemy_level_last_ms = t
        end
    end

    if (t - enemy_spawn_last_ms) > enemy_level_intervals_ms[enemy_level] then
        spawn_enemy(300)
        enemy_spawn_last_ms = t
    end
end

function rotate_Hull()
    local rotateX = 0
    local rotateY = 0

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        rotateX = 1
    end
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        rotateX = -1
    end
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        rotateY = -1
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        rotateY = 1
    end

    if rotateX ~= 0 or rotateY ~= 0 then
        hullAngle = math.atan2(rotateY, rotateX)
    end
end

function rotate_Gun()
    x, y = camera:mousePosition()

    gunAngle = math.atan2(y - mainPosY, x - mainPosX)
end

function move_mainPos(dt)
    local speed = 100

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        mainPosX = mainPosX + speed * dt
        camera:move(speed * dt, 0)
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        mainPosX = mainPosX - speed * dt
        camera:move(-speed * dt, 0)
    end

    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        mainPosY = mainPosY - speed * dt
        camera:move(0, -speed * dt)
    end

    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        mainPosY = mainPosY + speed * dt
        camera:move(0, speed * dt)
    end
end

function love.update(dt)

    rotate_Hull()
    rotate_Gun()
    move_mainPos(dt)

    for enemyIdx, enemy in ipairs(enemies) do
        local enemySpeed = 30
        toward = math.atan2(mainPosY - enemy.y, mainPosX - enemy.x)
        enemy.x = (enemy.x + math.cos(toward) * enemySpeed * dt)
        enemy.y = (enemy.y + math.sin(toward) * enemySpeed * dt)

        if circlesIntersect(enemy.x, enemy.y, 4, mainPosX, mainPosY, 2) then
            print('Ouch!')
        end
    end

    for bulletIndex, bullet in ipairs(bullets) do
        bullet.alive = bullet.alive - dt

        if bullet.alive <= 0 then
            table.remove(bullets, bulletIndex)
        else
            local bulletSpeed = 80
            bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt)
            bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt)
        end

        for enemyIdx, enemy in ipairs(enemies) do
            if circlesIntersect(bullet.x, bullet.y, 2, enemy.x, enemy.y, 4) then
                table.remove(bullets, bulletIndex)

                enemy.health = enemy.health - 1
                if enemy.health <= 0 then
                    table.remove(enemies, enemyIdx)
                end
            end
        end
    end

    -- camera.setPosition(mainPosX, mainPosY)

    update_enemy_spawn()
end

function love.mousepressed(x, y, button, istouch)
    x, y = camera:mousePosition()

    gunTipX = mainPosX + math.cos(gunAngle) * gunLength * mainScale
    gunTipY = mainPosY + math.sin(gunAngle) * gunLength * mainScale

    if button == 1 then
        table.insert(bullets, {
            x = gunTipX,
            y = gunTipY,
            angle = gunAngle, -- math.atan2(y - mainPosY, x - mainPosX),
            alive = 3,
        })
        -- print('click', x, y, 'mainHull', mainPosX, mainPosY, 'angle', math.atan2(y - mainPosY, x - mainPosX))
   end
end

function love.keypressed(key, u)
    --Debug
    if key == "lctrl" then --set to whatever key you want to use
        debug.debug()
    end
end
