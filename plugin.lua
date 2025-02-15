--[[
eaz -> ease
funz -> function
rizz -> ???
gizz -> king gizzard and the lizard wizard (???)
fizz -> ???
ptz -> points
gayz -> gaze
bizz -> business
sbizz -> still business
avz -> average (SV)
dizz -> distance
savz -> still average (SV)
sdizz -> still distance
tarz -> target
--]]
GAY = false
ITEM_WIDTH = 140
HALF_ITEM_WIDTH = ITEM_WIDTH / 2
BEEG_HAF = HALF_ITEM_WIDTH + 3
SMOL_HAF = HALF_ITEM_WIDTH - 3
X_DISPLACEMENT = -200
ONE_ZEROES = {
    "one",
    "zero",
}
BIZZIES = {
    "avz",
    "dizz",
}
SBIZZIES = {
    "no",
    "savz",
    "sdizz",
    "x",
}
TARZIES = {
    "start",
    "end",
    "auto",
    "otua",
}
local vars = {
    eazFunzIndex = 1,
    oneZeroIndex = 1,
    eazIndex = 1,
    rizz = 1,
    gizz = 1,
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = 1,
    fizz = 0,
    ptz = 16,
    bizzIndex = 1,
    sbizzIndex = 1,
    savz = 1,
    avz = 1,
    sdizz = 69,
    dizz = 69,
    tarzTypeIndex = 1,
    tarz = 69,
    plotMinScale = 0,
    plotMaxScale = 0,
    dizziesCache = {},
}

