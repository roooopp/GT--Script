-- ============================================================
-- AUTO SCAN FARM - MULTIBOT (ZCScript x Webhook Version)
-- Lucifer Lua v2.86 | UTF-8
-- ============================================================

-- ============================================================
-- ⚡ QUICK CONFIG (EDIT DI SINI)
-- ============================================================

local Config = {
    -- 1. SUMBER DATA WORLD
    InputType = "file", -- "table" ATAU "file"
    WorldFile = "scan_worlds.txt", 
    WorldList = {          -- Isi daftar world di sini jika pakai "table"
        -- "WORLD1|DOORID", "WORLD2|DOORID"
    },

    -- 2. TARGET SCAN
    -- Isi ID Seed jika ingin menghitung jumlah pohon spesifik (misal: 4585 = Pepper)
    -- Kosongkan (0) jika hanya ingin mengecek status world & menghitung SEMUA pohon
    SeedId = 0, 

    -- 3. WEBHOOK DISCORD
    WebhookURL = "",       -- Isi URL Webhook Discord (kosongkan jika tidak mau)

    -- 4. TIMING & LAIN-LAIN
    DelayWarp = 7.5,       -- Detik tunggu saat warp
    DelayReconnect = 15,   -- Detik tunggu saat reconnect
    AutoDisconnectOnFinish = true, 
    
    -- Output File (Mengikuti format ZCScript)
    FileSafe = "SafeReal.txt",
    FileNuked = "NukedReal.txt",
    FileWrong = "WrongReal.txt",
}

-- ============================================================
-- ❌ JANGAN DIUBAH (CORE SYSTEM)
-- ============================================================

local bot = getBot()
local FileQueue = "scan_queue.txt"
local FileLock  = "scan.lock"

-- State Global
local Stats = {
    Total = 0, Valid = 0, Nuked = 0, Wrong = 0, 
    TreesReady = 0
}
local nuked = false
local wrongId = false

-- Konstanta
local ID_WHITE_DOOR = 6

-- ============================================================
-- EVENT LISTENER (Deteksi Nuked ala ZCScript)
-- ============================================================

