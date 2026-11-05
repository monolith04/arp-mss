


return function(imgui, config)
	function TextColoredRGB(text)
				local style = imgui.GetStyle()
				local colors = style.Colors
				local ImVec4 = imgui.ImVec4
				local explode_argb = function(argb)
						local a = bit.band(bit.rshift(argb, 24), 0xFF)
						local r = bit.band(bit.rshift(argb, 16), 0xFF)
						local g = bit.band(bit.rshift(argb, 8), 0xFF)
						local b = bit.band(argb, 0xFF)
						return a, r, g, b
				end
				local getcolor = function(color)
						if color:sub(1, 6):upper() == 'SSSSSS' then
								local r, g, b = colors[1].x, colors[1].y, colors[1].z
								local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
								return ImVec4(r, g, b, a / 255)
						end
						local color = type(color) == 'string' and tonumber(color, 16) or color
						if type(color) ~= 'number' then
								return
						end
						local r, g, b, a = explode_argb(color)
						return imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
				end
				local render_text = function(text_)
						for w in text_:gmatch('[^\r\n]+') do
								local text, colors_, m = {}, {}, 1
								w = w:gsub('{(......)}', '{%1FF}')
								while w:find('{........}') do
										local n, k = w:find('{........}')
										local color = getcolor(w:sub(n + 1, k - 1))
										if color then
												text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
												colors_[#colors_ + 1] = color
												m = n
										end
										w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
								end
								if text[0] then
										for i = 0, #text do
												imgui.TextColored(colors_[i] or colors[1], text[i])
												imgui.SameLine(nil, 0)
										end
										imgui.NewLine()
								else
										imgui.Text(w)
								end
						end
				end
				render_text(text)
			end
	return {
		__VERSION = 1,
		ms_settings = imgui.new.bool(false),
		menu_active_item = imgui.new.int(1),
		menu_anim = {},
		biz_control = imgui.new.bool(false),
		fam_store_w = imgui.new.bool(false),
		tfs_shop_w = imgui.new.bool(false),
		tasks_window = imgui.new.bool(false),

		phone_task_helper_window = imgui.new.bool(false),
		pth_sms_text = imgui.new.char[64](),

		battlepass_window = imgui.new.bool(false),
		calling_window = imgui.new.bool(false),
		imgui_txt_color = {},
		car_panel = imgui.new.bool(false),
		act_w = imgui.new.bool(false),
		bind_w = imgui.new.bool(false),
		time_informer_w = imgui.new.bool(config.main.time_informer),
		fire_informer_w = imgui.new.bool(false),
		fire_array = {},
		fire_end_w = imgui.new.bool(false),
		demo_window = imgui.new.bool(false),
		binder = imgui.new.bool(false),
		tb_auto_recolor = imgui.new.bool(config.main.auto_recolor),
		tglLandChecker = imgui.new.bool(config.main.land_checker),
		tglBetterId = imgui.new.bool(config.main.better_id),
		tglClearOnline = imgui.new.bool(config.main.clear_online),
		tglAutoFill = imgui.new.bool(config.main.auto_fill),
		tglAutoSecret = imgui.new.bool(config.main.auto_secret),
		tglFireInformer = imgui.new.bool(config.main.fire_informer),
		tglTimeInformer = imgui.new.bool(config.main.time_informer),
		tglBankMoney = imgui.new.bool(config.main.bank_money),
		auto_fill_litres = imgui.new.int(config.main.auto_fill_count),
		crit_fuel_level = imgui.new.int(config.main.crit_fuel),
		auto_fill_full = imgui.new.bool(config.main.auto_fill_full),

		blocks = {

		},

		themes = {
			DarkTheme = function()
				imgui.SwitchContext()
				--==[ STYLE ]==--
				imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
				imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
				imgui.GetStyle().ItemSpacing = imgui.ImVec2(4, 4)
				imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
				imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
				imgui.GetStyle().IndentSpacing = 0
				imgui.GetStyle().ScrollbarSize = 10
				imgui.GetStyle().GrabMinSize = 10

				--==[ BORDER ]==--
				imgui.GetStyle().WindowBorderSize = 1
				imgui.GetStyle().ChildBorderSize = 1
				imgui.GetStyle().PopupBorderSize = 1
				imgui.GetStyle().FrameBorderSize = 1
				imgui.GetStyle().TabBorderSize = 1

				--==[ ROUNDING ]==--
				imgui.GetStyle().WindowRounding = 5
				imgui.GetStyle().ChildRounding = 5
				imgui.GetStyle().FrameRounding = 5
				imgui.GetStyle().PopupRounding = 5
				imgui.GetStyle().ScrollbarRounding = 5
				imgui.GetStyle().GrabRounding = 5
				imgui.GetStyle().TabRounding = 5

				--==[ ALIGN ]==--
				imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
				imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
				imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
				
				--==[ COLORS ]==--
				imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
				imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
				imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
				imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
				imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
				imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
				imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.22, 0.22, 0.22, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
				imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
				imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
				imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
				imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
				imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
				imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
				imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
				imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
				imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
				imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
				imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
				imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
				imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
				imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
				imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
				imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
				imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
				imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
				imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
				imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
				imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
			end
		},

		functions = {
			TextColoredRGB = TextColoredRGB,

			DrawCircularProgressBar = function(fraction, radius, thickness, color, isSmall)
				local p = imgui.GetCursorScreenPos()
				local center = imgui.ImVec2(p.x + radius, p.y + radius)
				local draw_list = imgui.GetWindowDrawList()
				local num_segments = 50
				local start_angle = -math.pi / 2

				-- Фонове кільце
				draw_list:AddCircle(center, radius, imgui.GetColorU32(imgui.ImVec4(0.15, 0.15, 0.15, 1.0)), num_segments, thickness)

				-- Кільце прогресу
				if fraction > 0 then
						-- Обмежуємо fraction від 0 до 1, щоб не малювало зайвого
						local clear_fraction = math.min(math.max(fraction, 0), 1)
						draw_list:PathArcTo(center, radius, start_angle, start_angle + (math.pi * 2 * clear_fraction), num_segments)
						draw_list:PathStroke(color, false, thickness)
				end

				-- Текст (динамічний розмір)
				local percentage = math.floor(fraction * 100)
				local text = string.format("%d%%", percentage)

				-- Якщо це маленьке коло у списку, робимо текст меншим (scale)
				if isSmall then imgui.SetWindowFontScale(0.8) end

				local text_size = imgui.CalcTextSize(text)
				draw_list:AddText(imgui.ImVec2(center.x - text_size.x / 2, center.y - text_size.y / 2), 0xFFFFFFFF, text)

				if isSmall then imgui.SetWindowFontScale(1.0) end -- Повертаємо масштаб

				imgui.Dummy(imgui.ImVec2(radius * 2, radius * 2))
			end,

			ToggleButton = function(str_id, bool)
				local rBool = false

				if LastActiveTime == nil then
						LastActiveTime = {}
				end
				if LastActive == nil then
						LastActive = {}
				end

				local function ImSaturate(f)
						return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
				end

				local p = imgui.GetCursorScreenPos()
				local dl = imgui.GetWindowDrawList()

				local height = imgui.GetTextLineHeightWithSpacing()
				local width = height * 1.70
				local radius = height * 0.50
				local ANIM_SPEED = type == 2 and 0.10 or 0.15
				local butPos = imgui.GetCursorPos()

				if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
						bool[0] = not bool[0]
						rBool = true
						LastActiveTime[tostring(str_id)] = os.clock()
						LastActive[tostring(str_id)] = true
				end

				imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
				imgui.Text( str_id:gsub('##.+', '') )

				local t = bool[0] and 1.0 or 0.0

				if LastActive[tostring(str_id)] then
						local time = os.clock() - LastActiveTime[tostring(str_id)]
						if time <= ANIM_SPEED then
								local t_anim = ImSaturate(time / ANIM_SPEED)
								t = bool[0] and t_anim or 1.0 - t_anim
						else
								LastActive[tostring(str_id)] = false
						end
				end

				local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.97, 0.69, 0.2, 1.0)) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
				dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg]), height * 0.5)
				dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle)
				return rBool
			end,

			MenuList = function(list, fonts_array, active_item, anim_array)
				local window_pos = imgui.GetWindowPos()
				local window_size = imgui.GetWindowSize()
				local parent_draw = imgui.GetWindowDrawList()

				imgui.SetCursorPos(imgui.ImVec2(10, 32))
				imgui.BeginChild('##menu_sidebar', imgui.ImVec2(185, 380), false)

				local draw = imgui.GetWindowDrawList()
				local posa = imgui.GetCursorScreenPos()
				print(posa.x, posa.y)
				draw:AddRectFilled(imgui.ImVec2(posa.x, posa.y), imgui.ImVec2(posa.x + 170, posa.y + 35), imgui.GetColorU32(imgui.ImVec4(0.97, 0.69, 0.2, 1.0)), 6, imgui.ImDrawCornerFlags_TopLeft + imgui.ImDrawCornerFlags_BotRight)
				imgui.PushFont(fonts_array[24])
				local t_size = imgui.CalcTextSize("MSS")
				imgui.SetCursorPosX(imgui.GetCursorPosX() + (70 / 2 + t_size.x))
				imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
				imgui.Text("MSS")
				imgui.PopFont()
				imgui.SetCursorPosY(imgui.GetCursorPosY() + 10)
				local posb = imgui.GetCursorScreenPos()
				draw:AddLine(imgui.ImVec2(posb.x, posb.y), imgui.ImVec2(posb.x + 170, posb.y), imgui.GetColorU32(imgui.ImVec4(0.35, 0.35, 0.35, 1.0)), 1.0)
				imgui.SetCursorPosY(imgui.GetCursorPosY() + 10)
				local button_width = 170
				local button_height = 32
				local button_spacing = 3
				local rounding = 6

				for k, v in ipairs(list) do
					local pos = imgui.GetCursorScreenPos()

					imgui.InvisibleButton('##menu_' .. k, imgui.ImVec2(button_width, button_height))
					local hovered = imgui.IsItemHovered()
					local active = active_item[0] == k

					if anim_array[k] == nil then
						anim_array[k] = 0
					end

					local target = active and 1.0 or (hovered and 0.5 or 0.0)

					local dt = imgui.GetIO().DeltaTime
					local speed = 12.0
					local factor = math.min(dt * speed, 1.0)

					anim_array[k] = anim_array[k] + (target - anim_array[k]) * factor
					local anim = anim_array[k]

					if anim > 0.005 then
						local color

						if active then
							color = imgui.ImVec4(0.32, 0.32, 0.32, anim)
						else
							color = imgui.ImVec4(0.20, 0.20, 0.20, anim)
						end

						draw:AddRectFilled(pos, imgui.ImVec2(pos.x + button_width, pos.y + button_height), imgui.GetColorU32(color), rounding)
					end

					local icon = v[1]
					local text = v[2]
					local text_size = imgui.CalcTextSize(text)
					local x = pos.x + 12
					local y = pos.y + (button_height - text_size.y) / 2

					draw:AddText(imgui.ImVec2(x, y + 2), imgui.GetColorU32(imgui.ImVec4(249/255, 178/255, 51/255, 1)), icon)

					local icon_size = imgui.CalcTextSize(icon)
					draw:AddText(imgui.ImVec2(x + icon_size.x + 6, y), imgui.GetColorU32(imgui.ImVec4(1, 1, 1, 1)), text)

					if imgui.IsItemClicked() then
						active_item[0] = k
					end

					imgui.SetCursorPosY(imgui.GetCursorPosY() + button_spacing)
				end

				imgui.EndChild()
				parent_draw:AddLine(imgui.ImVec2(window_pos.x + 187, window_pos.y-20), imgui.ImVec2(window_pos.x + 187, window_pos.y + window_size.y), imgui.GetColorU32(imgui.ImVec4(0.35, 0.35, 0.35, 1.0)), 1.0)
			end,

			DrawStatLine = function(icon, val, max, color, icon_offset_y)
            local startY = imgui.GetCursorPosY()
            
            imgui.SetCursorPosX(15)
            if icon_offset_y then
                imgui.SetCursorPosY(startY + icon_offset_y)
            end
            TextColoredRGB(icon)
            
            imgui.SameLine(40)
            
            imgui.SetCursorPosY(startY) 
            
            imgui.PushStyleColor(imgui.Col.PlotHistogram, color)
            imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.15, 0.15, 0.20, 1.0))
            imgui.ProgressBar(val / max, imgui.ImVec2(190, 7), "")
            imgui.PopStyleColor(2)

            imgui.SetCursorPosY(startY + 22) 
        end,

			Header = function(title, color, font)
				imgui.PushFont(font)
        TextColoredRGB(color .. title)
        imgui.PopFont()
        imgui.Separator()
			end
		},
	}
end
