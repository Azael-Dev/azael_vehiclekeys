# azael_vehiclekeys
FiveM - Vehicle Keys (Lock System)

## ความต้องการ
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)

## ดาวน์โหลด

### ใช้ Git
```
cd resources
git clone https://github.com/Azael-Dev/azael_vehiclekeys [local]/[azael]/[system]/azael_vehiclekeys
```

### ด้วยตนเอง
- ดาวน์โหลด https://github.com/Azael-Dev/azael_vehiclekeys/archive/refs/heads/main.zip
- แก้ไข `azael_vehiclekeys-main` เป็น `azael_vehiclekeys`
- วางไว้ใน `[local]/[azael]/[system]`

## ติดตั้ง

- สามารถตรวจสอบการกำหนดค่าเพิ่มเติมได้ที่ [client.config.js](https://github.com/Azael-Dev/azael_vehiclekeys/blob/main/client.config.lua)

### server.cfg

- เพิ่มสิ่งนี้ไปยัง `server.cfg` ด้านล่าง `ox_lib`, `ox_inventory`

```
ensure azael_vehiclekeys
```

### ox_inventory

- ไปยัง `ox_inventory/data/items.lua` และดำเนินการเพิ่มรหัสด้านล่างนี้

```lua
["vehicle_key"] = {
    label = "Vehicle Key",
    description = "Vehicle Key",
    weight = 500,
    stack = false,
    close = true,
    consume = 0,
    client = {
        image = "keys.png",
        export = 'azael_vehiclekeys.useItem',
    }
},
```

## ตัวอย่าง

- อ้างอิงจาก [esx_vehicleshop](https://github.com/esx-framework/esx_vehicleshop) เวอร์ชันล่าสุด

### เพิ่มกุญแจเมื่อซื้อยานพาหนะ

- ไปที่ `esx_vehicleshop/server/main.lua` ค้นหา `TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)` ([#166](https://github.com/esx-framework/esx_vehicleshop/blob/main/server/main.lua#L166)) และวางรหัสด้านล่างนี้ต่อ

```lua
pcall(function()
    local vehicle = getVehicleFromModel(model)

    exports.ox_inventory:AddItem(xPlayer.source, 'vehicle_key', 1, { plate = plate, description = ('Type: %s  \nName: %s  \nPlate: %s'):format(vehicle.categoryLabel, vehicle.name, plate) })
end)
```

- ต้องระบุ `plate` ของยานพาหนะใน `metadata` ทุกครั้ง เมื่อมีการเพิ่มกุญแจยานพาหนะไปยังกระเป๋า (**Docs:** [ox_inventory:AddItem](https://overextended.dev/ox_inventory/Functions/Server#additem))

### ลบกุญแจเมื่อขายยานพาหนะ

- ไปที่ `esx_vehicleshop/server/main.lua` ค้นหา `xPlayer.addMoney(resellPrice, "Sold Vehicle")` และวางรหัสด้านล่างนี้ต่อจาก `RemoveOwnedVehicle(plate)` ([#309](https://github.com/esx-framework/esx_vehicleshop/blob/main/server/main.lua#L309))

```lua
pcall(function()
    local slotId = exports.ox_inventory:GetSlotIdWithItem(xPlayer.source, 'vehicle_key', { plate = plate }, false)

    if slotId then
        exports.ox_inventory:RemoveItem(xPlayer.source, 'vehicle_key', 1, nil, slotId)
    end
end)
```

## เครดิต
- [AZAEL](https://discord.gg/Ca5W62f)

## กฎหมาย
### ใบอนุญาต

ลิขสิทธิ์ (C) Azael Dev - สงวนลิขสิทธิ์

- ห้ามใช้ชิ้นส่วนใดๆ ของซอฟต์แวร์นี้ในผลิตภัณฑ์ / บริการเชิงพาณิชย์
- ห้ามนำซอฟต์แวร์นี้ไปขายต่อ
- คุณจะต้องไม่จัดหาสิ่งอำนวยความสะดวกใด ๆ ในการติดตั้งซอฟต์แวร์นี้ในผลิตภัณฑ์ / บริการเชิงพาณิชย์
- หากคุณแจกจ่ายซอฟต์แวร์นี้ใหม่ คุณต้องเชื่อมโยงไปยังที่เก็บดั้งเดิมที่ [azael_vehiclekeys](https://github.com/Azael-Dev/azael_vehiclekeys)
- ลิขสิทธิ์นี้ควรปรากฏในทุกส่วนของรหัสโครงการ

License (ENG): https://github.com/Azael-Dev/azael_vehiclekeys/blob/main/LICENSE
