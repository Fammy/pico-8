pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
    min_x = 1
    max_x = 127
    min_y = 7
    max_y = 128
    
    color = {}
    color.black = 0
    color.dark_gray = 5
    color.white = 7

    score = 0

    player = {}
    player.spr = 0
    player.w = 16
    player.h = 3
    player.x = (max_x - player.w) / 2
    player.y = max_y - player.h
    player.inertia = 4

    ball = {}
    ball.spr = 2 
    ball.w = 4
    ball.h = 4
    ball.inertia = .5
    new_ball()

    sounds = {}
    sounds.hit = 3
    sounds.miss = 1
    sounds.bounce = 2
end

function new_ball()
    ball.x = player.x + (player.w / 2)
    ball.y = player.y - ball.h
    ball.dx = ball.inertia
    ball.dy = -ball.inertia
end

function _draw()
    cls(color.black)
    rect(0, 6, 127, 128, color.dark_gray)
    draw_ball()
    draw_player()
    draw_score()
end

function draw_player()
    spr(player.spr, player.x, player.y)
    spr(player.spr, player.x + player.w / 2, player.y)
end

function draw_ball()
    spr(ball.spr, ball.x, ball.y)
end

function draw_score()
    print("score: "..tostr(score), 0, 0, color.white)
end

function _update()
    -- player
    if (btn(0)) then player.x -= player.inertia end
    if (player.x < min_x) then player.x = min_x end

    if (btn(1)) then player.x += player.inertia end
    if (player.x + player.w > max_x) then player.x = max_x - player.w end

    -- ball
    ball.x += ball.dx
    if (ball.x <= min_x) then
        ball.dx = abs(ball.dx)
        ball.x += ball.dx
        sfx(sounds.bounce)
    end
    if (ball.x + ball.w >= max_x) then
        ball.dx = -abs(ball.dx)
        sfx(sounds.bounce)
    end

    ball.y += ball.dy
    if (ball.y <= min_y) then
        ball.dy = abs(ball.dy)
        sfx(sounds.bounce)
    end
    --if (ball.y > player.y) then ball.dy = -abs(ball.dy) end
    
    if ball.y + ball.h >= player.y then
        if (ball.x + ball.w >= player.x) and (ball.x < player.x + player.w) then
        --if (ball.x >= player.x and ball.x <= player.x + player.w) or (ball.x + ball.w >= player.x and ball.x + ball.w <= player.x + player.w) then
            ball.dy = -abs(ball.dy)
            sfx(sounds.hit)
            score += 1
        elseif (ball.y >= max_y) then
            new_ball()
            sfx(sounds.miss)
            score -= 1
            if (score <= 0) then score = 0 end
        end
    end
end

__gfx__
77777777000110000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666001881001151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555018888101111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000188888810110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000188888810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000018888100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000c050180501505013050100502f0500f0600e060320600e0600e0601006012060160501d0502b0102e0102e0502e0500e0502e0502d0402b04024040200401a0401904017050170500c0500c0500c050
000100000000017050170501705017050170501705017050170501705017050120500e0500c0500a0500905006050040500205001050010500105001050010500105000000000000205001050000000000000000
00020000000000000000000380503a050010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000705007050070500705007050070500705008050080500805000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