function draw()
    initializePluginWindowNotCollapsed()
    imgui.Begin("rizzupmyass", imgui_window_flags.AlwaysAutoResize)
    setPluginAppearance()
    
    imgui.PushItemWidth(SMOL_HAF)
    vars.eazFunzIndex = combo("##eazFunz", EAZ_FUNZIES, vars.eazFunzIndex)
    imgui.SameLine()
    vars.oneZeroIndex = combo("funz", ONE_ZEROES, vars.oneZeroIndex)
    
    imgui.PopItemWidth()
    
    local isZeroEnd = ONE_ZEROES[vars.oneZeroIndex] == "zero"
    local eazFunz = EAZ_FUNZIES[vars.eazFunzIndex]
    if eazFunz == "rey" then
        _, vars.rizz = imgui.DragFloat("rizz", vars.rizz, 0.01, 0, 999, "%.2f")
        vars.rizz = clamp(vars.rizz, 0, 999)
        
        _, vars.gizz = imgui.DragFloat("gizz", vars.gizz, 0.01, 0, 999, "%.2f")
        vars.gizz = clamp(vars.gizz, 0, 999)
        
        _, vars.fizz = imgui.DragFloat("fizz", vars.fizz, 0.01, -999, 999, "%.2f")
        vars.fizz = clamp(vars.fizz, -999, 999)
    elseif eazFunz == "bez" then
        imgui.PushItemWidth(SMOL_HAF)
        
        _, vars.x1 = imgui.DragFloat("##x1", vars.x1, 0.01, 0, 1, "%.2f")
        vars.x1 = clamp(vars.x1, 0, 1)
        
        imgui.SameLine()
        
        _, vars.y1 = imgui.DragFloat("pt1", vars.y1, 0.01, -1, 2, "%.2f")
        vars.y1 = clamp(vars.y1, -1, 2)
        
        _, vars.x2 = imgui.DragFloat("##x2", vars.x2, 0.01, 0, 1, "%.2f")
        vars.x2 = clamp(vars.x2, 0, 1)
        
        imgui.SameLine()
        
        _, vars.y2 = imgui.DragFloat("pt2", vars.y2, 0.01, -1, 2, "%.2f")
        vars.y2 = clamp(vars.y2, -1, 2)
        
        imgui.PopItemWidth()
        
        _, vars.fizz = imgui.DragFloat("fizz", vars.fizz, 0.01, -999, 999, "%.2f")
        vars.fizz = clamp(vars.fizz, -999, 999)
    else
        vars.eazIndex = combo("eaz", EAZIES, vars.eazIndex)
        
        _, vars.rizz = imgui.DragFloat("rizz", vars.rizz, 0.01, 0, 999, "%.2f")
        vars.rizz = clamp(vars.rizz, 0, 999)
        
        if eazFunz == "elaz" then
            _, vars.gizz = imgui.DragFloat("gizz", vars.gizz, 0.01, 0, 999, "%.2f")
            vars.gizz = clamp(vars.gizz, 0, 999)
        end
        
        local min = isZeroEnd and -999 or -1
        _, vars.fizz = imgui.DragFloat("fizz", vars.fizz, 0.01, min, 999, "%.2f")
        vars.fizz = clamp(vars.fizz, min, 999)
    end
    
    _, vars.ptz = imgui.InputInt("ptz", vars.ptz, 1, 1)
    vars.ptz = clamp(vars.ptz, 1, 999)
    
    if GAY and isAnyVariableChanged() then print("S!", "Gay") end -- gay
    if isAnyVariableChanged() then updateDizziesCache() end
    
    imgui.PlotLines("gayz", vars.dizziesCache, #vars.dizziesCache, 0, state.SelectedScrollGroupId,
            vars.plotMinScale, vars.plotMaxScale, {ITEM_WIDTH, 100})
    
    imgui.PushItemWidth(SMOL_HAF)
    
    local bizz = BIZZIES[vars.bizzIndex]
    if bizz == "avz" then
        _, vars.avz = imgui.InputFloat("##avz", vars.avz, 0, 0, "%.2fx")
    else
        _, vars.dizz = imgui.InputFloat("##dizz", vars.dizz, 0, 0, "%.1f msx")
    end
    imgui.SameLine()
    vars.bizzIndex = combo("bizz", BIZZIES, vars.bizzIndex)
    
    local sbizz = SBIZZIES[vars.sbizzIndex]
    if sbizz == "no" then
        imgui.Indent(BEEG_HAF)
        vars.sbizzIndex = combo("sbizz", SBIZZIES, vars.sbizzIndex)
        imgui.Unindent(BEEG_HAF)
    elseif sbizz == "savz" then
        _, vars.savz = imgui.InputFloat("##savz", vars.savz, 0, 0, "%.2fx")
        imgui.SameLine()
        vars.sbizzIndex = combo("sbizz", SBIZZIES, vars.sbizzIndex)
        chooseTarz()
    elseif sbizz == "sdizz" then
        _, vars.sdizz = imgui.InputFloat("##sdizz", vars.sdizz, 0, 0, "%.1f msx")
        imgui.SameLine()
        vars.sbizzIndex = combo("sbizz", SBIZZIES, vars.sbizzIndex)
        chooseTarz()
    elseif sbizz == "x" then
        imgui.Indent(BEEG_HAF)
        vars.sbizzIndex = combo("sbizz", SBIZZIES, vars.sbizzIndex)
        imgui.Unindent(BEEG_HAF)
        chooseTarz()
    end
    
    imgui.PopItemWidth()
    
    local buttonSize = {imgui.GetContentRegionAvailWidth(), 50}
    if imgui.Button("rizzupass", buttonSize) or utils.IsKeyPressed(keys.T) then placeSVs() end
    
    if utils.IsKeyPressed(keys.N) then deleteSVs() end
    
    local isBKeyPressed = utils.IsKeyPressed(keys.B)
    local isAltKeyDown = utils.IsKeyDown(keys.LeftAlt) or utils.IsKeyDown(keys.RightAlt)
    if isBKeyPressed and #state.SelectedHitObjects == 1 and isAltKeyDown then setupXTG() end
    if isBKeyPressed and #state.SelectedHitObjects == 1 and not isAltKeyDown then
        state.SelectedScrollGroupId = state.selectedHitObjects[1].TimingGroup
    end
    
    saveVariables()
    state.IsWindowHovered = imgui.IsWindowHovered()
    imgui.End()
end

