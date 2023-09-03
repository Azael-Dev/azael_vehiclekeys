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

CONFIG.SwapItems = {                                        -- ย้าย Item กุญแจยานพาหนะ
    Drop = {                                                -- ทิ้ง Item
        Enable = false                                      -- เปิดใช้งาน ทิ้ง Item (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)
    },

    Give = {                                                -- ส่ง Item
        Enable = true,                                      -- เปิดใช้งาน ส่ง Item (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)

        Transfer = {                                        -- โอนยานพาหนะ เมื่อส่ง Item
            Enable = true                                   -- เปิดใช้งาน โอนยานพาหนะ (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)
        }
    },
    
    Search = {                                              -- ยึด/ยัด Item
        Citizen = {                                         -- ประชาชน
            Enable = true,                                  -- เปิดใช้งาน ยึด/ยัด Item (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)

            Transfer = {                                    -- โอนยานพาหนะ เมื่อยึด/ยัด Item
                Enable = true                               -- เปิดใช้งาน โอนยานพาหนะ (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)
            }
        },
        
        Government = {                                      -- หน่วยงานรัฐ
            Enable = true,                                  -- เปิดใช้งาน ยึด/ยัด Item (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)

            Transfer = {                                    -- โอนยานพาหนะ เมื่อยึด/ยัด Item
                Enable = true                               -- เปิดใช้งาน โอนยานพาหนะ (true เท่ากับ เปิดใช้งาน | false เท่ากับ ปิดใช้งาน)
            },
            
            Jobs = {                                        -- หน่วยงาน
                'police',                                   -- ตำรวจ
                'council'                                   -- สภา
            }
        }
    }
}
