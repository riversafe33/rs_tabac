function FPrompt(text, button, hold)
    Citizen.CreateThread(function()
        proppromptdisplayed = false
        PropPrompt = nil
        local str = Config.Prompts.Drop
        local buttonhash = Config.Prompts.DropKey
        local holdbutton = hold or false
        PropPrompt = PromptRegisterBegin()
        PromptSetControlAction(PropPrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PropPrompt, str)
        PromptSetEnabled(PropPrompt, false)
        PromptSetVisible(PropPrompt, false)
        PromptSetHoldMode(PropPrompt, holdbutton)
        PromptRegisterEnd(PropPrompt)
    end)
end

function LMPrompt(text, button, hold)
    Citizen.CreateThread(function()
        UsePrompt = nil
        local str = Config.Prompts.Smoke
        local buttonhash = Config.Prompts.SmokeKey
        local holdbutton = hold or false
        UsePrompt = PromptRegisterBegin()
        PromptSetControlAction(UsePrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(UsePrompt, str)
        PromptSetEnabled(UsePrompt, false)
        PromptSetVisible(UsePrompt, false)
        PromptSetHoldMode(UsePrompt, holdbutton)
        PromptRegisterEnd(UsePrompt)
    end)
end

function EPrompt(text, button, hold)
    Citizen.CreateThread(function()
        ChangeStance = nil
        local str = Config.Prompts.Change
        local buttonhash = Config.Prompts.ChangeKey
        local holdbutton = hold or false
        ChangeStance = PromptRegisterBegin()
        PromptSetControlAction(ChangeStance, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ChangeStance, str)
        PromptSetEnabled(ChangeStance, false)
        PromptSetVisible(ChangeStance, false)
        PromptSetHoldMode(ChangeStance, holdbutton)
        PromptRegisterEnd(ChangeStance)
    end)
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout > 0) do
            timeout = timeout - 1
            if timeout == 0 then
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end

function StopAnim(dict, body)
    Citizen.CreateThread(function()
        StopAnimTask(PlayerPedId(), dict, body, 1.0)
    end)
end

