local function create_hotkey(value)
	return {
		v = decodeJson(value)
	}
end

return function(config)
  hotkey_callbacks = {}

  function hotkey_callbacks.f_tasks()
    sampSendChat("/tasks")
  end

  function hotkey_callbacks.f_tfs_menu()
    if (currentInterrior == 17 or currentInterrior == 10 or currentInterrior == 16 or currentInterrior == 18 or currentInterrior == 4 or currentInterrior == 6) and not sampIsDialogActive() and not sampIsChatInputActive() then
        sampSendChat("/buy")
    end
  end

  function hotkey_callbacks.f_car_lock()
    if not sampIsDialogActive() and not sampIsChatInputActive() then
        sampSendChat("/lock")
    end
  end

	function hotkey_callbacks.healme()
    sampSendChat("/healme")
	end

	function hotkey_callbacks.mask()
			sampSendChat("/mask")
	end

	function hotkey_callbacks.fix()
			sampSendChat("/fix")
	end

	return {
		__VERSION = 1,
		car_lock_key = create_hotkey(config.hotkey.car_lock_key),
		gnm_key = create_hotkey(config.hotkey.gnm_key),
		phone_key = create_hotkey(config.hotkey.phone_key),
		tfs_menu_key = create_hotkey(config.hotkey.autobuy_key),
		tasks_key = create_hotkey(config.hotkey.tasks_key),
		auto_ads_key = create_hotkey(config.hotkey.auto_ads_key),
		healme_key = create_hotkey(config.hotkey.healme_key),
		mask_key = create_hotkey(config.hotkey.mask_key),
		fix_key = create_hotkey(config.hotkey.fix_key),
		default_hot_key = create_hotkey('{}')
	}
end
