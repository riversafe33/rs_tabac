local VORPcore = {}

TriggerEvent("getCore", function(core)
	VORPcore = core
end)

local VorpInv = {}

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

VorpInv.RegisterUsableItem(Config.Opium, function(data)
    
    local itemCount = VorpInv.getItemCount(data.source, Config.OpiumPipe)
    local itemNeededCount = VorpInv.getItemCount(data.source, Config.ItemNeed)
    
    if itemCount >= 1 and itemNeededCount >= 1 then
        VorpInv.subItem(data.source, Config.ItemNeed, 0)
        VorpInv.subItem(data.source, Config.Opium, 1)
        TriggerClientEvent('rs_tabac:Opium', data.source)
    else
        VORPcore.NotifyRightTip(data.source, Config.Text.NeedPipe, 4000)
    end

    VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem(Config.Mushroom, function(data)
    VorpInv.CloseInv(data.source)

    VorpInv.subItem(data.source, Config.Mushroom, 1)

    TriggerClientEvent('rs_tabac:Mushroom', data.source)
end)

local JointPacks = {
    ["jointpack5"] = {
        type = "joint", pack = true,
        high = true, hightype = "l_0034b485up", highduration = 40,
        next = "jointpack4", message = Config.Text.Joint4,
    },
    ["jointpack4"] = {
        type = "joint", pack = true,
        high = true, hightype = "l_0034b485up", highduration = 40,
        next = "jointpack3", message = Config.Text.Joint3,
    },
    ["jointpack3"] = {
        type = "joint", pack = true,
        high = true, hightype = "l_0034b485up", highduration = 40,
        next = "jointpack2", message = Config.Text.Joint2,
    },
    ["jointpack2"] = {
        type = "joint", pack = true,
        high = true, hightype = "l_0034b485up", highduration = 40,
        next = "jointpack1", message = Config.Text.Joint1,
    },
    ["jointpack1"] = {
        type = "joint", pack = true,
        high = true, hightype = "l_0034b485up", highduration = 40,
        next = nil, message = Config.Text.Nojoint,
    },
    ["joint"] = {
        type = "joint", pack = false,
        high = true, hightype = "l_0034b485up", highduration = 40,
        next = nil, message = Config.Text.Joint,
    }
}

Citizen.CreateThread(function()
    Wait(500)
    for itemName, itemData in pairs(JointPacks) do 
        VorpInv.RegisterUsableItem(itemName, function(data)
            local src = data.source

            local count = VorpInv.getItemCount(src, Config.ItemNeed)
            if count >= 1 then

                VorpInv.subItem(src, Config.ItemNeed, 0)

                TriggerClientEvent('rs_tabac:doit', src, itemData.type, itemData.high, itemData.hightype, itemData.highduration)

                VorpInv.subItem(src, itemName, 1)

                if itemData.pack and itemData.next then
                    VorpInv.addItem(src, itemData.next, 1)
                end

                TriggerClientEvent("vorp:TipRight", src, itemData.message, 4000)
            else
                TriggerClientEvent("vorp:TipRight", src, Config.Text.Lighter, 4000)
            end

            VorpInv.CloseInv(src)
        end)
    end
end)

VorpInv.RegisterUsableItem("pipe", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	count2 = VorpInv.getItemCount(data.source, Config.ItemNeed2)
	if count >= 1 and count2 >= 1 then
		VorpInv.subItem(data.source, Config.ItemNeed, 0)
		VorpInv.subItem(data.source, Config.ItemNeed2, 1)
		TriggerClientEvent('rs_tabac:pipe_smoker', data.source)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Pipe, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("pipe_indien", function(data)
    count = VorpInv.getItemCount(data.source, Config.ItemNeed4)
    count2 = VorpInv.getItemCount(data.source, Config.ItemNeed3)
    
    if count >= 1 and count2 >= 1 then
        local item = VorpInv.getItem(data.source, Config.ItemNeed4)
        if item ~= nil then
            local meta = item["metadata"]
            if next(meta) == nil then 
                VorpInv.subItem(data.source, Config.ItemNeed4, 1, {})
                local drb = Config.MatchesDurability - 1
                VorpInv.addItem(data.source, Config.ItemNeed4, 1, {
                    description = Config.Text.Durability .. drb,
                    durability = drb
                })
            else
                local durability = meta.durability - 1
                VorpInv.subItem(data.source, Config.ItemNeed4, 1, meta)
                if durability <= 0 then 
                    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Broken, 3000)
                else
                    VorpInv.addItem(data.source, Config.ItemNeed4, 1, {
                        description = Config.Text.Durability .. durability,
                        durability = durability
                    })
                end
            end
        end

        VorpInv.subItem(data.source, Config.ItemNeed3, 1)
        TriggerClientEvent('rs_tabac:pipe_indien', data.source)
    else
        TriggerClientEvent("vorp:TipRight", data.source, Config.Text.PipeIndien, 3000)
    end
    
    VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigar", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
		VorpInv.subItem(data.source, Config.ItemNeed, 0)
		VorpInv.subItem(data.source, "cigar", 1)
		TriggerClientEvent('rs_tabac:cigar', data.source)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Cigar, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigarpack6", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarpack6", 1)
    VorpInv.addItem(data.source, "cigarpack5", 1)
	TriggerClientEvent('rs_tabac:cigar', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text14, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigarpack5", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarpack5", 1)
    VorpInv.addItem(data.source, "cigarpack4", 1)
	TriggerClientEvent('rs_tabac:cigar', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text13, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigarpack4", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarpack4", 1)
    VorpInv.addItem(data.source, "cigarpack3", 1)
	TriggerClientEvent('rs_tabac:cigar', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text12, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigarpack3", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarpack3", 1)
    VorpInv.addItem(data.source, "cigarpack2", 1)
	TriggerClientEvent('rs_tabac:cigar', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text11, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigarpack2", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarpack2", 1)
    VorpInv.addItem(data.source, "cigarpack1", 1)
	TriggerClientEvent('rs_tabac:cigar', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text10, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigarpack1", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarpack1", 1)
	TriggerClientEvent('rs_tabac:cigar', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Empty, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)


VorpInv.RegisterUsableItem("cigarette", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigarette", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)


VorpInv.RegisterUsableItem("cigpack10", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack10", 1)
    VorpInv.addItem(data.source, "cigpack9", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text1, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack9", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack9", 1)
    VorpInv.addItem(data.source, "cigpack8", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text2, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack8", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack8", 1)
    VorpInv.addItem(data.source, "cigpack7", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text3, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack7", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack7", 1)
    VorpInv.addItem(data.source, "cigpack6", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text4, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack6", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack6", 1)
    VorpInv.addItem(data.source, "cigpack5", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text5, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack5", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack5", 1)
    VorpInv.addItem(data.source, "cigpack4", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text6, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack4", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack4", 1)
    VorpInv.addItem(data.source, "cigpack3", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text7, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack3", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack3", 1)
    VorpInv.addItem(data.source, "cigpack2", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text8, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack2", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack2", 1)
    VorpInv.addItem(data.source, "cigpack1", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Text9, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("cigpack1", function(data)
	count = VorpInv.getItemCount(data.source, Config.ItemNeed)
	if count >= 1 then
	VorpInv.subItem(data.source, Config.ItemNeed, 0)
	VorpInv.subItem(data.source, "cigpack1", 1)
	TriggerClientEvent('rs_tabac:cigaret', data.source)
    TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Empty, 3000)
	else
		TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Allumettes, 3000)
	end
	VorpInv.CloseInv(data.source)
end)

VorpInv.RegisterUsableItem("chewingtobacco", function(data)
	VorpInv.subItem(data.source, "chewingtobacco", 1)
    VorpInv.addItem(data.source, "chewingtobacco2", 1)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent('rs_tabac:chewingtobacco', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.TextA, 3000)
end)

VorpInv.RegisterUsableItem("chewingtobacco2", function(data)
	VorpInv.subItem(data.source, "chewingtobacco2", 1)
    VorpInv.addItem(data.source, "chewingtobacco3", 1)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent('rs_tabac:chewingtobacco', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.TextB, 3000)
end)

VorpInv.RegisterUsableItem("chewingtobacco3", function(data)
	VorpInv.subItem(data.source, "chewingtobacco3", 1)
    VorpInv.addItem(data.source, "chewingtobacco4", 1)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent('rs_tabac:chewingtobacco', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.TextC, 3000)
end)

VorpInv.RegisterUsableItem("chewingtobacco4", function(data)
	VorpInv.subItem(data.source, "chewingtobacco4", 1)
    VorpInv.addItem(data.source, "chewingtobacco5", 1)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent('rs_tabac:chewingtobacco', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.TextD, 3000)
end)

VorpInv.RegisterUsableItem("chewingtobacco5", function(data)
	VorpInv.subItem(data.source, "chewingtobacco5", 1)
	VorpInv.CloseInv(data.source)
	TriggerClientEvent('rs_tabac:chewingtobacco', data.source)
	TriggerClientEvent("vorp:TipRight", data.source, Config.Text.Empty2, 3000)
end)