--Cigarette
RegisterNetEvent('rs_tabac:cigaret')
AddEventHandler('rs_tabac:cigaret', function()
    FPrompt(Config.Drop, Config.Prompts.DropKey, false)
    LMPrompt(Config.Smoke, Config.Prompts.SmokeKey, false)
    EPrompt(Config.Change, Config.Prompts.ChangeKey, false)
    ExecuteCommand('close')
    local ped = PlayerPedId()
    local male = IsPedMale(ped)
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local cigaret = CreateObject(GetHashKey('P_CIGARETTE01X'), x, y, z + 0.2, true, true, true)
    local righthand = GetEntityBoneIndexByName(ped, "SKEL_R_Finger13")
    local mouth = GetEntityBoneIndexByName(ped, "skel_head")
    if male then
        AttachEntityToEntity(cigaret, ped, mouth, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Anim(ped, "amb_rest@world_human_smoking@male_c@stand_enter", "enter_back_rf", 5400, 0)
        Wait(1000)
        AttachEntityToEntity(cigaret, ped, righthand, 0.03, -0.01, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1,
            true)
        Wait(1000)
        AttachEntityToEntity(cigaret, ped, mouth, -0.017, 0.1, -0.01, 0.0, 90.0, -90.0, true, true, false, true, 1,
            true)
        Wait(3000)
        AttachEntityToEntity(cigaret, ped, righthand, 0.017, -0.01, -0.01, 0.0, 120.0, 10.0, true, true, false, true, 1,
            true)
        Wait(1000)
        Anim(ped, "amb_rest@world_human_smoking@male_c@base", "base", -1, 30)
        RemoveAnimDict("amb_rest@world_human_smoking@male_c@stand_enter")
        Wait(1000)
    else --female
        AttachEntityToEntity(cigaret, ped, mouth, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Anim(ped, "amb_rest@world_human_smoking@female_c@base", "base", -1, 30)
        Wait(1000)
        AttachEntityToEntity(cigaret, ped, righthand, 0.01, 0.0, 0.01, 0.0, -160.0, -130.0, true, true, false, true, 1,
            true)
        Wait(2500)
    end

    local stance = "c"

    if proppromptdisplayed == false then
        PromptSetEnabled(PropPrompt, true)
        PromptSetVisible(PropPrompt, true)
        PromptSetEnabled(UsePrompt, true)
        PromptSetVisible(UsePrompt, true)
        PromptSetEnabled(ChangeStance, true)
        PromptSetVisible(ChangeStance, true)
        proppromptdisplayed = true
    end

    if male then
        while IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@male_c@base", "base", 3)
            or IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@base", "base", 3)
            or IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@male_d@base", "base", 3)
            or IsEntityPlayingAnim(ped, "amb_wander@code_human_smoking_wander@male_a@base", "base", 3) do
            Wait(5)
            if IsControlJustReleased(0, Config.Prompts.DropKey) then
                PromptSetEnabled(PropPrompt, false)
                PromptSetVisible(PropPrompt, false)
                PromptSetEnabled(UsePrompt, false)
                PromptSetVisible(UsePrompt, false)
                PromptSetEnabled(ChangeStance, false)
                PromptSetVisible(ChangeStance, false)
                proppromptdisplayed = false

                ClearPedSecondaryTask(ped)
                Anim(ped, "amb_rest@world_human_smoking@male_a@stand_exit", "exit_back", -1, 1)
                Wait(2800)
                DetachEntity(cigaret, true, true)
                SetEntityVelocity(cigaret, 0.0, 0.0, -1.0)
                Wait(1500)
                ClearPedSecondaryTask(ped)
                ClearPedTasks(ped)
                Wait(10)
            end
            if IsControlJustReleased(0, Config.Prompts.ChangeKey) then
                if stance == "c" then
                    Anim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@base", "base", -1, 30)
                    Wait(1000)
                    while not IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "b"
                elseif stance == "b" then
                    Anim(ped, "amb_rest@world_human_smoking@male_d@base", "base", -1, 30)
                    Wait(1000)
                    while not IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@male_d@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "d"
                elseif stance == "d" then
                    Anim(ped, "amb_rest@world_human_smoking@male_d@trans", "d_trans_a", -1, 30)
                    Wait(4000)
                    Anim(ped, "amb_wander@code_human_smoking_wander@male_a@base", "base", -1, 30, 0)
                    while not IsEntityPlayingAnim(ped, "amb_wander@code_human_smoking_wander@male_a@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "a"
                else --stance=="a"
                    Anim(ped, "amb_rest@world_human_smoking@male_a@trans", "a_trans_c", -1, 30)
                    Wait(4233)
                    Anim(ped, "amb_rest@world_human_smoking@male_c@base", "base", -1, 30, 0)
                    while not IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@male_c@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "c"
                end
            end

            if stance == "c" then
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@male_c@idle_a", "idle_b", -1, 30, 0)
                        Wait(21166)
                        Anim(ped, "amb_rest@world_human_smoking@male_c@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@male_c@idle_a", "idle_a", -1, 30, 0)
                        Wait(8500)
                        Anim(ped, "amb_rest@world_human_smoking@male_c@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            elseif stance == "b" then
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@idle_c", "idle_g", -1, 30, 0)
                        Wait(13433)
                        Anim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@idle_a", "idle_a", -1, 30, 0)
                        Wait(3199)
                        Anim(ped, "amb_rest@world_human_smoking@nervous_stressed@male_b@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            elseif stance == "d" then
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@male_d@idle_a", "idle_b", -1, 30, 0)
                        Wait(7366)
                        Anim(ped, "amb_rest@world_human_smoking@male_d@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@male_d@idle_c", "idle_g", -1, 30, 0)
                        Wait(7866)
                        Anim(ped, "amb_rest@world_human_smoking@male_d@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            else --stance=="a"
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@male_a@idle_a", "idle_b", -1, 30, 0)
                        Wait(12533)
                        Anim(ped, "amb_wander@code_human_smoking_wander@male_a@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@male_a@idle_a", "idle_a", -1, 30, 0)
                        Wait(8200)
                        Anim(ped, "amb_wander@code_human_smoking_wander@male_a@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            end
        end
    else --if female
        while IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@female_c@base", "base", 3)
            or IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@female_b@base", "base", 3)
            or IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@female_a@base", "base", 3) do
            Wait(5)
            if IsControlJustReleased(0, Config.Prompts.DropKey) then
                PromptSetEnabled(PropPrompt, false)
                PromptSetVisible(PropPrompt, false)
                PromptSetEnabled(UsePrompt, false)
                PromptSetVisible(UsePrompt, false)
                PromptSetEnabled(ChangeStance, false)
                PromptSetVisible(ChangeStance, false)
                proppromptdisplayed = false

                ClearPedSecondaryTask(ped)
                Anim(ped, "amb_rest@world_human_smoking@female_b@trans", "b_trans_fire_stand_a", -1, 1)
                Wait(3800)
                DetachEntity(cigaret, true, true)
                Wait(800)
                ClearPedSecondaryTask(ped)
                ClearPedTasks(ped)
                Wait(10)
            end
            if IsControlJustReleased(0, Config.Prompts.ChangeKey) then
                if stance == "c" then
                    Anim(ped, "amb_rest@world_human_smoking@female_b@base", "base", -1, 30)
                    Wait(1000)
                    while not IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@female_b@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "b"
                elseif stance == "b" then
                    Anim(ped, "amb_rest@world_human_smoking@female_b@trans", "b_trans_a", -1, 30)
                    Wait(5733)
                    Anim(ped, "amb_rest@world_human_smoking@female_a@base", "base", -1, 30, 0)
                    while not IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@female_a@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "a"
                else --stance=="a"
                    Anim(ped, "amb_rest@world_human_smoking@female_c@base", "base", -1, 30)
                    Wait(1000)
                    while not IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@female_c@base", "base", 3) do
                        Wait(100)
                    end
                    stance = "c"
                end
            end

            if stance == "c" then
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@female_c@idle_a", "idle_a", -1, 30, 0)
                        Wait(9566)
                        Anim(ped, "amb_rest@world_human_smoking@female_c@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@female_c@idle_b", "idle_f", -1, 30, 0)
                        Wait(8133)
                        Anim(ped, "amb_rest@world_human_smoking@female_c@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            elseif stance == "b" then
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@female_b@idle_b", "idle_f", -1, 30, 0)
                        Wait(8033)
                        Anim(ped, "amb_rest@world_human_smoking@female_b@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@female_b@idle_a", "idle_b", -1, 30, 0)
                        Wait(4266)
                        Anim(ped, "amb_rest@world_human_smoking@female_b@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            else --stance=="a"
                if IsControlJustReleased(0, Config.Prompts.SmokeKey) then
                    Wait(500)
                    if IsControlPressed(0, Config.Prompts.SmokeKey) then
                        Anim(ped, "amb_rest@world_human_smoking@female_a@idle_b", "idle_d", -1, 30, 0)
                        Wait(14566)
                        Anim(ped, "amb_rest@world_human_smoking@female_a@base", "base", -1, 30, 0)
                        Wait(100)
                    else
                        Anim(ped, "amb_rest@world_human_smoking@female_a@idle_a", "idle_b", -1, 30, 0)
                        Wait(6100)
                        Anim(ped, "amb_rest@world_human_smoking@female_a@base", "base", -1, 30, 0)
                        Wait(100)
                    end
                end
            end
        end
    end

    PromptSetEnabled(PropPrompt, false)
    PromptSetVisible(PropPrompt, false)
    PromptSetEnabled(UsePrompt, false)
    PromptSetVisible(UsePrompt, false)
    PromptSetEnabled(ChangeStance, false)
    PromptSetVisible(ChangeStance, false)
    proppromptdisplayed = false

    DetachEntity(cigaret, true, true)
    ClearPedSecondaryTask(ped)
    RemoveAnimDict("amb_wander@code_human_smoking_wander@male_a@base")
    RemoveAnimDict("amb_rest@world_human_smoking@male_a@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@nervous_stressed@male_b@base")
    RemoveAnimDict("amb_rest@world_human_smoking@nervous_stressed@male_b@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@nervous_stressed@male_b@idle_g")
    RemoveAnimDict("amb_rest@world_human_smoking@male_c@base")
    RemoveAnimDict("amb_rest@world_human_smoking@male_c@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@male_d@base")
    RemoveAnimDict("amb_rest@world_human_smoking@male_d@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@male_d@idle_c")
    RemoveAnimDict("amb_rest@world_human_smoking@male_a@trans")
    RemoveAnimDict("amb_rest@world_human_smoking@male_c@trans")
    RemoveAnimDict("amb_rest@world_human_smoking@male_d@trans")
    RemoveAnimDict("amb_rest@world_human_smoking@female_a@base")
    RemoveAnimDict("amb_rest@world_human_smoking@female_a@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@female_a@idle_b")
    RemoveAnimDict("amb_rest@world_human_smoking@female_b@base")
    RemoveAnimDict("amb_rest@world_human_smoking@female_b@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@female_b@idle_b")
    RemoveAnimDict("amb_rest@world_human_smoking@female_c@base")
    RemoveAnimDict("amb_rest@world_human_smoking@female_c@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@female_c@idle_b")
    RemoveAnimDict("amb_rest@world_human_smoking@female_b@trans")
    Wait(100)
    ClearPedTasks(ped)
end)

RegisterNetEvent('rs_tabac:cigar')
AddEventHandler('rs_tabac:cigar', function()
    PlaySoundFrontend("Core_Full", "Consumption_Sounds", true, 0)
    ExecuteCommand('close')
    FPrompt(Config.Drop, Config.Prompts.DropKey, false)
    
    local prop_name = 'P_CIGAR01X'
    local ped = PlayerPedId()
    local dict = 'amb_rest@world_human_smoke_cigar@male_a@idle_b'
    local anim = 'idle_d'
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetEntityBoneIndexByName(ped, 'SKEL_R_Finger12')
    local smoking = false

    if not IsEntityPlayingAnim(ped, dict, anim, 3) then
        local waiting = 0
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                print('RedM Fucked up this animation')
                break
            end
        end

        Wait(100)
        AttachEntityToEntity(prop, ped, boneIndex, 0.01, -0.00500, 0.01550, 0.024, 300.0, -40.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Wait(1000)

        if proppromptdisplayed == false then
            PromptSetEnabled(PropPrompt, true)
            PromptSetVisible(PropPrompt, true)
            proppromptdisplayed = true
        end

        smoking = true
        while smoking do
            if IsEntityPlayingAnim(ped, dict, anim, 3) then
                DisableControlAction(0, 0x07CE1E61, true)
                DisableControlAction(0, 0xF84FA74F, true)
                DisableControlAction(0, 0xCEE12B50, true)
                DisableControlAction(0, 0xB2F377E8, true)
                DisableControlAction(0, 0x8FFC75D6, true)
                DisableControlAction(0, 0xD9D0E1C0, true)

                if IsControlPressed(0, 0x3B24C470) then
                    PromptSetEnabled(PropPrompt, false)
                    PromptSetVisible(PropPrompt, false)
                    proppromptdisplayed = false
                    smoking = false
                    ClearPedSecondaryTask(ped)
                    DeleteObject(prop)
                    RemoveAnimDict(dict)
                    break
                end
            else
                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
            end
            Wait(0)
        end
    end
end)


RegisterNetEvent('rs_tabac:pipe_smoker')
AddEventHandler('rs_tabac:pipe_smoker', function()
    FPrompt(Config.Drop, Config.Prompts.DropKey, false)
    LMPrompt(Config.Smoke, Config.Prompts.SmokeKey, false)
    EPrompt(Config.Change, Config.Prompts.ChangeKey, false)
    ExecuteCommand('close')
    local ped = PlayerPedId()
    local male = IsPedMale(ped)
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local pipe= CreateObject(GetHashKey('P_PIPE01X'), x, y, z + 0.2, true, true, true)
    local righthand = GetEntityBoneIndexByName(ped, "SKEL_R_Finger13")
    AttachEntityToEntity(pipe, ped, righthand, 0.005, -0.045, 0.0, -170.0, 10.0, -15.0, true, true, false, true, 1, true)
    Anim(ped,"amb_wander@code_human_smoking_wander@male_b@trans","nopipe_trans_pipe",-1,30)
    Wait(9000)
    Anim(ped,"amb_rest@world_human_smoking@male_b@base","base",-1,31)

    while not IsEntityPlayingAnim(ped,"amb_rest@world_human_smoking@male_b@base","base", 3) do
        Wait(100)
    end


    if proppromptdisplayed == false then
        PromptSetEnabled(PropPrompt, true)
        PromptSetVisible(PropPrompt, true)
        PromptSetEnabled(UsePrompt, true)
        PromptSetVisible(UsePrompt, true)
        PromptSetEnabled(ChangeStance, true)
        PromptSetVisible(ChangeStance, true)
        proppromptdisplayed = true
	end

    while IsEntityPlayingAnim(ped, "amb_rest@world_human_smoking@male_b@base","base", 3) do

        Wait(2)
		if IsControlJustReleased(0, 0x3B24C470) then
            PromptSetEnabled(PropPrompt, false)
            PromptSetVisible(PropPrompt, false)
            PromptSetEnabled(UsePrompt, false)
            PromptSetVisible(UsePrompt, false)
            PromptSetEnabled(ChangeStance, false)
            PromptSetVisible(ChangeStance, false)
            proppromptdisplayed = false

            Anim(ped, "amb_wander@code_human_smoking_wander@male_b@trans", "pipe_trans_nopipe", -1, 30)
            Wait(6066)
            DeleteEntity(pipe)
            ClearPedSecondaryTask(ped)
            ClearPedTasks(ped)
            Wait(10)
		end
        
        if IsControlJustReleased(0, 0xD51B784F) then
            Anim(ped, "amb_rest@world_human_smoking@pipe@proper@male_d@wip_base", "wip_base", -1, 30)
            Wait(5000)
            Anim(ped, "amb_rest@world_human_smoking@male_b@base","base", -1, 31)
            Wait(100)
        end

        if IsControlJustReleased(0, 0x07B8BEAF) then
            Anim(ped, "amb_rest@world_human_smoking@male_b@idle_a","idle_a", -1, 30, 0)
            Wait(22600)
            Anim(ped, "amb_rest@world_human_smoking@male_b@base","base", -1, 31, 0)
            Wait(100)
        end
    end

    PromptSetEnabled(PropPrompt, false)
    PromptSetVisible(PropPrompt, false)
    PromptSetEnabled(UsePrompt, false)
    PromptSetVisible(UsePrompt, false)
    PromptSetEnabled(ChangeStance, false)
    PromptSetVisible(ChangeStance, false)
    proppromptdisplayed = false

    DetachEntity(pipe, true, true)
    ClearPedSecondaryTask(ped)
    RemoveAnimDict("amb_wander@code_human_smoking_wander@male_b@trans")
    RemoveAnimDict("amb_rest@world_human_smoking@male_b@base")
    RemoveAnimDict("amb_rest@world_human_smoking@pipe@proper@male_d@wip_base")
    RemoveAnimDict("amb_rest@world_human_smoking@male_b@idle_a")
    RemoveAnimDict("amb_rest@world_human_smoking@male_b@idle_b")
    Wait(100)
    ClearPedTasks(ped)
    pipeon = false
end)

RegisterNetEvent('rs_tabac:chewingtobacco')
AddEventHandler('rs_tabac:chewingtobacco', function()
    FPrompt(Config.Drop, Config.Prompts.DropKey, false)
    LMPrompt(Config.Smoke, Config.Prompts.SmokeKey, false)
    EPrompt(Config.Change, Config.Prompts.ChangeKey, false)
    ExecuteCommand('close')
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local righthand = GetEntityBoneIndexByName(ped, "SKEL_R_Finger13")

    local basedict = "amb_misc@world_human_chew_tobacco@male_a@base"
    local basedictB = "amb_misc@world_human_chew_tobacco@male_b@base"
    local MaleA =
    {
        [1] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_a",['anim'] = "idle_a" },
        [2] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_a",['anim'] = "idle_b" },
        [3] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_a",['anim'] = "idle_c" },
        [4] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_b",['anim'] = "idle_d" },
        [5] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_b",['anim'] = "idle_e" },
        [6] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_b",['anim'] = "idle_f" },
        [7] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_c",['anim'] = "idle_g" },
        [8] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_c",['anim'] = "idle_h" },
        [9] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_c",['anim'] = "idle_i" },
        [7] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_d",['anim'] = "idle_j" },
        [8] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_d",['anim'] = "idle_k" },
        [9] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_a@idle_d",['anim'] = "idle_l" }
    }
    local MaleB =
    {
        [1] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_a",['anim'] = "idle_a" },
        [2] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_a",['anim'] = "idle_b" },
        [3] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_a",['anim'] = "idle_c" },
        [4] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_b",['anim'] = "idle_d" },
        [5] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_b",['anim'] = "idle_e" },
        [6] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_b",['anim'] = "idle_f" },
        [7] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_c",['anim'] = "idle_g" },
        [8] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_c",['anim'] = "idle_h" },
        [9] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_c",['anim'] = "idle_i" },
        [7] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_d",['anim'] = "idle_j" },
        [8] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_d",['anim'] = "idle_k" },
        [9] = { ['dict'] = "amb_misc@world_human_chew_tobacco@male_b@idle_d",['anim'] = "idle_l" }
    }
    local stance = "MaleA"

    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_a")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_b")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_c")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_d")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_a")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_b")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_c")
    RequestAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_d")

    Anim(ped, "amb_misc@world_human_chew_tobacco@male_a@stand_enter", "enter_back", -1, 30)
    Wait(2500)
    local chewingtobacco = CreateObject(GetHashKey('S_TOBACCOTIN01X'), x, y, z + 0.2, true, true, true)
    Wait(10)
    AttachEntityToEntity(chewingtobacco, ped, righthand, 0.0, -0.05, 0.02, 30.0, 180.0, 0.0, true, true, false, true, 1,
        true)
    Wait(6000)
    DeleteEntity(chewingtobacco)
    Wait(3500)
    Anim(ped, basedict, "base", -1, 31, 0)

    while not IsEntityPlayingAnim(ped, basedict, "base", 3) do
        Wait(100)
    end

    if proppromptdisplayed == false then
        PromptSetEnabled(PropPrompt, true)
        PromptSetVisible(PropPrompt, true)
        PromptSetEnabled(UsePrompt, true)
        PromptSetVisible(UsePrompt, true)
        PromptSetEnabled(ChangeStance, true)
        PromptSetVisible(ChangeStance, true)
        proppromptdisplayed = true
    end

    while IsEntityPlayingAnim(ped, basedict, "base", 3) or IsEntityPlayingAnim(ped, basedictB, "base", 3) do
        Wait(5)
        if IsControlJustReleased(0, 0x3B24C470) then
            PromptSetEnabled(PropPrompt, false)
            PromptSetVisible(PropPrompt, false)
            PromptSetEnabled(UsePrompt, false)
            PromptSetVisible(UsePrompt, false)
            PromptSetEnabled(ChangeStance, false)
            PromptSetVisible(ChangeStance, false)
            proppromptdisplayed = false

            Anim(ped, "amb_misc@world_human_chew_tobacco@male_b@idle_b", "idle_d", 5500, 30)
            Wait(5500)
            ClearPedSecondaryTask(ped)
            ClearPedTasks(ped)
            Wait(10)
        end

        if IsControlJustReleased(0, 0x07B8BEAF) then
            local random = math.random(1, 9)
            if stance == "MaleA" then
                randomdict = MaleA[random]['dict']
                randomanim = MaleA[random]['anim']
            else
                randomdict = MaleB[random]['dict']
                randomanim = MaleB[random]['anim']
            end
            animduration = GetAnimDuration(randomdict, randomanim) * 1000
            Wait(100)
            PromptSetEnabled(PropPrompt, false)
            PromptSetVisible(PropPrompt, false)
            PromptSetEnabled(UsePrompt, false)
            PromptSetVisible(UsePrompt, false)
            PromptSetEnabled(ChangeStance, false)
            PromptSetVisible(ChangeStance, false)
            Anim(ped, randomdict, randomanim, -1, 30, 0)
            Wait(animduration)
            if stance == "MaleA" then
                Anim(ped, basedict, "base", -1, 31, 0)
            else
                Anim(ped, basedictB, "base", -1, 31, 0)
            end
            PromptSetEnabled(PropPrompt, true)
            PromptSetVisible(PropPrompt, true)
            PromptSetEnabled(UsePrompt, true)
            PromptSetVisible(UsePrompt, true)
            PromptSetEnabled(ChangeStance, true)
            PromptSetVisible(ChangeStance, true)
            Wait(100)
        end

        if IsControlJustReleased(0, 0xD51B784F) then
            if stance == "MaleA" then
                Anim(ped, "amb_misc@world_human_chew_tobacco@male_a@trans", "a_trans_b", -1, 30)
                PromptSetEnabled(PropPrompt, false)
                PromptSetVisible(PropPrompt, false)
                PromptSetEnabled(UsePrompt, false)
                PromptSetVisible(UsePrompt, false)
                PromptSetEnabled(ChangeStance, false)
                PromptSetVisible(ChangeStance, false)
                Wait(7333)
                Anim(ped, basedictB, "base", -1, 30, 0)
                while not IsEntityPlayingAnim(ped, basedictB, "base", 3) do
                    Wait(100)
                end
                PromptSetEnabled(PropPrompt, true)
                PromptSetVisible(PropPrompt, true)
                PromptSetEnabled(UsePrompt, true)
                PromptSetVisible(UsePrompt, true)
                PromptSetEnabled(ChangeStance, true)
                PromptSetVisible(ChangeStance, true)
                stance = "MaleB"
            else
                Anim(ped, "amb_misc@world_human_chew_tobacco@male_b@trans", "b_trans_a", -1, 30)
                PromptSetEnabled(PropPrompt, false)
                PromptSetVisible(PropPrompt, false)
                PromptSetEnabled(UsePrompt, false)
                PromptSetVisible(UsePrompt, false)
                PromptSetEnabled(ChangeStance, false)
                PromptSetVisible(ChangeStance, false)
                Wait(5833)
                Anim(ped, basedict, "base", -1, 30, 0)
                while not IsEntityPlayingAnim(ped, basedict, "base", 3) do
                    Wait(100)
                end
                PromptSetEnabled(PropPrompt, true)
                PromptSetVisible(PropPrompt, true)
                PromptSetEnabled(UsePrompt, true)
                PromptSetVisible(UsePrompt, true)
                PromptSetEnabled(ChangeStance, true)
                PromptSetVisible(ChangeStance, true)
                stance = "MaleA"
            end
        end
    end

    PromptSetEnabled(PropPrompt, false)
    PromptSetVisible(PropPrompt, false)
    PromptSetEnabled(UsePrompt, false)
    PromptSetVisible(UsePrompt, false)
    PromptSetEnabled(ChangeStance, false)
    PromptSetVisible(ChangeStance, false)
    proppromptdisplayed = false

    DetachEntity(chewingtobacco, true, true)
    ClearPedSecondaryTask(ped)
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_a@stand_enter")
    RemoveAnimDict(base)
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_a")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_b")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_c")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_a@idle_d")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_a")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_b")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_c")
    RemoveAnimDict("amb_misc@world_human_chew_tobacco@male_b@idle_d")
    Wait(100)
    ClearPedTasks(ped)
end)

RegisterNetEvent("rs_tabac:doit")
AddEventHandler("rs_tabac:doit", function(typeof, high, hightype, highduration)
    local type = typeof
    local high = high
    local hightype = hightype
    local highduration = highduration

    if type == "joint" then
        Joint(high, hightype, highduration)
    end
end)

function Joint(high, hightype, highduration) 
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped, true))

    local cigarette = CreateObject(GetHashKey('P_CIGARETTE01X'), x, y, z + 0.2, true, true, true)
    local righthand = GetEntityBoneIndexByName(ped, "SKEL_R_Finger13")
    local mouth = GetEntityBoneIndexByName(ped, "skel_head")

    -- Iniciar automáticamente el fumar
    if IsPedMale(ped) then
        AttachEntityToEntity(cigarette, ped, mouth, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Anim(ped, "amb_rest@world_human_smoking@male_c@stand_enter", "enter_back_rf", 9400, 0)
        Wait(1000)
        AttachEntityToEntity(cigarette, ped, righthand, 0.03, -0.01, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
        Wait(1000)
        AttachEntityToEntity(cigarette, ped, mouth, -0.017, 0.1, -0.01, 0.0, 90.0, -90.0, true, true, false, true, 1, true)
        Wait(3000)
        AttachEntityToEntity(cigarette, ped, righthand, 0.017, -0.01, -0.01, 0.0, 120.0, 10.0, true, true, false, true, 1, true)
        Wait(1000)
        Anim(ped, "amb_rest@world_human_smoking@male_c@base", "base", -1, 30)
        RemoveAnimDict("amb_rest@world_human_smoking@male_c@stand_enter")
        Wait(1000)
    else
        AttachEntityToEntity(cigarette, ped, mouth, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Anim(ped, "amb_rest@world_human_smoking@female_c@base", "base", -1, 30)
        Wait(1000)
        AttachEntityToEntity(cigarette, ped, righthand, 0.01, 0.0, 0.01, 0.0, -160.0, -130.0, true, true, false, true, 1, true)
        Wait(2500)
    end

    -- Activar los efectos del high y esperar toda la duración
    if high then
        AnimpostfxPlay(hightype)
        Citizen.Wait(highduration * 1000)  -- Esperar toda la duración del efecto
        AnimpostfxStop(hightype)
    end

    -- Tirar el cigarro automáticamente justo cuando termina el efecto
    ClearPedSecondaryTask(ped)
    if IsPedMale(ped) then
        Anim(ped, "amb_rest@world_human_smoking@male_a@stand_exit", "exit_back", -1, 1)
    else 
        Anim(ped, "amb_rest@world_human_smoking@female_b@trans", "b_trans_fire_stand_a", -1, 1)
    end
    Wait(3500)  -- Espera para que la animación de salida termine

    -- Tirar el cigarro
    DetachEntity(cigarette, true, true)
    SetEntityVelocity(cigarette, 0.0, 0.0, -1.0)
    Wait(1500)

    -- Limpiar tareas del ped después de tirar el cigarro
    ClearPedSecondaryTask(ped)
    ClearPedTasks(ped)
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout > 0) do
            timeout = timeout - 1
            if timeout == 0 then 
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag, 1, false, false, false, 0, true)
    end)
end

function HighEffect(hightype, highduration) 
    AnimpostfxPlay(hightype)
    Citizen.Wait(highduration * 1000)  -- El efecto de high sigue durante toda la duración
    AnimpostfxStop(hightype)
end

------------------------------------- drug -----------------------------------------------------


--########################### ANIM ###########################
function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
	RequestAnimDict(dict)
	local dur = duration or -1
	local flag = flags or 1
	local intro = tonumber(introtiming) or 1.0
	local exit = tonumber(exittiming) or 1.0

	while not HasAnimDictLoaded(dict)  do
		RequestAnimDict(dict)
		Citizen.Wait(300)
	end
	TaskPlayAnim(actor, dict, body, intro, exit, dur, flag, 1, false, false, false, 0, true)
end

--########################### OPIUM ###########################
RegisterNetEvent('rs_tabac:Opium')
AddEventHandler('rs_tabac:Opium', function()
	local pipe = CreateObject(GetHashKey('P_PIPE01X'), GetEntityCoords(PlayerPedId()), true, true, true)
    local righthand = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Finger13")
    AttachEntityToEntity(pipe, PlayerPedId(), righthand, 0.005, -0.045, 0.0, -170.0, 10.0, -15.0, true, true, false, true, 1, true)
    Anim(PlayerPedId(),"amb_wander@code_human_smoking_wander@male_b@trans","nopipe_trans_pipe",-1,30)
    Wait(8000)
	Anim(PlayerPedId(), "amb_wander@code_human_smoking_wander@male_b@trans", "pipe_trans_nopipe", -1, 30)
	Wait(500)
	DeleteEntity(pipe)
	ClearPedTasks(PlayerPedId())

	AnimpostfxPlay('PlayerWakeUpDrunk')
	AnimpostfxPlay('playerdrugshalluc01')
	Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), true, 1.0) -- SetPedDrunkness

	Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, 100)	-- SetAttributeCoreValue
	Citizen.InvokeNative(0x4AF5A4C7B9157D14, PlayerPedId(), 0, 1000.0, true)	-- EnableAttributeCoreOverpower

	Wait(Config.OpiumEffect)

	AnimpostfxPlay('PlayerWakeUpDrunk')
	AnimpostfxStop('playerdrugshalluc01')
	Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), false, 0.0) -- SetPedDrunkness
