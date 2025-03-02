local times = {
    [1800] = { title = "Aviso", description = "Reinicio del servidor en 30 minutos.", color = "#ffcc00", icon = "fa-solid fa-triangle-exclamation" },
    [900] = { title = "Aviso", description = "Reinicio del servidor en 15 minutos.", color = "#ffcc00", icon = "fa-solid fa-triangle-exclamation" },
    [600] = { title = "Aviso", description = "Reinicio del servidor en 10 minutos.", color = "#ffcc00", icon = "fa-solid fa-triangle-exclamation" },
    [300] = { title = "Aviso", description = "Reinicio del servidor en 5 minutos.", color = "#ff9900", icon = "fa-solid fa-clock" },
    [240] = { title = "Aviso", description = "Reinicio del servidor en 4 minutos.", color = "#ff9900", icon = "fa-solid fa-clock" },
    [180] = { title = "Aviso", description = "Reinicio del servidor en 3 minutos.", color = "#ff6600", icon = "fa-solid fa-clock" },
    [120] = { title = "Aviso", description = "Reinicio del servidor en 2 minutos.", color = "#ff3300", icon = "fa-solid fa-clock" },
    [60] = { title = "Urgente", description = "Reinicio del servidor en 1 minuto. ¡Desconéctate!", color = "#ff0000", icon = "fa-solid fa-exclamation-circle" }
}

AddEventHandler('txAdmin:events:announcement', function(data)
    local notifyData = {
        title = "Anuncio | " .. (data.author or "Admin"),
        description = data.message or "",
        color = "#ffff00",
        icon = "fa-solid fa-desktop",
        time = 5000,
        soundFile = "notification-1.mp3",
        soundVolume = 50
    }
    TriggerClientEvent("vms_notifyv2:TopNotification", -1, notifyData)
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(data)
    local notifyInfo = times[data.secondsRemaining]
    if notifyInfo then
        local notifyData = {
            title = notifyInfo.title,
            description = notifyInfo.description,
            color = notifyInfo.color,
            icon = notifyInfo.icon,
            time = 5000,
            soundFile = "notification-1.mp3",
            soundVolume = 50
        }
        TriggerClientEvent("vms_notifyv2:TopNotification", -1, notifyData)
    end
end)
