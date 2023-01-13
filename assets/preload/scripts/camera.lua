-- SCRIPT BY AFLAC --
-- rewritten about 10 times
-- offsets from the characters camera position, not the center or any wacky offset

-- version 1.0.0

local enabled = false -- cutscene

local debug_mode = false --[[ 
    i would like to point out the fact that the debug mode was the last thing i added to this script. I never used it when making the script itself
    i put it in because first of all, debug mode cool
    and second of all, i wanted to allow people to see whats going on behind the scenes of the script- visually that is.
]]
local camMoves = { -- offsets for each animation
    --['animation name']= {x,  y},
    ['idle']          = { 0, 0 }, -- idle also acts as the default camera position
    ['singLEFT']      = { -20, 0 },
    ['singLEFT-alt']  = { -20, 0 },
    ['singLEFTmiss']  = { -10, 0 },
    ['singUP']        = { 0, -10 },
    ['singUP-alt']    = { 0, -10 },
    ['singUPmiss']    = { 0, -2.5 },
    ['singRIGHT']     = { 20, 0 },
    ['singRIGHT-alt'] = { 20, 0 },
    ['singRIGHTmiss'] = { 10, 0 },
    ['singDOWN']      = { 0, 10 },
    ['singDOWN-alt']  = { 0, 10 },
    ['singDOWNmiss']  = { 0, 2.5 }
}

local cameras = { -- use triggerEvent('','camera',[dad,gf,bf]) to toggle each ones camera movement
    ['boyfriend'] = true,
    ['dad']       = true,
    ['gf']        = true,
}

-- you can disregard everything below because theres nothing you gotta touch below :)

local function midpoint(character)
    local x = getProperty(character .. ".x") + (getProperty(character .. ".width") * 0.5)
    local y = getProperty(character .. ".y") + (getProperty(character .. ".height") * 0.5)

    if character == 'boyfriend' then
        x = x - 100
        y = y - 100
    else
        x = x + 150
        y = y - 100
    end
    local retur = { x, y }
    return retur
end

local function altCharacterNames(character) -- just in case someone wants to trigger the cameras using an alt name
    character = string.lower(character)
    if character == 'bf' or character == 'player' then
        character = 'boyfriend'
    end
    if character == 'opponent' or character == 'opp' then
        character = 'dad'
    end
    if character == 'girlfriend' or character == 'woman' then
        character = 'gf'
    end
    return character
end

local function getOffsets(character)
    character = altCharacterNames(character)
    local offsets = { midpoint(character)[1] + getProperty(character .. '.cameraPosition[0]'),
        midpoint(character)[2] + getProperty(character .. '.cameraPosition[1]') }
    if character == 'boyfriend' then -- because its reversed for bf
        offsets = { midpoint(character)[1] - getProperty(character .. '.cameraPosition[0]'),
            midpoint(character)[2] + getProperty(character .. '.cameraPosition[1]') }
    end
    return offsets
end

local function doDebugStuffs()

end

local function moveCamera(character, pose) -- this is essentially what handles the entire thing

    character = altCharacterNames(character)
    local characterOffsets = getOffsets(character)

    if not camMoves[pose] then
        pose = 'idle'
    end

    local offset = { characterOffsets[1], characterOffsets[2] }
    if cameras[character] then
        offset[1] = offset[1] + camMoves[pose][1]
        offset[2] = offset[2] + camMoves[pose][2]
    end

    triggerEvent('Camera Follow Pos', offset[1], offset[2])

    if debug_mode then
        setProperty('cameraPositionOffset.x',offset[1] - 10)
        setProperty('cameraPositionOffset.y',offset[2] - 10)

        setProperty('cameraPositionCurrent.x',getProperty('camFollowPos.x')- 5)
        setProperty('cameraPositionCurrent.y',getProperty('camFollowPos.y')- 5)

        setProperty('cameraPositionMarker.x',characterOffsets[1] - 10)
        setProperty('cameraPositionMarker.y',characterOffsets[2]- 10)
    end
end

-- this function used to be hella fucking messy but its seperated into functions and it's also far more efficient!!! woo!!
function onUpdate(elapsed)
    -- ITS SO FUCKING SMALL NOW WHAT!!!
    -- Context: the first few iterations of this script had like 50 lines here (and it barely worked too!!)

    if enabled then
    if gfSection then -- handle gfs camera because it's special!!
        moveCamera('gf', getProperty('gf.animation.curAnim.name'))
    else
        if mustHitSection then
            moveCamera('boyfriend', getProperty('boyfriend.animation.curAnim.name'))
        else
            moveCamera('dad', getProperty('dad.animation.curAnim.name'))
        end
    end
end
    if inGameOver then
        close() -- don't want this fucking up the camera
    end
end

function onEvent(name, value1, value2)
    if name == '' then
        if value1 == 'camera' then
            if value2 == 'dad' or value2 == 'boyfriend' or value2 == 'gf' then
                cameras[value2] = not cameras[value2]
            end
        end
    end
end

function onSongStart()
    enabled = true
end

function onCreatePost()
    if debug_mode then
        luaDebugMode = true
        makeLuaSprite('cameraPositionMarker','',0,0)
        makeGraphic('cameraPositionMarker',20,20,'2659ff')
        --setBlendMode('cameraPositionMarker','subtract')

        makeLuaSprite('cameraPositionCurrent','',0,0)
        makeGraphic('cameraPositionCurrent',10,10,'ee0dff')

        makeLuaSprite('cameraPositionOffset','',0,0)
        makeGraphic('cameraPositionOffset',20,20,'ff0000')
       --setBlendMode('cameraPositionOffset','invert')

        addLuaSprite('cameraPositionMarker',true)
        addLuaSprite('cameraPositionCurrent',true)
        addLuaSprite('cameraPositionOffset',true)
    end
end

-- SCRIPT BY AFLAC --
-- if you encounter a bug when making it please let me know in my discord server (https://discord.gg/aflac) or on discord directly, (@aflac#0001) --
-- ty --