end)


--########################### MUSHROOM ###########################
local cam, mushroom
local SkyEffects = {
	"skytl_0000_01clear",
	"skytl_0000_03clouds",
	"skytl_0000_04storm",
	"skytl_0300_01clear",
	"skytl_0300_03clouds",
	"skytl_0300_04storm",
	"skytl_0600_01clear",
	"skytl_0600_03clouds",
	"skytl_0600_04storm",
	"skytl_0900_01clear",
	"skytl_0900_03clouds",
	"skytl_0900_04storm",
	"skytl_1200_01clear",
	"skytl_1200_03clouds",
	"skytl_1200_04storm",
	"skytl_1500_01clear",
	"skytl_1500_03clouds",
	"skytl_1500_04storm",
	"skytl_1800_01clear",
	"skytl_1800_03clouds",
	"skytl_1800_04storm",
	"skytl_2100_01clear",
	"skytl_2100_03clouds",
	"skytl_2100_04storm",
	"SkyTL_0000_01Clear_nofade",
	"SkyTL_0000_03Clouds_nofade",
	"SkyTL_0000_04Storm_nofade",
	"SkyTL_0300_01Clear_nofade",
	"SkyTL_0300_03Clouds_nofade",
	"SkyTL_0300_04Storm_nofade",
	"SkyTL_0600_01Clear_nofade",
	"SkyTL_0600_03Clouds_nofade",
	"SkyTL_0600_04Storm_nofade",
	"SkyTL_0900_01Clear_nofade",
	"SkyTL_0900_03Clouds_nofade",
	"SkyTL_0900_04Storm_nofade",
	"SkyTL_1200_01Clear_nofade",
	"SkyTL_1200_03Clouds_nofade",
	"SkyTL_1200_04Storm_nofade",
	"SkyTL_1500_01Clear_nofade",
	"SkyTL_1500_03Clouds_nofade",
	"SkyTL_1500_04Storm_nofade",
	"SkyTL_1800_01Clear_nofade",
	"SkyTL_1800_03Clouds_nofade",
	"SkyTL_1800_04Storm_nofade",
	"SkyTL_2100_01Clear_nofade",
	"SkyTL_2100_03Clouds_nofade",
	"SkyTL_2100_04Storm_nofade",
}

