--[[
Death Knight Blood Shield Weak Aura
	These Functions are to build a custom weak aura for World of Warcraft
	to track the status of a Blood Shield and show it as a bar that 
	decreases as the shield's total absorb is reduced by incoming damage
--]]

--Trigger Function
function()
    return true
end

--Untrigger Function
function()
    local a = UnitBuff("player", "Blood Shield")
    shield_max = nil
    return a == nil
end

--[[
Duration Function
	This function isn't really to get the duration of the shield, 
	it's a function to get the amount of absorb the shield currently 
	have and show it as bar that starts full and is emptied as 
	the shield's total absorb decreases. In the case the shield 
	is reapplied, the bar go back to full and start decreasing 
	again when damage is taken
--]]
function()
    --get Blood shield current absorb value
    local value = select(15, UnitBuff("player", "Blood Shield"))
    if value == nil then
        shield_max = nil
        return 0, 0, true
    end
    --updating bar limits
    if shield_max == nil and value ~= 0  then
        shield_max = value/1000  
    elseif  value/1000 > shield_max then
        shield_max = value/1000
    end
    
    --return value/1000, (UnitHealthMax("player"))/1000, true
    return value/1000, shield_max , true
end

--[[
Name Function
	This function is used to show the shield's total absorb as 
	a numeric value. This function will work if it's chosen to 
	show the the name (%n in left or right text field in the weak aura 
	main configuration) instead of another information
--]]
function()
    local value = select(15, UnitBuff("player", "Blood Shield"))
    if value == nil then
        return 0
    end
    return value
    --return format("%dk",value/1000) -- in case you want "21k" instead of "21000"
end
