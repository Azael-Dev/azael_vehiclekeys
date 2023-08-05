--===== FiveM Script =========================================
--= Vehicle Keys (Lock System)
--===== Developed By: ========================================
--= Azael Dev
--===== Website: =============================================
--= https://www.azael.dev
--===== License: =============================================
--= Copyright (C) Azael Dev - All Rights Reserved
--= You are not allowed to sell this script
--============================================================ 

CONFIG = {}

CONFIG.UseItem = {                                          -- ใช้งาน Item
    Distance = 20.0                                         -- ระยะห่างสูงสุด ที่สามารถใช้งาน Item ได้
}

CONFIG.UseKeyboard = {                                      -- ใช้งาน Keyboard
    ItemName = 'vehicle_key',                               -- ชื่อ Item ของ กุญแจยานพาหนะ
    Distance = 3.0,                                         -- ระยะห่างสูงสุด ที่สามารถใช้งาน Keyboard (ปุ่ม) ได้

    RegisterKey = {                                         -- RegisterKeyMapping (https://docs.fivem.net/natives/?_0xD7664FD1)
        CommandName = 'UseVehicleKey',                      -- ชื่อ คำสั่ง
        Description = 'Lock / Unlock Vehicle',              -- คำอธิบาย
        DefaultMapper = 'keyboard',                         -- Mapper เริ่มต้น
        DefaultParameter = 'U',                             -- Parameter เริ่มต้น (ปุ่มที่ต้องการใช้งาน)
    }
}
