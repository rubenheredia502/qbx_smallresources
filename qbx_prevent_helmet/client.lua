lib.onCache('ped', function(value)
    if value then
        SetPedConfigFlag(value, 35, false)
    end
end)