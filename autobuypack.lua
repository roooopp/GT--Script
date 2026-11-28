-- ============================================================
-- AUTO BUY PACK (VIA GEMS) + DROP TO STORAGE
-- Lucifer Lua v2.86 | UTF-8
-- ============================================================

-- ============================================================
-- CONFIG (UBAH DI SINI)
-- ============================================================

local Config = {
    -- File hasil scan pack (format: Nama:store_id:harga:item_id)
    FilePackList  = "pack-result.txt",
    
    -- Nama pack yang mau dibeli (harus sama persis dengan yang ada di file)
    -- Contoh: "Small Lock"
    PackName      = "Small Lock", 

    -- Batas maksimal pembelian (0 = Unlimited / Tanpa batas)
    MaxPacks      = 20,      

    -- Auto Disconnect setelah target tercapai?
    -- true = Bot otomatis disconnect jika target selesai
    -- false = Bot diam (idle) menunggu di-stop manual
    AutoDisconnectOnFinish = true,

    -- World Storage tujuan drop item
    -- Format: "NAMAWORLD" atau bisa pakai Door ID
    StorageWorld  = "MYSTORAGE",
    StorageDoorId = "",      -- Kosongkan "" jika tidak pakai door ID

    -- Koordinat drop di world storage
    DropX         = 10,
    DropY         = 10,

    -- Delay antar siklus beli (detik)
    BuyIntervalSec = 3,
}

-- ============================================================
-- UTILITY
-- ============================================================

local bot = getBot()

local function log(msg)
    print("[AUTO-BUY] " .. msg)
end

local function countItem(id)
    local inv = bot:getInventory()
    return inv and inv:getItemCount(id) or 0
end

-- ============================================================
-- PARSING FILE PACK
-- ============================================================

local function getPackInfo(targetName)
    local content = read(Config.FilePackList)
    if not content or content == "" then
        log("File " .. Config.FilePackList .. " kosong atau tidak ditemukan!")
        return nil
    end

    -- Format di file: Nama:store_id:harga:item_id
    -- Contoh: Small Lock:small_lock:50:202
    for line in content:gmatch("[^\r\n]+") do
        local name, storeId, price, itemId = line:match("^([^:]+):([^:]+):(%d+):(%d+)")
        if name and name:lower() == targetName:lower() then
            return {
                name = name,
                storeId = storeId,        -- misal "small_lock"
                price = tonumber(price),  -- misal 50
                itemId = tonumber(itemId) -- misal 202
            }
        end
    end

    log("Pack dengan nama '" .. targetName .. "' tidak ditemukan di file!")
    return nil
end

-- ============================================================
-- NAVIGASI
-- ============================================================

local function warpTo(world, door)
    local target = world:upper()
    if bot:isInWorld(target) then return true end

    log("Warp ke " .. target .. "...")
    for i = 1, 3 do
        pcall(function()
            if door and door ~= "" then
                bot:warp(target, door)
            else
                bot:warp(target)
            end
        end)
        sleep(3000)
        if bot:isInWorld(target) then return true end
    end
    return false
end

-- ============================================================
-- MAIN LOGIC
-- ============================================================

local function startAutoBuy()
    log("Memulai Auto Buy Pack...")

    -- 1. Ambil info pack dari file
    local pack = getPackInfo(Config.PackName)
    if not pack then return end

    log(string.format("Target: %s | Store ID: %s | Harga: %d Gems | Item ID: %d", 
        pack.name, pack.storeId, pack.price, pack.itemId))
    
    if Config.MaxPacks > 0 then
        log("Batas pembelian: " .. Config.MaxPacks .. " packs.")
    else
        log("Batas pembelian: UNLIMITED.")
    end

    local totalBought = 0

    while true do
        -- CEK BATAS PEMBELIAN
        if Config.MaxPacks > 0 and totalBought >= Config.MaxPacks then
            log("========================================")
            log("BATAS PEMBELIAN TERCAPAI! (" .. totalBought .. "/" .. Config.MaxPacks .. ")")
            log("========================================")
            
            if Config.AutoDisconnectOnFinish then
                log("Auto-Disconnect aktif. Memutus koneksi bot...")
                sleep(1000)
                pcall(function() bot:disconnect() end)
            else
                log("Script selesai. Bot diam (idle). Silakan stop manual.")
            end
            break -- Keluar dari loop
        end

        -- Pastikan bot online
        if bot.status ~= BotStatus.online then
            log("Bot offline, menunggu...")
            sleep(3000)
            goto continue
        end

        -- Cek Gems cukup atau tidak
        if bot.gem_count < pack.price then
            log("Gems tidak cukup! (Punya: " .. bot.gem_count .. ", Butuh: " .. pack.price .. ")")
            sleep(10000)
            goto continue
        end

        -- Beli pack menggunakan store_id
        log("Membeli " .. pack.name .. "... (" .. (totalBought + 1) .. "/" .. (Config.MaxPacks > 0 and Config.MaxPacks or "∞") .. ")")
        
        -- Berdasarkan API v2.86: bot:buy(store_id) -> Buys using a store identifier
        pcall(function() bot:buy(pack.storeId) end)
        sleep(2000) -- tunggu server memproses pembelian

        -- Cek apakah item berhasil masuk tas
        local boughtCount = countItem(pack.itemId)
        if boughtCount > 0 then
            log("Berhasil beli! Di tas ada " .. boughtCount .. " " .. pack.name)
            
            -- Tambah counter
            totalBought = totalBought + 1

            -- Pergi ke Storage untuk drop
            if warpTo(Config.StorageWorld, Config.StorageDoorId) then
                log("Sampai di storage, jalan ke koordinat drop (" .. Config.DropX .. "," .. Config.DropY .. ")")
                bot:findPath(Config.DropX, Config.DropY)
                sleep(1000)

                log("Membuang " .. boughtCount .. " item...")
                pcall(function() bot:drop(pack.itemId, boughtCount) end)
                sleep(1500)
            else
                log("Gagal warp ke storage! Item akan di-drop di tempat lain setelah dicoba lagi.")
            end
        else
            log("Pembelian gagal atau item tidak terdeteksi. Mungkin store_id salah atau stok habis.")
            sleep(5000)
        end

        -- Jeda sebelum siklus berikutnya
        sleep(Config.BuyIntervalSec * 1000)
        
        ::continue::
    end
end

-- ============================================================
-- STARTUP
-- ============================================================

local ok, err = pcall(startAutoBuy)
if not ok then
    log("FATAL ERROR: " .. tostring(err))
end