RegisterNetEvent('rs_tabac:Mushroom')
AddEventHandler('rs_tabac:Mushroom', function()
	mushroom = CreateObject(GetHashKey('s_amedmush'), GetEntityCoords(PlayerPedId()), true, true, true)
    local righthand = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Finger13")
    AttachEntityToEntity(mushroom, PlayerPedId(), righthand, 0.005, -0.045, 0.0, -170.0, 10.0, -15.0, true, true, false, true, 1, true)
	Anim(PlayerPedId(), "mech_inventory@eating@multi_bite@wedge_a4-2_b0-75_w8_h9-4_eat_cheese", "quick_right_hand", -1, 30)
	Wait(3000)
	
	DeleteEntity(mushroom)
	ClearPedTasks(PlayerPedId())
	Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), true, 1.0)	-- SetPedDrunkness
	AnimpostfxPlay('PlayerRPGCore')
	Wait(10000)

	Citizen.InvokeNative(0x449995EA846D3FC2, -90.0)	-- SetGameplayCamInitialPitch
	Anim(PlayerPedId(), "veh_train@trolly@exterior@rl@exit@to@land@normal@get_out_start@male","dead_fall_out", -1, 2)
	Wait(10000)

	Citizen.InvokeNative(0x449995EA846D3FC2, -90.0)	-- SetGameplayCamInitialPitch
	Wait(500)
	local pcoords = GetEntityCoords(PlayerPedId())
	local coords = vector3(pcoords.x, pcoords.y, pcoords.z + 100)
	cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords, -90.0, 0.0, 0.0, 60.00, false, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 15000, 1, 0)
	Wait(20000)

	AnimpostfxPlay('PlayerWakeUpInterrogation')
	Wait(2000)

	local animpostfx = SkyEffects[math.random(#SkyEffects)]
	AnimpostfxPlay(animpostfx)
	Wait(20000)

	AnimpostfxPlay('PlayerWakeUpInterrogation')
	AnimpostfxStop(animpostfx)
	Wait(10000)


	if DoesCamExist(cam) then
		RenderScriptCams(false, true, 10000, 1, 0)
		DestroyCam(cam, true)
	end
	Wait(15000)

	ClearPedTasks(PlayerPedId())
	Anim(PlayerPedId(), "script_proc@robberies@shop@rhodes@gunsmith@outside_reshoot","kneel_get_up_plr", -1, 2)
	Wait(2000)

	ClearPedTasks(PlayerPedId())
	Wait(5000)

	AnimpostfxPlay('PlayerWakeUpInterrogation')
	Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), false, 0.0)	-- SetPedDrunkness
	AnimpostfxStop('PlayerRPGCore')
end)


--########################### STOP RESOURCE ###########################
AddEventHandler('onResourceStop', function (resourceName)
	AnimpostfxStop('PlayerDrugsPoisonWell')
	AnimpostfxStop('playerdrugshalluc01')

	Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), false, 0.0)	-- SetPedDrunkness

	ClearPedTasks(PlayerPedId())

	DeleteEntity(mushroom)

	AnimpostfxStop('PlayerRPGCore')

	if DoesCamExist(cam) then
		DestroyCam(cam, true)
	end

	for _, animpostfx in pairs(SkyEffects) do
		AnimpostfxStop(animpostfx)
	end
end)