addEvent(Event.variantlist, function(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        local message = variant:get(1):getString()
        if message:find("That world is inaccessible") then 
            nuked = true
        end
    end
end)

-- ============================================================
-- UTILITY & FILE I/O
-- ============================================================

local function log(msg)
    print("[SCAN] " .. tostring(msg))
end

local function dataRead(path) return read(path) or "" end
local function dataWrite(path, content) return write(path, content) end
local function dataAppend(path, content) return append(path, content) end

-- Fungsi Tulis File (mengikuti format ZCScript)
local FileWritten = {}
local function writeResult(fileType, text)
    local filename = Config.FileSafe
    if fileType == "nuked" then filename = Config.FileNuked
    elseif fileType == "wrong" then filename = Config.FileWrong end

    -- Jika belum pernah nulis di sesi ini, timpa (write). Jika sudah, tambah (append).
    if not FileWritten[fileType] then
        FileWritten[fileType] = true
        return dataWrite(filename, text)
    else
        return dataAppend(filename, text)
    end
end

-- ============================================================
-- QUEUE MANAGER (ANTRIAN MULTIBOT)
-- ============================================================

local Queue = {}

function Queue.lock()
    local me = removeColor(bot.name):upper()
    for _ = 1, 50 do
        local raw = dataRead(FileLock)
        local holder, t = raw:match("^([^|]*)|(%d+)")
        t = tonumber(t) or 0
        if not holder or holder == "" or holder == me or os.time() - t > 10 then
            dataWrite(FileLock, me .. "|" .. tostring(os.time()))
            sleep(150)
            if dataRead(FileLock):match("^([^|]*)|") == me then return true end
        end
        sleep(200)
    end
    return false
end

function Queue.unlock()
    local me = removeColor(bot.name):upper()
    if dataRead(FileLock):match("^([^|]*)|") == me then dataWrite(FileLock, "") end
end

function Queue.getNext()
    if not Queue.lock() then return nil end
    
    local me = removeColor(bot.name):upper()
    local lines = {}
    for line in dataRead(FileQueue):gmatch("[^\r\n]+") do table.insert(lines, line) end
    
    local chosen = nil
    local newLines = {}
    
    for _, line in ipairs(lines) do
        local world, door, assignTo, status = line:match("^([^|]*)|([^|]*)|([^|]*)|([^|]*)$")
        if world then
            if status == "done" then
                -- skip
            elseif assignTo == me and status == "working" then
                chosen = { world = world, door = door }
                table.insert(newLines, line)
            elseif assignTo == "" or assignTo == nil then
                if not chosen then
                    chosen = { world = world, door = door }
                    table.insert(newLines, world .. "|" .. (door or "") .. "|" .. me .. "|working")
                else
                    table.insert(newLines, line)
                end
            else
                table.insert(newLines, line)
            end
        end
    end
    
    dataWrite(FileQueue, table.concat(newLines, "\n") .. (#newLines > 0 and "\n" or ""))
    Queue.unlock()
    return chosen and chosen.world, chosen and chosen.door
end

function Queue.markDone(world)
    if not Queue.lock() then return end
    local lines = {}
    for line in dataRead(FileQueue):gmatch("[^\r\n]+") do
        local w, d, b, s = line:match("^([^|]*)|([^|]*)|([^|]*)|([^|]*)$")
        if w == world then
            table.insert(lines, w .. "|" .. (d or "") .. "|" .. (b or "") .. "|done")
        else
            table.insert(lines, line)
        end
    end
    dataWrite(FileQueue, table.concat(lines, "\n") .. (#lines > 0 and "\n" or ""))
    Queue.unlock()
end

local function initQueue()
    if dataRead(FileQueue) ~= "" then return end 
    local list = {}
    if Config.InputType == "table" then
        for _, v in ipairs(Config.WorldList) do table.insert(list, v) end
    else
        for line in dataRead(Config.WorldFile):gmatch("[^\r\n]+") do
            if line ~= "" then table.insert(list, line) end
        end
    end

    local lines = {}
    for _, v in ipairs(list) do
        local world, door = v:match("^([^:|]+)[:|]?(.*)$")
        if world then
            table.insert(lines, world:upper() .. "|" .. (door or "") .. "||")
        end
    end
    dataWrite(FileQueue, table.concat(lines, "\n") .. "\n")
    Stats.Total = #lines
    log("Queue diinisialisasi: " .. #lines .. " world.")
end

-- ============================================================
-- WEBHOOK MANAGER
-- ============================================================

local lastWebhookTime = 0

local function escapeJson(s)
    s = tostring(s or "")
    s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "")
    return s
end

local function sendWebhook(title, desc, color, fields)
    if Config.WebhookURL == "" then return end
    if title == "PROGRESS" and os.time() - lastWebhookTime < 10 then return end
    lastWebhookTime = os.time()

    local fieldJson = {}
    if fields then
        for _, f in ipairs(fields) do
            table.insert(fieldJson, string.format('{"name":"%s","value":"%s","inline":%s}', 
                escapeJson(f[1]), escapeJson(f[2]), tostring(f[3] or true)))
        end
    end

    local payload = string.format([[
    {"username": "Scanner - %s", "embeds": [{"title": "%s", "description": "%s", "color": %d, "fields": [%s], "footer": {"text": "Auto Scan | %s"}}]}
    ]], removeColor(bot.name), escapeJson(title), escapeJson(desc), color or 3447003, table.concat(fieldJson, ","), os.date("%H:%M:%S"))

    pcall(function()
        local client = HttpClient.new()
        client.url = Config.WebhookURL
        client:setMethod(Method.post)
        client.headers["Content-Type"] = "application/json"
        client.content = payload
        client:request()
    end)
end

local function updateDashboard()
    sendWebhook("PROGRESS", "Memindai world...", 3447003, {
        {"Total World", tostring(Stats.Total), true},
        {"Valid Farm", tostring(Stats.Valid), true},
        {"Nuked", tostring(Stats.Nuked), true},
        {"Wrong ID", tostring(Stats.Wrong), true},
        {"Trees Counted", tostring(Stats.TreesReady), true}
    })
end

-- ============================================================
-- CORE SCANNER (LOGIKA ZCSCRIPT)
-- ============================================================

local function reconnect()
    if bot.status ~= BotStatus.online then 
        log("Mencoba reconnect...")
        while bot.status ~= BotStatus.online do 
            pcall(function() bot:connect() end)
            sleep(Config.DelayReconnect * 1000)
            if bot.status == BotStatus.account_banned then 
                log("AKUN KENA BAN! Menghentikan script.")
                pcall(function() bot:stopScript() end)
                return
            end
        end 
        log("Berhasil reconnect!")
    end
end

local function scanWorld(worldName, doorId)
    nuked, wrongId = false, false
    local world = bot:getWorld()
    local targetWorld = worldName:upper()
    local hw = 0

    log("Memproses: " .. targetWorld .. (doorId ~= "" and " | " .. doorId or ""))

    -- 1. LOGIKA WARP (ZCScript)
    while world.name ~= targetWorld and not nuked do 
        if doorId and doorId ~= "" then bot:warp(targetWorld, doorId) 
        else bot:warp(targetWorld) end 
        
        -- Tunggu respon server (listenEvents menangkap pesan Nuked)
        listenEvents(math.floor(Config.DelayWarp))
        
        if hw >= 3 then 
            if world.name ~= targetWorld then 
                log("Warp gagal berulang, hard reconnect...")
                pcall(function() bot:disconnect() end)
                sleep(Config.DelayReconnect * 1000)
            end 
            hw = 0 
        else hw = hw + 1 end 
        
        reconnect()
        world = bot:getWorld()
    end 

    -- 2. CEK WRONG DOOR ID (ZCScript)
    if doorId and doorId ~= "" and not nuked then 
        local doorTries = 0
        -- Pastikan world dan tile aman sebelum diakses
        if world and world:getTile(bot.x, bot.y) then
            while world:getTile(bot.x, bot.y).fg == ID_WHITE_DOOR and not nuked and not wrongId do 
                bot:warp(targetWorld, doorId)
                listenEvents(math.floor(Config.DelayWarp))
                
                if doorTries >= 4 then
                    if world:getTile(bot.x, bot.y) and world:getTile(bot.x, bot.y).fg == ID_WHITE_DOOR then
                        wrongId = true 
                    end 
                    doorTries = 0 
                else doorTries = doorTries + 1 end 
                
                reconnect()
                world = bot:getWorld()
            end 
        end
    end 

    -- 3. SCAN & KATEGORISASI
    if nuked then
        Stats.Nuked = Stats.Nuked + 1
        writeResult("nuked", '"'..targetWorld..(doorId~="" and "|"..doorId or "")..'",\n')
        log(targetWorld .. " is NUKED!")
    elseif wrongId then
        Stats.Wrong = Stats.Wrong + 1
        writeResult("wrong", '"'..targetWorld..(doorId~="" and "|"..doorId or "")..'",\n')
        log(targetWorld .. " got WRONG ID!")
    else
        -- Hitung pohon
        local count = 0
        if world and world:getTiles() then
            for _, tile in pairs(world:getTiles()) do 
                -- Jika SeedId diisi (> 0), hitung seed spesifik.
                -- Jika kosong (0), hitung semua pohon (ID ganjil).
                local isTargetSeed = false
                if Config.SeedId and Config.SeedId > 0 then
                    isTargetSeed = (tile.fg == Config.SeedId)
                else
                    isTargetSeed = (tile.fg > 0 and tile.fg % 2 == 1)
                end

                if isTargetSeed and world:hasAccess(tile.x, tile.y) > 0 then 
                    count = count + 1 
                end 
            end 
        end
        
        Stats.Valid = Stats.Valid + 1
        Stats.TreesReady = Stats.TreesReady + count
        
        local textWorld = (doorId ~= "") and targetWorld.."|"..doorId or targetWorld
        writeResult("safe", '"'..textWorld..' ['..count..']",\n')
        log(targetWorld .. " is SAFE! (Trees: " .. count .. ")")
    end

    Queue.markDone(targetWorld)
    updateDashboard()
end

-- ============================================================
-- MAIN WORKER LOOP
-- ============================================================

local function startScanning()
    initQueue()
    log("Memulai Scan Multi-Bot...")

    while true do
        if bot.status ~= BotStatus.online then
            reconnect()
            goto continue
        end

        local nextWorld, nextDoor = Queue.getNext()
        if nextWorld then
            scanWorld(nextWorld, nextDoor)
        else
            local waiting = false
            for line in dataRead(FileQueue):gmatch("[^\r\n]+") do
                if line:match("|working$") then waiting = true; break end
            end
            
            if not waiting then
                log("Semua world telah selesai dipindai!")
                sendWebhook("FINISHED", "Semua world telah selesai dipindai.", 3066993, {
                    {"Total Valid", tostring(Stats.Valid), true},
                    {"Total Nuked", tostring(Stats.Nuked), true},
                    {"Total Wrong ID", tostring(Stats.Wrong), true},
                    {"Trees Counted", tostring(Stats.TreesReady), true}
                })
                
                if Config.AutoDisconnectOnFinish then
                    log("Auto-Disconnect aktif. Memutus koneksi bot...")
                    pcall(function() bot:disconnect() end)
                end
                break
            end
            
            log("Menunggu bot lain menyelesaikan world...")
            sleep(5000)
        end
        ::continue::
    end
end

-- ============================================================
-- STARTUP
-- ============================================================

local ok, err = pcall(startScanning)
if not ok then
    log("FATAL ERROR: " .. tostring(err))
end
