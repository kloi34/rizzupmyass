--[[
eaz -> ease
funz -> function
rizz -> ???
fizz -> ???
ptz -> points
bizz -> business
avz -> average (SV)
dizz -> distance
savz -> still average (SV)
sdizz -> still distance
tarz -> target
--]]
GAY = false
ITEM_WIDTH = 140
X_DISPLACEMENT = -200
BIZZIES = {
    "avz",
    "avz + savz",
    "avz + sdizz",
    "dizz",
    "dizz + savz",
    "dizz + sdizz",
}
TARZIES = {
    "no",
    "start",
    "end",
    "auto",
    "otua",
    "xart",
    "xend",
}
local vars = {
    eazFunzIndex = 1,
    eazIndex = 1,
    rizz = 1,
    fizz = 0,
    ptz = 16,
    bizzIndex = 1,
    savz = 1,
    avz = 1,
    sdizz = 69,
    dizz = 69,
    tarzTypeIndex = 1,
    tarz = 69,
    plotMinScale = 0,
    plotMaxScale = 1,
    dizziesCache = {},
}

function draw()
    initializePluginWindowNotCollapsed()
    imgui.Begin("rizzupmyass", imgui_window_flags.AlwaysAutoResize)
    setPluginAppearance()
    loadVariables()
    
    vars.eazFunzIndex = combo("funz", EAZ_FUNZIES, vars.eazFunzIndex)
    vars.eazIndex = combo("eaz", EAZIES, vars.eazIndex)
    
    _, vars.rizz = imgui.DragFloat("rizz", vars.rizz, 0.01, 0, 999, "%.2f")
    vars.rizz = clamp(vars.rizz, 0, 999)
    
    _, vars.fizz = imgui.DragFloat("fizz", vars.fizz, 0.01, -1, 999, "%.2f")
    vars.fizz = clamp(vars.fizz, -1, 999)
    
    _, vars.ptz = imgui.InputInt("ptz", vars.ptz, 1, 1)
    vars.ptz = clamp(vars.ptz, 1, 999)
    
    if GAY and isAnyVariableChanged() then print("S!", "Gay") end -- gay
    if isAnyVariableChanged() or #vars.dizziesCache == 0 then updateDizziesCache() end
    
    imgui.PlotLines("gayz ", vars.dizziesCache, #vars.dizziesCache, 0, state.SelectedScrollGroupId,
            vars.plotMinScale, vars.plotMaxScale, {ITEM_WIDTH, 100})
    
    vars.bizzIndex = combo("bizz", BIZZIES, vars.bizzIndex)
    local bizz = BIZZIES[vars.bizzIndex]
    if bizz == "avz" then
        chooseAvz()
    elseif bizz == "avz + savz" then
        chooseAvz()
        chooseSavz()
        chooseTarz()
    elseif bizz == "avz + sdizz" then
        chooseAvz()
        chooseSdizz()
        chooseTarz()
    elseif bizz == "dizz" then
        chooseDizz()
    elseif bizz == "dizz + savz" then
        chooseDizz()
        chooseSavz()
        chooseTarz()
    elseif bizz == "dizz + sdizz" then
        chooseDizz()
        chooseSdizz()
        chooseTarz()
    end
    
    local buttonSize = {imgui.GetContentRegionAvailWidth(), 50}
    if imgui.Button("rizzupass", buttonSize) or utils.IsKeyPressed(keys.T) then placeSVs() end
    
    if utils.IsKeyPressed(keys.N) then deleteSVs() end
    
    local isBKeyPressed = utils.IsKeyPressed(keys.B)
    local isAltKeyDown = utils.IsKeyDown(keys.LeftAlt) or utils.IsKeyDown(keys.RightAlt)
    if isBKeyPressed and #state.SelectedHitObjects == 1 and isAltKeyDown then setupNoteTG() end
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
    local isAvzBizz = bizz == "avz" or bizz == "avz + savz" or bizz == "avz + sdizz" or bizz == "xavz"
    local isSavzBizz = bizz == "avz + savz" or bizz == "dizz + savz"
    local isSdizzBizz = bizz == "avz + sdizz" or bizz == "dizz + sdizz"
    local isStillBizz = isSavzBizz or isSdizzBizz
    local firstNoteTime = noteTimes[1]
    local lastNoteTime = noteTimes[#noteTimes]
    local svsToRemove = getSVsBetweenTimes(firstNoteTime, lastNoteTime)
    local svsToAdd = {}
    
    local workingNoteTimes = noteTimes
    if isStillBizz then workingNoteTimes = {firstNoteTime, lastNoteTime} end
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
            local svTimeDifference = nextSV.StartTime - lastSV.StartTime
            while nextSV.StartTime > noteTimes[j] do
                local svToNoteTime = noteTimes[j] - lastSV.StartTime
                local displacement = totalSVDisplacement
                if svToNoteTime > 0 then
                    displacement = displacement + lastSV.Multiplier * svToNoteTime
                end
                table.insert(svDisplacements, displacement)
                j = j + 1
            end
            if svTimeDifference > 0 then
                totalSVDisplacement = totalSVDisplacement + svTimeDifference * lastSV.Multiplier
            end
        end
        table.insert(svDisplacements, totalSVDisplacement)
        
        local tarzType = TARZIES[vars.tarzTypeIndex]
        local isXTarz = tarzType == "xart" or tarzType == "xend"
        -- maybe make note spacing a dynamic function in the future
        -- like one distance function for svs/note motion, one distance function for note spacing
        local noteSpacing = isSavzBizz and vars.savz or vars.sdizz / (lastNoteTime - firstNoteTime)
        if isXTarz then
            local tgName = state.SelectedScrollGroupId
            local tgNote = map.GetTimingGroupObjects(tgName)[1]
            if tgNote.StartTime > lastNoteTime then
                print("I!", "gay")
                return
            end
            noteSpacing = 0
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
        
        local extraDisplacement = vars.tarz
        if tarzType == "auto" then
            local multiplier = getUsableDisplacementMultiplier(firstNoteTime)
            local duration = 1 / multiplier
            local multiplierBefore = getSVMultiplierAt(firstNoteTime - duration)
            extraDisplacement = multiplierBefore * duration
        elseif tarzType == "otua" then
            local multiplier = getUsableDisplacementMultiplier(lastNoteTime)
            local duration = 1 / multiplier
            local multiplierAt = getSVMultiplierAt(lastNoteTime)
            extraDisplacement = -multiplierAt * duration
        end
        if tarzType == "end" or tarzType == "otua" or tarzType == "xend" then
            extraDisplacement = extraDisplacement - finalDisplacements[#finalDisplacements]
        end
        if tarzType ~= "no" then
            for i = 1, #finalDisplacements do
                finalDisplacements[i] = finalDisplacements[i] + extraDisplacement
            end
        end
        if isXTarz then
            finalDisplacements[#finalDisplacements] = finalDisplacements[#finalDisplacements] + X_DISPLACEMENT
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
    if isLastSVAddible then table.insert(svsToAdd, sv(lastNoteTime, 1)) end
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

function setupNoteTG()
    local note = state.selectedHitObjects[1]
    if note.TimingGroup ~= "$Default" then
        state.SelectedScrollGroupId = state.selectedHitObjects[1].TimingGroup
        return
    end
    
    local actionType = action_type.CreateTimingGroup
    local tgName = table.concat({note.StartTime, "|", note.Lane})
    local svs = {sv(-2000, 0)}
    local multiplier = getUsableDisplacementMultiplier(note.StartTime)
    local duration = 1 / multiplier
    table.insert(svs, sv(note.StartTime - duration, multiplier * X_DISPLACEMENT))
    table.insert(svs, sv(note.StartTime, multiplier * -X_DISPLACEMENT))
    table.insert(svs, sv(note.StartTime + duration, 1))
    
    local sg = utils.CreateScrollGroup(svs)
    local sgNotes = {note}
    local action = utils.createEditorAction(actionType, tgName, sg, sgNotes)
    actions.Perform(action)
    state.SelectedScrollGroupId = state.selectedHitObjects[1].TimingGroup
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
    if sv then return sv.Multiplier end
    return 1
end

--[[
-- current implementation:
-- 64 until 2^18 = 262144 ms ~4.3 min, then —> 32
-- 32 until 2^19 = 524288 ms ~8.7 min, then —> 16
-- 16 until 2^20 = 1048576 ms ~17.4 min, then —> 8
-- 8 until 2^21 = 2097152 ms ~34.9 min, then —> 4
-- 4 until 2^22 = 4194304 ms ~69.9 min, then —> 2
-- 2 until 2^23 = 8388608 ms ~139.8 min, then —> 1
--]]
function getUsableDisplacementMultiplier(time)
    local exponent = 23 - math.floor(math.log(math.abs(time) + 1) / math.log(2))
    if exponent > 6 then exponent = 6 end
    return 2 ^ exponent
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

EAZ_FUNZIES = {
    "poly",
    "expo",
    "inv",
    "sin",
}

EAZIES = {
    "ease in",
    "ease out",
    "ease in out",
    "ease out in",
}

function updateDizziesCache()
    local eazDictionary = {}
    eazDictionary["poly ease in"] = polynomialEaseIn
    eazDictionary["poly ease out"] = polynomialEaseOut
    eazDictionary["poly ease in out"] = polynomialEaseInOut
    eazDictionary["poly ease out in"] = polynomialEaseOutIn
    eazDictionary["expo ease in"] = exponentialEaseIn
    eazDictionary["expo ease out"] = exponentialEaseOut
    eazDictionary["expo ease in out"] = exponentialEaseInOut
    eazDictionary["expo ease out in"] = exponentialEaseOutIn
    eazDictionary["inv ease in"] = inverseEaseIn
    eazDictionary["inv ease out"] = inverseEaseOut
    eazDictionary["inv ease in out"] = inverseEaseInOut
    eazDictionary["inv ease out in"] = inverseEaseOutIn
    eazDictionary["sin ease in"] = sineEaseIn
    eazDictionary["sin ease out"] = sineEaseOut
    eazDictionary["sin ease in out"] = sineEaseInOut
    eazDictionary["sin ease out in"] = sineEaseOutIn
    local eazName = EAZIES[vars.eazIndex]
    local eazFunzName = EAZ_FUNZIES[vars.eazFunzIndex]
    local eazFunzKey = table.concat({eazFunzName, " ", eazName})
    local eazFunz = eazDictionary[eazFunzKey] or function (x, a) return x end
    local fizz = vars.fizz
    local fizzed = vars.fizz + 1
    vars.plotMinScale = 0
    vars.plotMaxScale = 1
    vars.dizziesCache = {}
    for i = 0, vars.ptz do
        local x = i / vars.ptz
        local dizz = fizzed * eazFunz(x, vars.rizz) - fizz * x
        vars.plotMinScale = math.min(vars.plotMinScale, dizz)
        vars.plotMaxScale = math.max(vars.plotMaxScale, dizz)
        table.insert(vars.dizziesCache, dizz)
    end
end

function chooseTarz()
    local tarz = TARZIES[vars.tarzTypeIndex]
    local hasNoTarzValue = tarz == "no" or tarz == "auto" or tarz == "otua"
    local indentWidth = 0.45 * ITEM_WIDTH + 14
    if hasNoTarzValue then
        imgui.Indent(indentWidth)
    else
        imgui.PushItemWidth(ITEM_WIDTH * 0.55 - 6)
        _, vars.tarz = imgui.InputFloat("##tarz", vars.tarz, 0, 0, "%.1f msx")
        imgui.SameLine()
        imgui.PopItemWidth()
    end
    imgui.PushItemWidth(ITEM_WIDTH * 0.45)
    vars.tarzTypeIndex = combo("tarz", TARZIES, vars.tarzTypeIndex)
    if hasNoTarzValue then imgui.Unindent(indentWidth) end
    imgui.PopItemWidth()
end

function chooseSavz()
    _, vars.savz = imgui.InputFloat("savz", vars.savz, 0, 0, "%.2fx")
end

function chooseAvz()
    _, vars.avz = imgui.InputFloat("avz", vars.avz, 0, 0, "%.2fx")
end

function chooseSdizz()
    _, vars.sdizz = imgui.InputFloat("sdizz", vars.sdizz, 0, 0, "%.1f msx")
end

function chooseDizz()
    _, vars.dizz = imgui.InputFloat("dizz", vars.dizz, 0, 0, "%.1f msx")
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

function clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

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

function loadVariables()
    for key, value in pairs(vars) do
        vars[key] = state.GetValue(key) or value
    end
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