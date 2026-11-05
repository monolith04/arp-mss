return function(imgui, config)
    local H = {}
    H.__VERSION = 1
    
    function H.businessPriceManagment(dialogText, currentPrices)
    --   print(dialogText)
        products_prices = {}
        products_price_fields = {}
        index = 1
        dialogText = dialogText .. "\n"
        -- print("dialog len:", #dialogText)

        local pattern = "%d+%. (.-)\t(.-)\t(.-)\t{%x+}РѕС‚ (%d+)%$ РґРѕ (%d+)%$"

        -- print("pattern:", pattern)

        local a, b, c, d, e = string.match(dialogText, pattern)

        -- print("MATCH:", a, b, c, d, e)
        for name, current, default, min, max in string.gmatch(dialogText, "%d. (.-)\t(.-)\t(.-)\t{......}от (%d+)$ до (%d+)$\n") do
            table.insert(products_price_fields, imgui.new.char[128]())
            imgui.StrCopy(products_price_fields[index], tostring(currentPrices[tostring(index)]) or default:sub(9, -2))
            
            table.insert(products_prices, {"{SSSSSS}"..name, "{00FF00}"..current:sub(9, -2), "{A0B2EE}"..default:sub(9, -2), "{0A57E6}"..min, "{EC0F04}"..max})
            index = index + 1
        end
        return products_prices, products_price_fields
    end

    function H.familyStore(dialogText, fam_store_defaults)
        local text = dialogText .. "\n"
        local fam_store = {}
        local fam_store_buffers = {}
        local index = 1
        for name, count in string.gmatch(text, "([A-Za-zА-Яа-я0-9%- ]+)\t{......}(%d+){......}\n") do
            fam_store_buffers[index] = imgui.new.int()
            -- imgui.StrCopy(fam_store_buffers[index], fam_store_defaults[index])
            fam_store_buffers[index][0] = tonumber(fam_store_defaults[index])
            table.insert(fam_store, {name, count})
            index = index + 1
        end
        return fam_store, fam_store_buffers
    end

    function H.getAbonents(dialogText, type)
        local re = {
            ["work"] = "(.-)%[(%d+)%]\t%d+\t{99b3ff}(%d+)\t.-",
            ["organisation"] = "(%d+). (.-)	.- ранг. .-\t(.-)\t.-",
            ["doclic"] = "(.-)\t(.-)\t.-\t{00e6ac}(%d+)"
        }
        
        local abonents = {}
        
        for index, player, number in dialogText:gmatch(re[type]) do
            -- print(index, number, player)
            table.insert(abonents, number)
        end
        return abonents
    end

    function H.getBattlePassData(dialogTitle, dialogText)
        local re = "(%d+).%s(.-)\t[{......}]?(.-)\t{......}(%d+) из (%d+)\n"

        local totalScore, earnedScore = 0, 0
        local levels = {}

        local daysRemaining = dialogTitle:match("Осталось дней: (%d+)")

        for level, levelTitle, description, currentScore, maxScore in string.gmatch(dialogText, re) do
            description = description:find("}") and description:gsub(description:sub(0, 7), "") or description

            levels[tonumber(level)] = {levelTitle, description, currentScore, maxScore}

            totalScore = totalScore + tonumber(maxScore)
            earnedScore = earnedScore + tonumber(currentScore)
        end

        local progress = earnedScore / totalScore
        local remainingScore = totalScore - earnedScore

        local tasksRequired = math.floor(remainingScore / 25000)
        local halfDayRequired = math.floor(remainingScore / 30000)
        local dailyRequired = math.floor(remainingScore / 15000)

        local tasksHalfDayRequired = math.floor(remainingScore / 55000)
        local tasksDailyRequired = math.floor(remainingScore / 40000)

        local battlePassData = {
            totalScore,
            earnedScore,
            remainingScore,
            tasksRequired,
            halfDayRequired,
            dailyRequired,
            tasksHalfDayRequired,
            tasksDailyRequired,
            daysRemaining,
            progress,
            levels
        }
        return battlePassData
    end

    function H.getTasksData(dialogText)
        local tasks_data = {
            daily = {}, 
            weekly = {},
            seasonal = {},
            general_progress = {
                daily = 0,
                weekly = 0,
                seasonal = 0
            }
        }
        local daily_progress = 0
        local weekly_progress = 0
        local seasonal_progress = 0

        for line in dialogText:gmatch("[^\r\n]+") do
            if line:find("^{......}%d%p") then
                if line:find("^{cce6ff}") then
                    local index, name, progress = line:match("{......}(%d)%p (.+)	{......}(.+)")
                    if progress:find("%d") then
                        daily_progress = daily_progress + progress:gsub("%%", "")
                    elseif progress:find("Выполнено") then
                        daily_progress = daily_progress + 100
                    end
                    tasks_data.daily[index] = {name, progress:gsub("%%", "")}
                end
                if line:find("^{c6ecd7}") then
                    local index, name, progress = line:match("{......}(%d)%p (.+)	{......}(.+)")
                    if progress:find("%d") then
                        weekly_progress = weekly_progress + progress:gsub("%%", "")
                    elseif progress:find("Выполнено") then
                        weekly_progress = weekly_progress + 100
                    end
                    tasks_data.weekly[index] = {name, progress:gsub("%%", "")}
                end
                if line:find("^{ffe0b3}") then
                    local index, name, progress = line:match("{......}(%d)%p (.+)	{......}(.+)")
                    if progress:find("%d") then
                        -- print(progress)
                        seasonal_progress = seasonal_progress + progress:gsub("%%", "")
                    elseif progress:find("Выполнено") then
                        seasonal_progress = seasonal_progress + 100
                    end
                    tasks_data.seasonal[index] = {name, progress:gsub("%%", "")}
                end
            end
        end
        tasks_data.general_progress.daily = daily_progress / 5
        tasks_data.general_progress.weekly = weekly_progress / 5
        tasks_data.general_progress.seasonal = seasonal_progress / 5
        
        return tasks_data
    end

    function H.fuelStationMenu(dialogId, dialogTitle, dialogText, currentFuel)
        local fuelStationData = {}

        fuelStationData.name = dialogTitle
        fuelStationData.price = dialogText:match("Стоимость 1 л топлива: {......}(%d+)%$")
        fuelStationData.refuel_amount = tonumber(dialogText:match("В ваш транспорт поместится ещё {......}(%d+)"))
        if config.main.auto_fill_full then
            fuelStationData.filled = fuelStationData.refuel_amount
        else
            fuelStationData.filled = config.main.auto_fill_count
            if fuelStationData.refuel_amount < config.main.auto_fill_count then
                fuelStationData.filled = fuelStationData.refuel_amount
            end
        end
        
        sampSendDialogResponse(dialogId, 1, 65535, fuelStationData.filled)
        return fuelStationData
    end

    function H.getPlayerStats(dialogText)
        local playerStats = {}
        playerStats.user_id = getUserId()
        playerStats.player_nick = getPlayerNameByIdWO_(userid)
        playerStats.phone_number = dialogText:match("Номер телефона:		{......}(%d+)\n")
        playerStats.obedience = dialogText:match("Законопослушность:		{......}(.*)\n{......}Уровень розыска")
        playerStats.organisation = dialogText:match("Организация:			{......}(.*)\n{......}Подразделение")
        if playerStats.organisation == nil then
            playerStats.organisation = "-"
            playerStats.fraction = "-"
            playerStats.post = "-"
            playerStats.rank = "-"
        else
            playerStats.organisation = dialogText:match("Организация:			{......}(.*)\n{......}Подразделение")
            playerStats.fraction = dialogText:match("Подразделение:		{......}(.*)\n{......}Должность")
            playerStats.post = dialogText:match("Должность:			{......}(.*)\n{......}Ранг")
            playerStats.rank = dialogText:match("Ранг:				{......}(.*)\n{......}Работа")
        end
        playerStats.job = dialogText:match("Работа:				{......}(.*)\n\n{......}Проживание")
        playerStats.residence = dialogText:match("Проживание:			{......}(.*)\n{......}Бизнес")
        playerStats.business = dialogText:match("Бизнес:			{......}(.*)\n{......}Земельный")

        return playerStats
    end

    function H.parseIdCommand(str)
        l_number, nick, id = str:match("(%d+). (.+) {......}id (%d+)")
        if str:match("гол. чат") then
            v_chat = " {FFFFFF}| {4BA7FF}(голосовой чат) "
        else
            v_chat = ""
        end
        if str:match("тел.") then
            phone_number = " {FFFFFF}| {F0E68D}тел. " .. str:match("тел. {ffcc00}(%d+)")
        else
            phone_number = ""
        end
        if str:match("[Mm]obile") then
            client = " {FFFFFF}| {ff9900}Mobile"
        elseif str:match("[Ll]auncher") then
            client = " {FFFFFF}| {ff9900}Launcher (PC)"
        else
            client = ""
        end
        if str:match("[Аа]ккаунт") then
            account_number = string.format(" {FFFFFF}| {808080}номер аккаунта: %s", str:match("аккаунт (%d+)$"))
        else
            account_number = ""
        end
        local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
        org = "H"
        if color == "FFFFFF" then
            -- color = "B2B2B2"
            org = "Гражданский"
        elseif color == "00CCFF" then
            org = "Varios Los Aztecas"
        elseif color == "996633" then
            org = "МО"
        elseif color == "007575" then
            org = "РМ"
        elseif color == "CCFF00" then
            org = "Правительство"
        elseif color == "FF6666" then
            org = "МЗ"
        elseif color == "6666FF" then
            org = "The Rifa"
        elseif color == "BB0000" then
            org = "Yakuza"
        elseif color == "FF6600" then
            org = "СМИ"
        elseif color == "FFCD00" then
            org = "Los Santos Vagos"
        elseif color == "993366" then
            org = "La Cosa Nostra"
        elseif color == "CC00FF" then
            org = "Ballas"
        elseif color == "009900" then
            org = "Groove Street"
        elseif color == "0000FF" then
            org = "МВД"
            color = "3333FF"
        elseif color == "222222" then
            org = "В маске"
            color = "444444"
        else
            org = "Неизвествно"
        end
            -- sampAddChatMessage(l_number .. ". " .. "{" .. color .. "}" .. nick:gsub("_", " ") .. "[" .. id .. "] - " ..
            --                        org .. " {4BA7FF}" .. v_chat .. " {FFCA4B}" .. phone_number, 0xFFFFFF)
        local player = string.format("%s. {%s}%s[%s] - %s%s%s%s%s", l_number, color, nick:gsub("_", " "), id, org, phone_number, v_chat, client, account_number)
        return player
    end

    -- function H.getCarDash(text)
    --     local carDash = {}

    --     return carDash
    -- end
    return H
end
