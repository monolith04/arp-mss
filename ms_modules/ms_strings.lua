local strings = {}

strings.AD_ALREADY_UPPED = "[Ускоренная публикация] {B2B2B2}Вы уже подали заявку на ускоренную публикацию объявления"
strings.AD_UPPED = "[Ускоренная публикация] {B2B2B2}Вы повысили приоритет своего объявления!"
strings.BINDER_TEXT_EMPTY = function(name, slot) return string.format("Текст в слоте №%s {EE4444}«%s» {B2B2B2}не может быть пустым", slot, name) end
strings.SCRIPT_LOADED = function(version) return string.format("{99CC00}Monolith Script %s [BETA] {B2B2B2}загружен | Меню скрипта: {99CC00}/mss {B2B2B2}| Приятной игры!", version) end
strings.TFS_MESSAGE = function(hotkey) return string.format("Подсказка: для быстрого открытия меню магазина нажмите - {99CC00}%s", hotkey) end
strings.CLEAR_ONLINE = function(hours, mins) return string.format("Ваш чистый онлайн за сегодня: {99CC00}%s ч %s мин", hours, mins) end


local re_templates = {}
re_templates.TIME_STRING = "{FFFFFF}Время в игре сегодня:		{ffcc00}(%d+) ч (%d+) мин\n{FFFFFF}Время в игре вчера:		{ffcc00}%d+ ч %d+ мин\n{FFFFFF}AFK за сегодня:		{FF7000}(%d+) ч (%d+) мин"
re_templates.BETTER_ID = "%d. (.+) {66CC66}id %d+"
re_templates.GET_OUT_CALL_INFO = "(%W+) | Номер: (%d+) {FFCD00}| Ожидание ответа от (.+)..."
re_templates.GET_IN_CALL_INFO = "(%W+) | Номер: (%d+) {FFCD00}| Вызывает (.+)"
re_templates.GET_CAR_PANEL_DATA = "(%d+)_km/h__~h~Fuel_(%d+)__~.-~(%d+)~n~~(.-)~~h~%w+__~(.-)~%w+__~.-~(%w)_~(.-)~%w__~(.-)~%w_~(.-)~%w_~(.-)~%w"
re_templates.GET_FIRE_DATA = "Пожар возле (.-)\t(.-)\t(.-)\t{......}(.-)\n"

return {
    __VERSION = 2,
    strings = strings,
    re_templates = re_templates
}