local u8 = require('encoding').UTF8

return function(imgui, rkeys)
    local M = {}
    M.__VERSION = 1

    function M.sendClickKeySync(key)
        local data = allocateMemory(68)

        local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampStorePlayerOnfootData(myId, data)

        local weaponId = getCurrentCharWeapon(PLAYER_PED)

        setStructElement(
            data,
            36,
            1,
            weaponId + tonumber(key),
            true
        )

        sampSendOnfootData(data)
        freeMemory(data)
    end

    function M.samp_create_sync_data(sync_type, copy_from_player)
        local ffi = require 'ffi'
        local sampfuncs = require 'sampfuncs'
        local raknet = require 'samp.raknet'
        require 'samp.synchronization'

        copy_from_player = copy_from_player or true

        local sync_traits = {
            player = {
                'PlayerSyncData',
                raknet.PACKET.PLAYER_SYNC,
                sampStorePlayerOnfootData
            },

            vehicle = {
                'VehicleSyncData',
                raknet.PACKET.VEHICLE_SYNC,
                sampStorePlayerIncarData
            },

            passenger = {
                'PassengerSyncData',
                raknet.PACKET.PASSENGER_SYNC,
                sampStorePlayerPassengerData
            },

            aim = {
                'AimSyncData',
                raknet.PACKET.AIM_SYNC,
                sampStorePlayerAimData
            },

            trailer = {
                'TrailerSyncData',
                raknet.PACKET.TRAILER_SYNC,
                sampStorePlayerTrailerData
            },

            unoccupied = {
                'UnoccupiedSyncData',
                raknet.PACKET.UNOCCUPIED_SYNC,
                nil
            },

            bullet = {
                'BulletSyncData',
                raknet.PACKET.BULLET_SYNC,
                nil
            },

            spectator = {
                'SpectatorSyncData',
                raknet.PACKET.SPECTATOR_SYNC,
                nil
            }
        }

        local sync_info = sync_traits[sync_type]

        if not sync_info then
            error('Unknown sync type: ' .. tostring(sync_type))
        end

        local data_type = 'struct ' .. sync_info[1]
        local data = ffi.new(data_type, {})

        local raw_data_ptr = tonumber(
            ffi.cast(
                'uintptr_t',
                ffi.new(data_type .. '*', data)
            )
        )

        -- Копируем sync data игрока
        if copy_from_player then
            local copy_func = sync_info[3]

            if copy_func then
                local player_id

                if copy_from_player == true then
                    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                    player_id = id
                else
                    player_id = tonumber(copy_from_player)
                end

                copy_func(player_id, raw_data_ptr)
            end
        end

        -- Функция отправки пакета
        local func_send = function()
            local bs = raknetNewBitStream()

            raknetBitStreamWriteInt8(
                bs,
                sync_info[2]
            )

            raknetBitStreamWriteBuffer(
                bs,
                raw_data_ptr,
                ffi.sizeof(data)
            )

            raknetSendBitStreamEx(
                bs,
                sampfuncs.HIGH_PRIORITY,
                sampfuncs.UNRELIABLE_SEQUENCED,
                1
            )

            raknetDeleteBitStream(bs)
        end

        -- Метатаблиця для доступу до sync data
        local mt = {
            __index = function(t, index)
                return data[index]
            end,

            __newindex = function(t, index, value)
                data[index] = value
            end
        }

        return setmetatable({
            send = func_send
        }, mt)
    end

    function M.sendChatMessage(text)
        sampAddChatMessage(
            "{99CC00}[MS]: {B2B2B2}" .. text,
            0xB2B2B2
        )
    end

    function M.chatDebug(text, color)
        color = color or "{A5A5A5}"

        sampAddChatMessage(
            color ..
            "[MS Debugger]: {B2B2B2}" ..
            text,
            0xB2B2B2
        )
    end

    function M.dev_cmd1(arg)
        dtext = sampGetDialogText()
        caption = sampGetDialogCaption()

        -- print(caption, arg)
        -- print(dtext)

        -- io.open(
        --     getWorkingDirectory()
        --         .. '\\config\\kolt04\\dev_folder_dialog_texts_and_ids\\'
        --         .. arg
        --         .. ' - '
        --         .. caption
        --         .. '.txt',
        --     'w'
        -- ):write(dtext):close()
    end

    function M.changeHotKeyMessage(command_name, hot_key)
        sampAddChatMessage(
            string.format(u8:decode(
                "{349cfe}[MS] {B2B2B2}Новая клавиша для функции {349cfe}%s{B2B2B2}: {349cfe}[%s]"),
                command_name,
                hot_key
            ),
            0x349cfe
        )
    end

    function M.tab_concat_acm(key_t)
        return table.concat(
            rkeys.getKeysName(key_t),
            " + "
        )
    end

    function M.imgui_controller(window, state)
        if state == nil then

            if imgui.Process == false then
                window.v = true
                imgui.Process = window.v

            elseif imgui.Process == true then

                if not window.v then
                    window.v = true
                else
                    window.v = false
                end

            end

        else

            if imgui.Process == false then
                window.v = state
                imgui.Process = window.v

            elseif imgui.Process == true then
                window.v = state
            end

        end
    end

    function M.get_player_zone()
        local x, y, z = getCharCoordinates(PLAYER_PED)

        local zoneName = getGxtText(
            getNameOfZone(x, y, z)
        )

        return zoneName
    end

    function M.open_mss()
        M.imgui_controller(
            imgui_state.ms_settings,
            nil
        )
    end

    function M.register_binder_hotkeys()
        -- Спочатку знімаємо всі старі прив'язки, щоб не залишалися "мертві" hotkeys
        for i = 1, 50 do
            local old_hotkey = binder_hotkeys_registry[i]
            if old_hotkey ~= nil and type(old_hotkey) == "table" and #old_hotkey > 0 then
                rkeys.unRegisterHotKey(old_hotkey)
            end
        end

        binder_hotkeys_registry = {}

        -- Реєструємо актуальні hotkeys для всіх слотів
        for i = 1, 50 do
            if binder_table[i] ~= nil and binder_table[i]["type"] == 3 then
                local cmd = binder_table[i]["cmd"] or "{}"
                local hotkey_data = decodeJson(cmd)

                if type(hotkey_data) == "table" and #hotkey_data > 0 then
                    local slot_index = i
                    local callback = function()
                        binder_thread:run(slot_index)
                    end

                    local ok, id = rkeys.registerHotKey(hotkey_data, true, callback)
                    if ok then
                        binder_hotkeys_registry[i] = hotkey_data
                    end
                end
            end
        end
    end

    function M.createDirectoryIfNotExist(dir)
        if not doesDirectoryExist(getWorkingDirectory() .. dir) then
            if createDirectory(getWorkingDirectory() .. dir) then
                print("Создана отсутствующая папка: {00CC00}" .. dir)
            end
        end
    end

    function M.loadPlayerModelImage(char_model_id)
        local file = char_model_id .. ".png"
        if not doesFileExist(getWorkingDirectory() .. "\\resource\\skins_img\\" .. file) then
            downloadUrlToFile("https://adv-rp.com/media/skins/" .. file,
                getWorkingDirectory() .. "\\resource\\skins_img\\" .. file)
        end
    end

    function M.tableToString(tbl, indent) -- by Chapo
        -- https://www.blast.hk/threads/13380/post-1378874
        local function formatTableKey(k)
            local defaultType = type(k);
            if (defaultType ~= 'string') then
                k = tostring(k);
            end
            local useSquareBrackets = k:find('^(%d+)') or k:find('(%p)') or k:find('\\') or k:find('%-');
            return useSquareBrackets == nil and k or ('[%s]'):format(defaultType == 'string' and "'" .. k .. "'" or k);
        end
        local str = { '{' };
        local indent = indent or 0;
        for k, v in pairs(tbl) do
            table.insert(str, ('%s%s = %s,'):format(string.rep("    ", indent + 1), formatTableKey(k), type(v) == "table" and tableToString(v, indent + 1) or (type(v) == 'string' and "'" .. v .. "'" or tostring(v))));
        end
        table.insert(str, string.rep('    ', indent) .. '}');
        return table.concat(str, '\n');
    end

    function M.msjson(filePath) -- by Chapo | Работа с JSON
        --[[
        table var = json(filePath):Load(defaultTable)
        var - переменная в которую будет записана таблица
        filePath - название файла (например: "myConfig.json")
        defaultTable - таблица, которая будет создана по умолчанию
            (так же если в загружаемом конфиге нет ключа из стандартной таблицы, то он будет создан)


        --Пример:

        local settings = json('myFirstConfig.json'):Load({
            ['type_string'] = 'hello world',
            ['type_int'] = 550,
            ['type_bool'] = true
        })]]

        local filePath = getWorkingDirectory()..'\\config\\'..(filePath:find('(.+).json') and filePath or filePath..'.json')
        local class = {}
        if not doesDirectoryExist(getWorkingDirectory()..'\\config') then
            createDirectory(getWorkingDirectory()..'\\config')
        end
        
        function class:Save(tbl)
            if tbl then
                local F = io.open(filePath, 'w')
                F:write(encodeJson(tbl) or {})
                F:close()
                return true, 'ok'
            end
            return false, 'table = nil'
        end
    
        function class:Load(defaultTable)
            if not doesFileExist(filePath) then
                class:Save(defaultTable or {})
            end
            local F = io.open(filePath, 'r+')
            local TABLE = decodeJson(F:read() or {})
            F:close()
            for def_k, def_v in next, defaultTable do
                if TABLE[def_k] == nil then
                    TABLE[def_k] = def_v
                end
            end
            return TABLE
        end
    
        return class
    end

    

    return M
end