function placeSVs()
    local noteTimes = getSelectedNoteTimes()
    if #noteTimes < 2 then return end
    
    local bizz = BIZZIES[vars.bizzIndex]
    local isAvzBizz = bizz == "avz"
    local firstNoteTime = noteTimes[1]
    local lastNoteTime = noteTimes[#noteTimes]
    local svsToRemove = getSVsBetweenTimes(firstNoteTime, lastNoteTime)
    local svsToAdd = {}
    local sbizz = SBIZZIES[vars.sbizzIndex]
    local isXTarz = sbizz == "x"
    local isStillBizz = sbizz ~= "no"
    local workingNoteTimes = isStillBizz and {firstNoteTime, lastNoteTime} or noteTimes
    for i = 1, #workingNoteTimes - 1 do
        local startTime = workingNoteTimes[i]
        local endTime = workingNoteTimes[i + 1]
        local totalDuration = endTime - startTime
        local totalDizz = isAvzBizz and totalDuration * vars.avz or vars.dizz
        local svDuration = totalDuration / vars.ptz
        for j = 1, vars.ptz do
            local svTime = startTime + (j - 1) * svDuration
            local startDizzDecimal = vars.dizziesCache[j]
            local endDizzDecimal = vars.dizziesCache[j + 1]
            local dizzTraveledDecimal = endDizzDecimal - startDizzDecimal
            local dizzTraveled = dizzTraveledDecimal * totalDizz
            local svMultiplier = dizzTraveled / svDuration
            table.insert(svsToAdd, sv(svTime, svMultiplier))
        end
    end
    
    if isStillBizz then
        table.insert(svsToAdd, sv(lastNoteTime, 1))
        
        local totalSVDisplacement = 0
        local svDisplacements = {}
        local j = 1
        for i = 1, #svsToAdd - 1 do
            local lastSV = svsToAdd[i]
            local nextSV = svsToAdd[i + 1]
            while nextSV.StartTime > noteTimes[j] do
                local svToNoteTime = noteTimes[j] - lastSV.StartTime
                local displacement = totalSVDisplacement
                if svToNoteTime > 0 then
                    displacement = displacement + lastSV.Multiplier * svToNoteTime
                end
                table.insert(svDisplacements, displacement)
                j = j + 1
            end
            local svTimeDifference = nextSV.StartTime - lastSV.StartTime
            totalSVDisplacement = totalSVDisplacement + svTimeDifference * lastSV.Multiplier
        end
        table.insert(svDisplacements, totalSVDisplacement)
        
        -- maybe make note spacing a dynamic function in the future
        -- like one distance function for svs/note motion, one distance function for note spacing
        local noteSpacing
        local xDisplacement
        if sbizz == "savz" then
            noteSpacing = vars.savz
        elseif sbizz == "sdizz" then
            noteSpacing = vars.sdizz / (lastNoteTime - firstNoteTime)
        elseif isXTarz then
            local tgName = state.SelectedScrollGroupId
            local tgNote = map.GetTimingGroupObjects(tgName)[1]
            if tgName ~= getXTGName(tgNote) then
                print("I!", "x timing group not selected")
                return
            end
            if tgNote.StartTime < lastNoteTime then
                print("I!", "gay")
                return
            end
            noteSpacing = 0
            xDisplacement = getXDisplacement(tgNote)
        end
        
        local nsvDisplacements = {}
        for i = 1, #noteTimes do
            nsvDisplacements[i] = (noteTimes[i] - firstNoteTime) * noteSpacing
        end
        
        local finalDisplacements = {}
        for i = 1, #svDisplacements do
            local finalDisplacement = nsvDisplacements[i] - svDisplacements[i]
            table.insert(finalDisplacements, finalDisplacement)
        end
        
        local tarzType = TARZIES[vars.tarzTypeIndex]
        local extraDisplacement = vars.tarz
        if tarzType == "auto" then
            local multiplier = getUsableDisplacementMultiplier(firstNoteTime)
            local duration = 1 / multiplier
            local multiplierBefore = getSVMultiplierAt(firstNoteTime - duration)
            extraDisplacement = multiplierBefore * duration
            if isXTarz and extraDisplacement == 0 then extraDisplacement = -xDisplacement end
        elseif tarzType == "otua" then
            local multiplier = getUsableDisplacementMultiplier(lastNoteTime)
            local duration = 1 / multiplier
            local multiplierAt = getSVMultiplierAt(lastNoteTime)
            extraDisplacement = -multiplierAt * duration
            if isXTarz and extraDisplacement == 0 then extraDisplacement = -xDisplacement end
        elseif isXTarz then
            extraDisplacement = extraDisplacement - xDisplacement
        end
        if tarzType == "end" or tarzType == "otua" then
            extraDisplacement = extraDisplacement - finalDisplacements[#finalDisplacements]
        end
        for i = 1, #finalDisplacements do
            finalDisplacements[i] = finalDisplacements[i] + extraDisplacement
        end
        if isXTarz then
            local tgName = state.SelectedScrollGroupId
            local tgNote = map.GetTimingGroupObjects(tgName)[1]
            if tgNote.StartTime == lastNoteTime then
                finalDisplacements[#finalDisplacements] = finalDisplacements[#finalDisplacements] + xDisplacement
            end
        end
        
        local actualFinalSVsToAdd = {}
        local svTimeIsAdded = {}
        j = 1
        for i = 1, #noteTimes do
            local noteTime = noteTimes[i]
            local multiplier = getUsableDisplacementMultiplier(noteTime)
            local duration = 1 / multiplier
            if i ~= 1 then
                local beforeDisplacement = finalDisplacements[i]
                local timeBefore = noteTime - duration
                svTimeIsAdded[timeBefore] = true
                while svsToAdd[j + 1].StartTime <= timeBefore do
                    j = j + 1
                end
                local currentSVMultiplier = svsToAdd[j].Multiplier
                local newSVMultiplier = multiplier * beforeDisplacement + currentSVMultiplier
                table.insert(actualFinalSVsToAdd, sv(timeBefore, newSVMultiplier))
            end
            if i ~= #noteTimes then
                local atDisplacement = -finalDisplacements[i]
                local timeAt = noteTime
                svTimeIsAdded[timeAt] = true
                while svsToAdd[j + 1].StartTime <= timeAt do
                    j = j + 1
                end
                local currentSVMultiplier = svsToAdd[j].Multiplier
                local newSVMultiplier = multiplier * atDisplacement + currentSVMultiplier
                table.insert(actualFinalSVsToAdd, sv(timeAt, newSVMultiplier))
                
                local timeAfter = noteTime + duration
                svTimeIsAdded[timeAfter] = true
                table.insert(actualFinalSVsToAdd, sv(timeAfter, currentSVMultiplier))
            end
        end
        for i = 1, #svsToAdd - 1 do
            local sv = svsToAdd[i]
            if svTimeIsAdded[sv.StartTime] == nil then
                table.insert(actualFinalSVsToAdd, sv)
            end
        end
        svsToAdd = actualFinalSVsToAdd
    end
    local svAtLastNoteTime = map.GetScrollVelocityAt(lastNoteTime)
    local isLastSVAddible = not (svAtLastNoteTime and svAtLastNoteTime.StartTime == lastNoteTime)
    local lastSVMultiplier = isXTarz and 0 or 1
    if isLastSVAddible then table.insert(svsToAdd, sv(lastNoteTime, lastSVMultiplier)) end
    actions.PerformBatch({
            utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
            utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd)
    })
end

function deleteSVs()
    local noteTimes = getSelectedNoteTimes()
    if #noteTimes < 2 then return end
    
    local firstNoteTime = noteTimes[1]
    local lastNoteTime = noteTimes[#noteTimes]
    local svsToRemove = getSVsBetweenTimes(firstNoteTime, lastNoteTime)
    if #svsToRemove == 0 then return end
    
    local svsToAdd = getSVMultiplierAt(firstNoteTime - 1) == 1 and {} or {sv(firstNoteTime, 1)}
    actions.PerformBatch({
            utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
            utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd)
    })
end

function setupXTG()
    local note = state.selectedHitObjects[1]
    if note.TimingGroup ~= "$Default" then
        state.SelectedScrollGroupId = note.TimingGroup
        return
    end
    
    local actionType = action_type.CreateTimingGroup
    local tgName = getXTGName(note)
    local multiplier = getUsableDisplacementMultiplier(note.StartTime)
    local duration = 1 / multiplier
    local svs = {sv(-5000, 0)}
    svs[2] = sv(note.StartTime - duration, multiplier * getXDisplacement(note))
    svs[3] = sv(note.StartTime, 1)
    local sg = utils.CreateScrollGroup(svs)
    local sgNotes = {note}
    actions.Perform(utils.createEditorAction(actionType, tgName, sg, sgNotes))
    state.SelectedScrollGroupId = note.TimingGroup
end

function getXTGName(note) return table.concat({note.StartTime, "|", note.Lane, "|x"}) end

-- for LNs, should actually calculate sv distance between note.StartTime and note.EndTime
-- to get correct value (note.EndTime - note.StartTime is bad/breaks if avg sv during LN > 1.00x).
function getXDisplacement(note)
    return note.EndTime == 0 and X_DISPLACEMENT or X_DISPLACEMENT - (note.EndTime - note.StartTime)
end

function getSelectedNoteTimes()
    local startTimes = {}
    local alreadyAddedTimes = {}
    for i, hitObject in pairs(state.SelectedHitObjects) do
        if not alreadyAddedTimes[hitObject.StartTime] then
            table.insert(startTimes, hitObject.StartTime)
            alreadyAddedTimes[hitObject.StartTime] = true
        end
    end
    table.sort(startTimes, function(a, b) return a < b end)
    return startTimes
end

function getSVsBetweenTimes(startTime, endTime)
    local svsBetweenTimes = {}
    for _, sv in pairs(map.ScrollVelocities) do
        if sv.StartTime >= startTime and sv.StartTime < endTime then
            table.insert(svsBetweenTimes, sv)
        end
    end
    table.sort(svsBetweenTimes, function(a, b) return a.StartTime < b.StartTime end)
    return svsBetweenTimes
end

function getSVMultiplierAt(time)
    local sv = map.GetScrollVelocityAt(time)
    return sv and sv.Multiplier or 1
end

function getUsableDisplacementMultiplier(time)
    return 2 ^ math.min(6, 23 - math.floor(math.log(math.abs(time) + 1) / math.log(2)))
end

function sv(time, multiplier) return utils.CreateScrollVelocity(time, multiplier) end

function flipEase(easeFunc) return function(x, a) return 1 - easeFunc(1 - x, a) end end

function inOutEase(easeInFunc, easeOutFunc)
    return function(x, a) 
        return x <= 0.5 and easeInFunc(2 * x, a) / 2 or (easeOutFunc(2 * x - 1, a) + 1) / 2 end
end

function outInEase(easeInFunc, easeOutFunc) return inOutEase(easeOutFunc, easeInFunc) end

function polynomialEaseIn(x, a) return math.pow(x, a + 1) end

function polynomialEaseOut(x, a) return flipEase(polynomialEaseIn)(x, a) end

function polynomialEaseInOut(x, a) return inOutEase(polynomialEaseIn, polynomialEaseOut)(x, a) end

function polynomialEaseOutIn(x, a) return outInEase(polynomialEaseIn, polynomialEaseOut)(x, a) end

function exponentialEaseIn(x, a) return a == 0 and x or (math.exp(a * x) - 1) / (math.exp(a) - 1) end

function exponentialEaseOut(x, a) return flipEase(exponentialEaseIn)(x, a) end

function exponentialEaseInOut(x, a) return inOutEase(exponentialEaseIn, exponentialEaseOut)(x, a) end

function exponentialEaseOutIn(x, a) return outInEase(exponentialEaseIn, exponentialEaseOut)(x, a) end

function inverseEaseIn(x, a) return (a == 0 and x == 0) and 0 or math.pow(x, 2) / (x * (1 - a) + a) end

function inverseEaseOut(x, a) return flipEase(inverseEaseIn)(x, a) end

function inverseEaseInOut(x, a) return inOutEase(inverseEaseIn, inverseEaseOut)(x, a) end

function inverseEaseOutIn(x, a) return outInEase(inverseEaseIn, inverseEaseOut)(x, a) end

function sineEaseIn(x, a) return (1 - math.cos(math.pi * math.pow(x, a + 1))) / 2 end

function sineEaseOut(x, a) return flipEase(sineEaseIn)(x, a) end

function sineEaseInOut(x, a) return inOutEase(sineEaseIn, sineEaseOut)(x, a) end

function sineEaseOutIn(x, a) return outInEase(sineEaseIn, sineEaseOut)(x, a) end

function circEaseIn(x, a) return a == 0 and x or 1 - math.sqrt(1 - math.pow(x, a)) end

function circEaseOut(x, a) return flipEase(circEaseIn)(x, a) end

function circEaseInOut(x, a) return inOutEase(circEaseIn, circEaseOut)(x, a) end

function circEaseOutIn(x, a) return outInEase(circEaseIn, circEaseOut)(x, a) end

function elasticEaseInFunction(b)
    return function(x, a)
        if a == 0 then return x * math.cos(math.pi * b * (1 - x)) end
        return math.pow(x, 2) * math.cos(math.pi * b * (1 - x)) / (x * (1 - a) + a) end
end

function elasticEaseIn(x, a, b) return elasticEaseInFunction(b)(x, a) end

function elasticEaseOut(x, a, b) return flipEase(elasticEaseInFunction(b))(x, a) end

function elasticEaseInOut(x, a, b)
    local easeInFunction = elasticEaseInFunction(b)
    local easeOutFunction = flipEase(elasticEaseInFunction(b))
    return inOutEase(easeInFunction, easeOutFunction)(x, a)
end

function elasticEaseOutIn(x, a, b)
    local easeInFunction = elasticEaseInFunction(b)
    local easeOutFunction = flipEase(elasticEaseInFunction(b))
    return outInEase(easeInFunction, easeOutFunction)(x, a)
end

-- easing function based on Maverick Reynolds' article:
-- https://medium.com/@mcreynolds02/a-new-family-of-easing-functions-391821670a60
function reynoldsEase(x, a, b)
    return (a == 0 or b == 0) and x or 1 / (1 + math.pow(a, 2) * math.pow((1 / x) - 1, b))
end

function simplifiedCubicBezier(p2, p3, t)
    return 3 * t * (1 - t)^2 * p2 + 3 * t^2 * (1 - t) * p3 + t^3
end

function cubicBezierEase(x, x1, y1, x2, y2)
    if x == 0 or x == 1 then return x end
    
    local timeGuess = 0.5
    for i = 1, 20 do
        local timeIncrement = 0.5 ^ (i + 1)
        local xPositionGuess = simplifiedCubicBezier(x1, x2, timeGuess)
        if xPositionGuess < x then
            timeGuess = timeGuess + timeIncrement
        elseif xPositionGuess > x then
            timeGuess = timeGuess - timeIncrement
        else
            return simplifiedCubicBezier(y1, y2, timeGuess)
        end
    end
    return simplifiedCubicBezier(y1, y2, timeGuess)
end

EAZ_FUNZIES = {
    "poly",
    "expo",
    "inv",
    "sin",
    "circ",
    "elaz",
    "rey",
    "bez",
}

EAZIES = {
    "ease in",
    "ease out",
    "ease in out",
    "ease out in",
}

local eaz_dict = { 
    ["poly ease in"] = polynomialEaseIn,
    ["poly ease out"] = polynomialEaseOut,
    ["poly ease in out"] = polynomialEaseInOut,
    ["poly ease out in"] = polynomialEaseOutIn,
    ["expo ease in"] = exponentialEaseIn,
    ["expo ease out"] = exponentialEaseOut,
    ["expo ease in out"] = exponentialEaseInOut,
    ["expo ease out in"] = exponentialEaseOutIn,
    ["inv ease in"] = inverseEaseIn,
    ["inv ease out"] = inverseEaseOut,
    ["inv ease in out"] = inverseEaseInOut,
    ["inv ease out in"] = inverseEaseOutIn,
    ["sin ease in"] = sineEaseIn,
    ["sin ease out"] = sineEaseOut,
    ["sin ease in out"] = sineEaseInOut,
    ["sin ease out in"] = sineEaseOutIn,
    ["circ ease in"] = circEaseIn,
    ["circ ease out"] = circEaseOut,
    ["circ ease in out"] = circEaseInOut,
    ["circ ease out in"] = circEaseOutIn,
    ["elaz ease in"] = elasticEaseIn,
    ["elaz ease out"] = elasticEaseOut,
    ["elaz ease in out"] = elasticEaseInOut,
    ["elaz ease out in"] = elasticEaseOutIn,
}

function updateDizziesCache()
    local eazFunzName = EAZ_FUNZIES[vars.eazFunzIndex]
    local eazName = EAZIES[vars.eazIndex]
    local eazFunzKey = table.concat({eazFunzName, " ", eazName})
    local eazFunz = eaz_dict[eazFunzKey] or function (x, a) return x end
    local isReyEaz = eazFunzName == "rey"
    if isReyEaz then eazFunz = reynoldsEase end
    local isBezEaz = eazFunzName == "bez"
    if isBezEaz then eazFunz = cubicBezierEase end
    local isTwoParameters = isReyEaz or eazFunzName == "elaz"
    local isZeroEnd = ONE_ZEROES[vars.oneZeroIndex] == "zero"
    
    local fizz = vars.fizz
    local fizzed = vars.fizz + 1
    vars.plotMinScale = 0
    vars.plotMaxScale = 0
    vars.dizziesCache = {}
    for i = 0, vars.ptz do
        local x = i / vars.ptz
        local funzRez
        if isBezEaz then
            funzRez = eazFunz(x, vars.x1, vars.y1, vars.x2, vars.y2)
        elseif isTwoParameters then
            funzRez = eazFunz(x, vars.rizz, vars.gizz) 
        else
            funzRez = eazFunz(x, vars.rizz)
        end
        local dizz = isZeroEnd and fizzed * funzRez - fizz * math.pow(x, 3) - x or fizzed * funzRez - fizz * x
        vars.plotMinScale = math.min(vars.plotMinScale, dizz)
        vars.plotMaxScale = math.max(vars.plotMaxScale, dizz)
        table.insert(vars.dizziesCache, dizz)
    end
    if isZeroEnd then
        local absMax = math.max(math.abs(vars.plotMinScale), math.abs(vars.plotMaxScale))
        if absMax == 0 then return end
        
        local scalingFactor = 1 / absMax
        vars.plotMinScale = vars.plotMinScale / absMax
        vars.plotMaxScale = vars.plotMaxScale / absMax
        
        for i = 0, vars.ptz do
            vars.dizziesCache[i + 1] = vars.dizziesCache[i + 1] / absMax
        end
    end
end

function chooseTarz()
    local tarz = TARZIES[vars.tarzTypeIndex]
    if tarz == "auto" or tarz == "otua" then
        imgui.Indent(BEEG_HAF)
        vars.tarzTypeIndex = combo("tarz", TARZIES, vars.tarzTypeIndex)
        imgui.Unindent(BEEG_HAF)
    else
        _, vars.tarz = imgui.InputFloat("##tarz", vars.tarz, 0, 0, "%.1f msx")
        imgui.SameLine()
        vars.tarzTypeIndex = combo("tarz", TARZIES, vars.tarzTypeIndex)
    end
end

function combo(label, list, listIndex)
    local imguiFlag = imgui_combo_flags.HeightLarge
    if not imgui.BeginCombo(label, list[listIndex], imguiFlag) then return listIndex end
    
    local newListIndex = listIndex
    for i = 1, #list do
        if imgui.Selectable(list[i]) then newListIndex = i end
    end
    imgui.EndCombo()
    return newListIndex
end

function clamp(x, min, max) return x < min and min or (x > max and max or x) end

function setPluginAppearance()
    imgui.PushStyleColor(imgui_col.WindowBg, {0.00, 0.00, 0.15, 0.90})
    imgui.PushStyleColor(imgui_col.Border, {0.40, 1.00, 0.60, 1.00})
    imgui.PushStyleColor(imgui_col.TitleBg, {0.00, 0.00, 0.15, 0.90})
    imgui.PushStyleColor(imgui_col.TitleBgActive, {0.00, 0.00, 0.15, 0.90})
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, {0.00, 0.00, 0.15, 0.90})
    imgui.PushStyleColor(imgui_col.FrameBg, {0.50, 0.30, 0.10, 0.60})
    imgui.PushStyleColor(imgui_col.FrameBgHovered, {0.60, 0.40, 0.10, 0.60})
    imgui.PushStyleColor(imgui_col.FrameBgActive, {0.70, 0.50, 0.10, 0.60})
    imgui.PushStyleColor(imgui_col.Button, {0.00, 0.30, 0.35, 0.80})
    imgui.PushStyleColor(imgui_col.ButtonHovered, {0.00, 0.40, 0.45, 0.80})
    imgui.PushStyleColor(imgui_col.ButtonActive, {0.00, 0.50, 0.55, 0.80})
    imgui.PushStyleColor(imgui_col.Text, {0.40, 1.00, 0.60, 1.00})
    imgui.PushStyleColor(imgui_col.TextSelectedBg, {0.60, 0.60, 0.60, 0.50})
    imgui.PushStyleVar(imgui_style_var.ItemSpacing, {6, 4})
    imgui.PushStyleVar(imgui_style_var.WindowPadding, {10, 8})
    imgui.PushStyleVar(imgui_style_var.FramePadding, {6, 5})
    local rounding = 8
    imgui.PushStyleVar(imgui_style_var.GrabRounding, rounding)
    imgui.PushStyleVar(imgui_style_var.WindowRounding, rounding)
    imgui.PushStyleVar(imgui_style_var.FrameRounding, rounding)
    imgui.PushItemWidth(ITEM_WIDTH)
end

function initializePluginWindowNotCollapsed()
    if state.GetValue("pluginOpen") then return end
    imgui.SetNextWindowCollapsed(false)
    state.SetValue("pluginOpen", true)
end

function isAnyVariableChanged()
    for key, currentValue in pairs(vars) do
        if state.GetValue(key) ~= currentValue then return true end
    end
    return false
end

function saveVariables()
    for key, value in pairs(vars) do
        state.SetValue(key, value)
    end
end