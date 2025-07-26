KASSA_LANG = {}


KASSA_LANG["FI"] = {
    register_name = "Kassakone",
    register_opened = "Kassakone avattu! Paina E ryöstääksesi.",
    too_slow_locked = "Olit liian hidas! Kassakone lukittui.",
    not_opened = "Kassakone ei ole auki! Avaa se ensin lockpickillä.",
    not_robber = "Et voi ryöstää kassakonetta ollessasi %s!",
    no_police = "Ei tarpeeksi poliiseja paikalla ryöstöön!",
    already_robbed = "Kassakonetta ryöstetään jo!",
    robbery_started = "Ryöstät kassakonetta!",
    too_far = "Menit liian kauas kassakoneesta! Ryöstö peruttu.",
    reward = "Ryöstit %s kassakoneesta!",
    saved = "Tallennettu %d kassakonetta.",
    saved_console = "%d kassakonetta ladattu kartalle %s.",
    not_found = "Kassakoneita ei löytynyt.",
    data_deleted = "Tallennettu data poistettu.",
    data_deleted_console = "Tallennettu data kartalle poistettu!",
    data_not_found_console = "Tallennettua dataa ei löytynyt kartalle!",
    being_robbed = "Kassakonetta ryöstetään!",
    just_robbed = "Juuri ryöstetty!",
    wanted = "Kassakoneen ryöstö!"
}


KASSA_LANG["EN"] = {
    register_name = "Cash Register",
    register_opened = "Register opened! Press E to rob.",
    too_slow_locked = "You were too slow! Register locked.",
    not_opened = "Register is not open! Open it first with a lockpick.",
    not_robber = "You cannot rob the register as %s!",
    no_police = "Not enough police present for robbery!",
    already_robbed = "Register is already being robbed!",
    robbery_started = "You are robbing the register!",
    too_far = "You went too far from the register! Robbery cancelled.",
    reward = "You robbed %s from the register!",
    saved = "%d registers saved.",
    saved_console = "%d registers loaded on map %s.",
    not_found = "No registers found.",
    data_deleted = "Saved data deleted.",
    data_deleted_console = "Saved data for map deleted!",
    data_not_found_console = "No saved data found for map!",
    being_robbed = "Register is being robbed!",
    just_robbed = "Just robbed!",
    wanted = "Cash register robbery!"
}

KASSA_LANG["ES"] = {
    register_name = "Caja registradora",
    register_opened = "Registradora abierta! Apreta E para robar.",
    too_slow_locked = "Muy lento! Registradora cerrada.",
    not_opened = "Cerrada! Ganzuala primero.",
    not_robber = "No puedes robar esto como %s!",
    no_police = "No hay suficientes policias para un robo!",
    already_robbed = "La registradora ya esta siendo robada!",
    robbery_started = "Estas robando la registradora!",
    too_far = "Te alejaste mucho de la registradora! Robo cancelado.",
    reward = "Robaste %s de la registradora!",
    saved = "%d registradoras guardadas.",
    saved_console = "%d registradoras cargadas en %s.",
    not_found = "No se han encontrado registradoras.",
    data_deleted = "Los datos guardados han sido borrados.",
    data_deleted_console = "Datos guardados borrados para este mapa!",
    data_not_found_console = "No se han encontrado datos para este mapa!",
    being_robbed = "La registradora esta siendo robada!",
    just_robbed = "Recien robada!",
    wanted = "Robar una caja registradora!"
}

function KASSA_LANG.Get(key)
    local lang = KASSA_CONFIG.language
    if KASSA_LANG[lang] and KASSA_LANG[lang][key] then
        return KASSA_LANG[lang][key]
    end
    return nil
end
