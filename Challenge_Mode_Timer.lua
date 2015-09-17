--[[
Custom Challenge Mode Timer -- Credits to Maebybaby@Draenor-EU
Code to create a weakaura to display Challenge Mode Dungeons objectives 
and a timer, highlighting the time that each objective was completed.
--]]

function progress()
    local dungeon, _, steps = C_Scenario.GetStepInfo()
    local objective = {}
    
    if wa_cm_inprogress == true then
        for i=1, steps do
            local _, _, status, progress = C_Scenario.GetCriteriaInfo(i)
            if status and wa_cm_completion[i] == "" then
                wa_cm_completion[i] = ("- |c%s%s|r"):format("000ff000", wa_cm_time_current)
            end
            wa_cm_obj_progress[i] = progress
            objective[i] = ("%s - %d/%d %s"):format(wa_cm_obj_name[i], wa_cm_obj_progress[i], wa_cm_obj_value[i], wa_cm_completion[i])
        end
    else
        for i=1, getn(wa_cm_obj_name) do
            objective[i] = ("%s - %d/%d %s"):format(wa_cm_obj_name[i], wa_cm_obj_progress[i], wa_cm_obj_value[i], wa_cm_completion[i])
        end
    end
    
    return table.concat(objective, "\n")
    
end

function timer_text()
    if wa_cm_inprogress == true then
        local _, timeCM = GetWorldElapsedTime(1)
        timeMin = math.floor(timeCM / 60)
        timeSec = math.floor(timeCM - (timeMin*60))
        if timeMin < 10 then
            timeMin = ("0%d"):format(timeMin)
        end
        if timeSec < 10 then
            timeSec = ("0%d"):format(timeSec)
        end
        wa_cm_time_current = ("%s:%s"):format(timeMin, timeSec)
    end
    return wa_cm_time_current or "00:00"
end

function trigger(event, ...)
    
    -- cm timer start/stop
    if event == "WORLD_STATE_TIMER_START" then
        wa_cm_inprogress = true
    elseif event == "WORLD_STATE_TIMER_STOP" then
        wa_cm_inprogress = false
        
        -- pre timer(5 sec countdown)
    elseif event == "START_TIMER" then
        local dungeon, _, steps = C_Scenario.GetStepInfo()
        wa_cm_inprogress = true
        for i=1, steps do
            local name, _, status, _, value = C_Scenario.GetCriteriaInfo(i)
            wa_cm_obj_progress[i] = 0
            wa_cm_obj_name[i] = name
            wa_cm_obj_value[i] = value
            wa_cm_completion[i] = ""
        end
        
        -- on completed challenge mode
    elseif event == "CHALLENGE_MODE_COMPLETED" then
        for i=1, getn(wa_cm_obj_name) do
            if wa_cm_completion[i] == "" then
                wa_cm_obj_progress[i] = wa_cm_obj_value[i]
                wa_cm_completion[i] = ("- |c%s%s|r"):format("000ff000", wa_cm_time_current)
            end
            
        end
        wa_cm_inprogress = false
        
        -- on enter instance or login, get objectives
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_LOGIN" then
        local _, _, _, difficultyName = GetInstanceInfo()
        if difficultyName == "Challenge Mode" then
            -- hide blizzard challenge mode frame
            ObjectiveTrackerFrame:SetScript("OnEvent", nil)
            ObjectiveTrackerFrame:Hide()
            
            wa_cm_obj_progress = {}
            wa_cm_obj_name = {}
            wa_cm_obj_value = {}
            wa_cm_completion = {}
            local dungeon, _, steps = C_Scenario.GetStepInfo()
            if steps == 0 then
                wa_cm_inprogress = false
            else
                wa_cm_inprogress = true
                wa_cm_objective = true
                -- get objectives
                for i=1, steps do
                    local name, _, status, _, value = C_Scenario.GetCriteriaInfo(i)
                    wa_cm_obj_progress[i] = 1
                    wa_cm_obj_name[i] = name
                    wa_cm_obj_value[i] = value
                    if status ~= true then
                        wa_cm_completion[i] = ""
                    end
                end
            end
        end
    end
end
