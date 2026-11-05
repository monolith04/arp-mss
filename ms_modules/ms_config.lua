local encoding = require 'encoding'

encoding.default = 'CP1251'

local CONFIG = {
	__VERSION = 2,
	NAME = "MS CONFIGURATION",
	INI_PATH = 'mss_config.ini',
	ENCODING = {
		DEFAULT = 'CP1251',
		UTF8 = encoding.UTF8
	},

	INI_DEFAULTS = {
		main = {
			name = "-",
			number = "-",
			zakon = "-",
			org = "-",
			fraktion = "-",
			rang = "-",
			rangn = "-",
			job = "-",
			residence = "-",
			bussiness = "-",
			land_checker = false,
			clear_online = true,
			better_id = false,
			auto_ads = false,
			auto_secret = false,
			auto_up = false,
			auto_ad_queue = false,
			time_informer = false,
			job_informer = false,
			fire_informer = false,
			auto_reg_entrmnt = true,
			auto_fill = false,
			auto_fill_full = false,
			auto_recolor = false,
			auto_fill_count = 40,
			crit_fuel = 14,
			bank_money = false,
			fw_helper = false,
			imgui_theme = 0
		},
		aads = {
			r_chat = false,
			f1_chat = false,
			f2_chat = false,
			v_chat = false,
			s_chat = false,
			fm_chat = false,
			r_intvl = 10,
			f1_intvl = 15,
			f2_intvl = 2,
			v_intvl = 5,
			s_intvl = 10,
			fm_intvl = 3,
			aads_delay = 1000
		},
		land_products = {
			garlic = false,
			bay_leaf = false,
			squash = false,
			pumpkin = false,
			potato = false,
			tomato = false,
			tea = false,
			banana = false,
			ananas = false,
			apples = false,
			pears = false,
			plums = false,
			apricots = false,
			cherrys = false,
			almont = false,
			oranges = false,
			birchj = false,
			pinenuts = false
		},
		colors = {
			imgui_style_number = 1,
			imgui_style_selected_id = 0
		},
		hotkey = {
			car_lock_key = "[76]",
			gnm_key = "[18, 71]",
			phone_key = "[18, 75]",
			autobuy_key = "{}",
			tasks_key = "{}",
			auto_ads_key = "{}",
			healme_key = "{}",
			mask_key = "{}",
			fix_key = "{}"
		},
		imgui_gos_settings = {
			gos_line1 = "",
			gos_line2 = "",
			gos_line3 = "",
			gos_continue = "",
			gos_end = "",
			gos_delay = "1000",
			gos_one_line = ""
		},
		ads_texts = {
			ad1 = "",
			ad2 = "",
			ad3 = "",
			ad4 = "",
			ad5 = "",
			ad6 = "",
			ad7 = "",
			ad8 = "",
			ad9 = "",
			ad10 = ""
		}
	},

	DEFAULTS = {
		CAR_PANEL_STATE = {
			car_speed = 0,
			fuel = 0,
			car_hp = 0,
			lock_state = "-",
			mode = "{1981F2}-",
			fuel_e = 0,
			signalize = "-",
			engine = "-",
			lights = "-",
			car_bnt = "-"
		},
		FAM_STORE = {
			[1] = "1", [2] = "1", [3] = "1", [4] = "1", [5] = "34",
			[6] = "35", [7] = "10", [8] = "90", [9] = "90", [10] = "150",
			[11] = "20", [12] = "20", [13] = "34", [14] = "150", [15] = "150",
			[16] = "40", [17] = "35", [18] = "1", [19] = "1", [20] = "1"
		}
	},

	COLORS = {
		MAIN = "{99CC00}",
		RED = "{F01B1B}",
		BP_GREY = "{B2B2B2}",
		BP_GREEN = "{00cc00}",
		BP_ORANGE = "{ff951d}",
		TEXT_HEX = "{F9B233}"
	},

	UI = {
		BUTTON_COLOR = {0.7, 0.4, 0.1, 1.0},
		BUTTON_HOVERED = {0.8, 0.5, 0.15, 1.0},
		BUTTON_ACTIVE = {0.6, 0.3, 0.1, 1.0},
		TAB_LABELS = {
			'Что нового?', 'Информация', 'Настройки', 'Другие опции', 'AutoAds', 'Биндер'
		}
	},

	COLORS_LEGACY = {
		DEF = "{FA001C}",
		INFO = "{AAC31B}",
		SECONDARY = "{AD33F2}"
	},

	IMGUI_FONT_SIZES = {
		[10] = 10.0,
		[12] = 12.0,
		[14] = 14.0,
		[16] = 16.0,
		[18] = 18.0,
		[21] = 21.0,
		[24] = 24.0,
		[32] = 32.0,
		[36] = 36.0,
		[48] = 48.0,
	},

	INTERIOR_ZONES = {
		[17] = {x = -25.7220, y = -187.8216, z = 1003.5469, dist = 50.0},
		[10] = {x = 6.0856, y = -28.8966, z = 1003.5494, dist = 50.0},
		[18] = {x = -30.9875, y = -89.6806, z = 1003.5469, dist = 50.0},
		[16] = {x = -26.1856, y = -140.9164, z = 1003.5469, dist = 50.0},
		[4] = {x = -27.8440, y = -26.6737, z = 1003.5573, dist = 50.0},
		[6] = {x = -26.8339, y = -55.5846, z = 1003.5469, dist = 50.0}
	}
}

return CONFIG
