--[[
eaz -> ease
funz -> function
rizz -> ???
fizz -> ???
ptz -> points
dizz -> distance
--]]
GAY = false
ITEM_WIDTH = 140
local vars = {
    easingFunctionIndex = 1,
    easingsIndex = 1,
    rizz = 1,
    fizz = 1,
    ptz = 16,
    dizz = 69,
    plotMinScale = 0,
    plotMaxScale = 1,
    dizzesCache = {},
}

function draw()
    initializePluginWindowNotCollapsed()
    imgui.Begin("rizzupmyass", imgui_window_flags.AlwaysAutoResize)
    setPluginAppearance()
    loadVariables()
    
    vars.easingFunctionIndex = combo("funz", EASING_FUNCTION_NAMES, vars.easingFunctionIndex)
    vars.easingsIndex = combo("eaz", EASINGS, vars.easingsIndex)
    
    _, vars.rizz = imgui.SliderFloat("rizz", vars.rizz, 0, 10, "%.2f")
    vars.rizz = clamp(vars.rizz, 0, 999)
    
    -- note you can ctrl + click to input between 0 and 1, but 0 gives nothing
    _, vars.fizz = imgui.SliderFloat("fizz", vars.fizz, 1, 10, "%.2f")
    vars.fizz = clamp(vars.fizz, 0, 999)
    
    _, vars.ptz = imgui.InputInt("ptz", vars.ptz, 1, 1)
    vars.ptz = clamp(vars.ptz, 1, 999)
    
    if GAY and isAnyVariableChanged() then print("S!", "Gay") end -- gay
    if isAnyVariableChanged() or #vars.dizzesCache == 0 then updateDizzesCache() end
    
    imgui.PlotLines("gayz", vars.dizzesCache, #vars.dizzesCache, 0, "", vars.plotMinScale,
            vars.plotMaxScale, {ITEM_WIDTH, 100})
    
    _, vars.dizz = imgui.InputFloat("dizz", vars.dizz, 0, 0, "%.1f msx")
    
    if imgui.Button("rizzupass", {imgui.GetContentRegionAvailWidth(), 50}) then placeSVs() end
    
    saveVariables()
    state.IsWindowHovered = imgui.IsWindowHovered()
    imgui.End()
end

function placeSVs()
    local noteTimes = getSelectedNoteTimes()
    if #noteTimes < 2 then return end
    
    local firstNoteTime = noteTimes[1]
    local lastNoteTime = noteTimes[#noteTimes]
    local svsToRemove = getSVsBetweenTimes(firstNoteTime, lastNoteTime)
    local svsToAdd = {}
    for i = 1, #noteTimes - 1 do
        local startTime = noteTimes[i]
        local endTime = noteTimes[i + 1]
        local totalDuration = endTime - startTime
        local totalDizz = vars.dizz -- use totalDuration if straight
        local svDuration = totalDuration / vars.ptz
        for j = 1, vars.ptz do
            local svTime = startTime + (j - 1) * svDuration
            local startDizzDecimal = vars.dizzesCache[j]
            local endDizzDecimal = vars.dizzesCache[j + 1]
            local dizzTraveledDecimal = endDizzDecimal - startDizzDecimal
            local dizzTraveled = dizzTraveledDecimal * totalDizz
            local svMultiplier = dizzTraveled / svDuration
            table.insert(svsToAdd, sv(svTime, svMultiplier))
        end
    end
    local svAtLastNoteTime = map.GetScrollVelocityAt(lastNoteTime)
    local isLastSVAddible = not (svAtLastNoteTime and svAtLastNoteTime.StartTime == lastNoteTime)
    if isLastSVAddible then table.insert(svsToAdd, sv(lastNoteTime, 1)) end
    actions.PerformBatch({
            utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
            utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd)
    })
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

EASING_FUNCTION_NAMES = {
    "poly",
    "expo",
    "inv",
    "sin",
}

EASINGS = {
    "ease in",
    "ease out",
    "ease in out",
    "ease out in",
}

function updateDizzesCache()
    local easingFunctions = {}
    easingFunctions["poly ease in"] = polynomialEaseIn
    easingFunctions["poly ease out"] = polynomialEaseOut
    easingFunctions["poly ease in out"] = polynomialEaseInOut
    easingFunctions["poly ease out in"] = polynomialEaseOutIn
    easingFunctions["expo ease in"] = exponentialEaseIn
    easingFunctions["expo ease out"] = exponentialEaseOut
    easingFunctions["expo ease in out"] = exponentialEaseInOut
    easingFunctions["expo ease out in"] = exponentialEaseOutIn
    easingFunctions["inv ease in"] = inverseEaseIn
    easingFunctions["inv ease out"] = inverseEaseOut
    easingFunctions["inv ease in out"] = inverseEaseInOut
    easingFunctions["inv ease out in"] = inverseEaseOutIn
    easingFunctions["sin ease in"] = sineEaseIn
    easingFunctions["sin ease out"] = sineEaseOut
    easingFunctions["sin ease in out"] = sineEaseInOut
    easingFunctions["sin ease out in"] = sineEaseOutIn
    local easingName = EASINGS[vars.easingsIndex]
    local easingFunctionName = EASING_FUNCTION_NAMES[vars.easingFunctionIndex]
    local easingFunctionKey = table.concat({easingFunctionName, " ", easingName})
    local easingFunction = easingFunctions[easingFunctionKey] or function (x, a) return x end
    local rootFizz = math.sqrt(vars.fizz)
    local rootFizzless = rootFizz - 1
    vars.plotMinScale = 0
    vars.plotMaxScale = 1
    vars.dizzesCache = {}
    for i = 0, vars.ptz do
        local x = i / vars.ptz
        local dizz = rootFizz * easingFunction(x, vars.rizz) - rootFizzless * x
        vars.plotMinScale = math.min(vars.plotMinScale, dizz)
        vars.plotMaxScale = math.max(vars.plotMaxScale, dizz)
        table.insert(vars.dizzesCache, dizz)
    end
end

function initializePluginWindowNotCollapsed()
    if not state.GetValue("pluginOpen") then
        imgui.SetNextWindowCollapsed(false)
        state.SetValue("pluginOpen", true)
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
    imgui.PushStyleColor(imgui_col.SliderGrab, {0.00, 0.00, 0.15, 0.90})
    imgui.PushStyleColor(imgui_col.SliderGrabActive, {0.00, 0.00, 0.15, 0.90})
    imgui.PushStyleColor(imgui_col.Text, {0.40, 1.00, 0.60, 1.00})
    imgui.PushStyleColor(imgui_col.TextSelectedBg, {0.60, 0.60, 0.60, 0.50})
    imgui.PushStyleVar(imgui_style_var.ItemSpacing, {6, 4})
    imgui.PushStyleVar(imgui_style_var.WindowPadding, {10, 8})
    imgui.PushStyleVar(imgui_style_var.FramePadding, {8, 5})
    local rounding = 8
    imgui.PushStyleVar(imgui_style_var.GrabRounding, rounding)
    imgui.PushStyleVar(imgui_style_var.WindowRounding, rounding)
    imgui.PushStyleVar(imgui_style_var.FrameRounding, rounding)
    imgui.PushItemWidth(ITEM_WIDTH)
end

function loadVariables()
    for key, value in pairs(vars) do
        vars[key] = state.GetValue(key) or value
    end
end

function isAnyVariableChanged()
    for key, currentValue in pairs(vars) do
        local oldValue = state.GetValue(key)
        if oldValue ~= currentValue then return true end
    end
    return false
end

function saveVariables()
    for key, value in pairs(vars) do
        state.SetValue(key, value)
    end
end