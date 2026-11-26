-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   RAPS AUTO PLANT - MULTIBOT                                             ║
-- ║   Lucifer Lua v2.86 | UTF-8                                              ║
-- ║   >>> EDIT QUICK CONFIG SAJA <<<                                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ⚡ QUICK CONFIG — EDIT DI SINI                                          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local QuickConfig = {
    -- ═══ 1. WEBHOOK DISCORD (isi minimal 1) ═══
    MainWebhook   = "",   -- dashboard live per bot
    NotifWebhook  = "",   -- alert: ban, disconnect, storage kosong
    ResultWebhook = "",   -- report world selesai

    -- ═══ 2. SEED STORAGE (wajib untuk refill) ═══
    -- Format: "NAMAWORLD|DOORID" atau "NAMAWORLD:DOORID"
    SeedStorages = {
        -- "SEEDSTORE1|DOOR1",
        -- "SEEDSTORE2|DOOR2",
    },

    -- ═══ 3. WORLD LIST ═══
    WorldFile    = "plant_worlds.txt",   -- file: NAMA:DOOR per baris
    BotsPerWorld = 2,                     -- 2 bot: 1 atas-kiri, 1 bawah-kanan

    -- ═══ 4. SEED ═══
    AutoDetectSeed = true,   -- true = auto deteksi dari tas
    SeedId         = 0,      -- isi kalau AutoDetectSeed = false

    -- ═══ 5. FITUR ON/OFF ═══
    AutoCollect     = true,
    AvoidFireWorlds = true,
    CleanToxicWaste = true,
    AutoSwitchProxy = true,
    ReturnLeftover  = true,
}


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ⚠️ ADVANCED CONFIG — jarang perlu diubah                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Config = {
    -- PLANTING
    PlantDelayMs    = 120,
    HitDelayMs      = 160,
    CheckTileBefore = true,
    RetryRefused    = true,
    MaxRetryPerTile = 3,
    MaxRefillCount  = 5,

    -- AUTO COLLECT
    CollectRange    = 3,
    CollectInterval = 60,
    IgnoreGems      = false,
    IgnoreEssences  = false,

    -- WORLD QUEUE
    WorldQueueFile    = "plant_queue.txt",
    WorldDoneFile     = "plant_done.txt",
    WorldFailFile     = "plant_failed.txt",
    WorldNukeFile     = "plant_nuked.txt",
    pendingTimeoutMin = 10,

    -- STORAGE
    SeedFullAt      = 200,
    SeedTakeAmount  = 200,

    -- CONNECTION
    DynamicDelay     = true,
    ReEnterIfStuck   = true,
    MaxStuckSec      = 15,
    ReconnectWaitSec = 15,

    -- MULTI-BOT COORDINATION
    PartnerTimeoutSec = 180,   -- tunggu partner max 3 menit
    MaxSweeps         = 5,     -- max sweep ulang

    -- WEBHOOK
    webhookRefreshSec   = 10,
    timezoneOffsetHours = 7,
    timezoneLabel       = "WIB",

    -- FILES
    FileBotStats    = "plant_bot_stats.txt",
    FileActiveWorld = "plant_active_world.txt",
    FileWebhookMsg  = "plant_webhook_msg.txt",
    FileLog         = "plant_log.txt",
    FileQueueLock   = "plant_queue.lock",
}

for k, v in pairs(QuickConfig) do Config[k] = v end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ⚠️ HATI-HATI — EMOTE & THUMBNAIL                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

Config.Emoji = {
    online   = "<a:online:1238169279900418180>",
    offline  = "<a:offline:1238169277895278733>",
    alert    = "<a:AttentionAnimated:1191701337071685673>",
    warn     = "<a:alert:1380172534946725938>",
    done     = "<a:Verified:1507378662104764436>",
    bot      = "<a:bot:1445681649726521395>",
    world    = "<a:World:1095730627103441086>",
    seed     = "<a:Sprout:1521529181870231783>",
    time     = "<a:HourglassNotDone:1494430051738062858>",
    ping     = "<a:latency:1186908877783056384>",
    storage  = "<a:Package:1060579117625520228>",
    tree     = "<a:Tree:1234567890123456789>",
    door     = "<a:door:1496121926094033057>",
}

Config.Thumbnail = {
    monitor = "https://cdn.discordapp.com/emojis/958670636434219018.gif",
    alert   = "https://cdn.discordapp.com/emojis/981898314423341116.gif",
    result  = "https://cdn.discordapp.com/emojis/993775478798307368.gif",
}

Config.WebhookProfile = {
    monitor = { name = "{bot} • Plant Monitor", avatar = "https://cdn.discordapp.com/emojis/958670636434219018.png" },
    notif   = { name = "{bot} • Plant Notif",   avatar = "https://cdn.discordapp.com/emojis/981898314423341116.png" },
    result  = { name = "{bot} • Plant Result",  avatar = "https://cdn.discordapp.com/emojis/993775478798307368.png" },
}


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ JANGAN DIUBAH — ID ITEM & CONSTANTS                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local ITEM_WHITE_DOOR    = 6
local ITEM_BEDROCK       = 8
local ITEM_DOOR          = 12
local ITEM_PLATFORM      = 102
local ITEM_ENTRANCE      = 224
local ITEM_SIGNAL_JAMMER = 226

Config.ToxicWasteIds = { 5024, 5026, 5028, 5030, 5032, 5034, 5036, 5038, 5040, 5042, 5044 }

local UNBREAKABLE = {
    [ITEM_WHITE_DOOR]    = true,
    [ITEM_BEDROCK]       = true,
    [ITEM_SIGNAL_JAMMER] = true,
    [ITEM_ENTRANCE]      = true,
}

local PASSABLE = {
    [ITEM_WHITE_DOOR] = true,
    [ITEM_DOOR]       = true,
    [ITEM_ENTRANCE]   = true,
    [ITEM_PLATFORM]   = true,
}


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ JANGAN DIUBAH — STATE GLOBAL                                        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local BotRngState          = {}
local BotRuntimeData       = {}
local CurrentWorkerBot     = nil
local liveWebhookTick      = nil
local staleMsSinceCheck    = 0
local StorageLockHeartbeat = nil
local ProxyManagerCache    = nil
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ JANGAN DIUBAH — CORE UTIL                                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════
-- SLEEP (custom, biar webhook tetap jalan saat loop panjang)
-- ═══════════════════════════════════════════════════════
local luciferSleep = sleep
local function sleep(ms)
    local remaining = tonumber(ms) or 0
    repeat
        local step = math.min(remaining, 200)
        if step > 0 then luciferSleep(step) end
        remaining = remaining - step
        staleMsSinceCheck = staleMsSinceCheck + math.max(step, 1)
        if liveWebhookTick ~= nil and staleMsSinceCheck >= 1000 then
            staleMsSinceCheck = 0
            pcall(liveWebhookTick)
        end
    until remaining <= 0
end

-- ═══════════════════════════════════════════════════════
-- SAFE WRAPPER
-- ═══════════════════════════════════════════════════════
local function Try(fn)
    local ok, value = pcall(fn)
    if ok then return value end
end

local function removeColorSafe(t)
    if type(t) ~= "string" then return "" end
    return removeColor(t)
end

-- ═══════════════════════════════════════════════════════
-- INVENTORY & WORLD QUERY
-- ═══════════════════════════════════════════════════════
local function Count(id)
    return Try(function() return getInventory():getItemCount(id) end) or 0
end

local function CurrentWorld()
    return string.upper(tostring(Try(function() return getWorld().name end) or ""))
end

local function GetTile(x, y)
    local t = getTile(x, y)
    return t and t.fg or -1
end

local function GetBg(x, y)
    local t = getTile(x, y)
    return t and t.bg or -1
end

local function Pos()
    local me = getLocal()
    if not me then return 0, 0 end
    return math.floor(me.posx / 32), math.floor(me.posy / 32)
end

local function InBounds(x, y)
    return x >= 0 and x <= 99 and y >= 0 and y <= 59
end

-- ═══════════════════════════════════════════════════════
-- RNG PER BOT (deterministik, biar bot tidak barengan gerak)
-- ═══════════════════════════════════════════════════════
local function getNextBotRandom(bot, minVal, maxVal)
    local key = removeColorSafe(bot.name):upper()
    if BotRngState[key] == nil then
        local hash = 2166136261
        for i = 1, #key do
            hash = (hash * 16777619 + key:byte(i) * (i * 97)) % 2147483647
        end
        BotRngState[key] = hash % 2147483647
        if BotRngState[key] <= 0 then BotRngState[key] = 123456789 end
    end
    BotRngState[key] = (BotRngState[key] * 1103515245 + 12345) % 2147483648
    local span = (maxVal - minVal) + 1
    if span <= 1 then return minVal end
    return minVal + (BotRngState[key] % span)
end

-- ═══════════════════════════════════════════════════════
-- FILE I/O PER BOT (biar tidak tabrakan antar bot)
-- ═══════════════════════════════════════════════════════
local function perBotFilePath(baseFile, keyName)
    local cleanKey = removeColorSafe(keyName):upper():gsub("[^%w_%-]", "_")
    local stem = baseFile:gsub("%.txt$", "")
    return stem .. "_" .. cleanKey .. ".txt"
end

local function dataRead(fileName)
    return read(fileName) or ""
end

local function dataWrite(fileName, content)
    return write(fileName, content)
end

local function dataAppend(fileName, content)
    return append(fileName, content)
end

local function getKeyValueFromFile(filePath, keyName)
    local fileName = perBotFilePath(filePath, keyName)
    local raw = (dataRead(fileName) or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if raw == "-" or raw == "" then return nil end
    return raw
end

local function setKeyValueInFile(filePath, keyName, valStr)
    local value = (valStr ~= nil and tostring(valStr) ~= "") and tostring(valStr) or "-"
    dataWrite(perBotFilePath(filePath, keyName), value)
end

-- ═══════════════════════════════════════════════════════
-- DATE & FORMAT
-- ═══════════════════════════════════════════════════════
local function localDate(fmt, t)
    local offset = math.floor((tonumber(Config.timezoneOffsetHours) or 7) * 3600)
    return os.date("!" .. fmt, (t or os.time()) + offset)
end

local function formatDuration(sec)
    sec = math.max(0, math.floor(sec or 0))
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then return string.format("%dj %02dm", h, m) end
    return string.format("%dm %02ds", m, s)
end

-- ═══════════════════════════════════════════════════════
-- EMOJI & JSON (safe, emoji UTF-8 aman)
-- ═══════════════════════════════════════════════════════
local function emo(key)
    return (Config.Emoji or {})[key] or ""
end

local function jsonEscape(s)
    s = tostring(s or "")
    s = s:gsub("\\", "\\\\")
    s = s:gsub('"', '\\"')
    s = s:gsub("\r", "")
    s = s:gsub("\n", "\\n")
    s = s:gsub("\t", "\\t")
    s = s:gsub("[\1-\31]", "")
    return s
end

local function jsonStr(s)
    return '"' .. jsonEscape(s) .. '"'
end

local function clip(s, maxLen)
    s = tostring(s or "")
    if #s > maxLen then return s:sub(1, maxLen - 3) .. "..." end
    return s
end

-- ═══════════════════════════════════════════════════════
-- PARSER
-- ═══════════════════════════════════════════════════════
local function parseWorldEntry(line)
    local clean = (line or ""):gsub("%s+", "")
    if clean == "" then return nil end
    local name, door = clean:match("^([^:|]+)[:|]?(.*)$")
    if name and name ~= "" then return string.upper(name), door or "" end
end

-- ═══════════════════════════════════════════════════════
-- STATUS CHECK
-- ═══════════════════════════════════════════════════════
local function isConnected(st)
    return st == BotStatus.online or st == BotStatus.player_entered
        or st == BotStatus.high_ping or st == BotStatus.high_load
end

local function isBanned(st)
    return st == BotStatus.account_banned or st == BotStatus.account_suspended
        or st == BotStatus.location_banned
end

-- ═══════════════════════════════════════════════════════
-- BOT RUNTIME DATA
-- ═══════════════════════════════════════════════════════
local function getOrInitBotData(bot)
    local key = removeColorSafe(bot.name):upper()
    if BotRuntimeData[key] == nil then
        BotRuntimeData[key] = {
            activeWorld    = getKeyValueFromFile(Config.FileActiveWorld, bot.name) or "-",
            activity       = "Inisialisasi...",
            lastHookTime   = 0,
            msgId          = nil,
            oldMsgId       = getKeyValueFromFile(Config.FileWebhookMsg, bot.name),
            hookFails      = 0,
            startTime      = os.time(),
            worldStart     = nil,
            worldStartWorld = nil,
            seedsPlanted   = 0,
            treesPlanted   = 0,
            lastPlantTime  = 0,
            stuckSince     = nil,
            stuckCheckX    = 0,
            stuckCheckY    = 0,
            backpackLoaded = false,
            worldsDone     = 0,
            worldsFailed   = 0,
            disconnectReported = false,
            banReported    = false,
        }
    end
    return BotRuntimeData[key]
end

local function setBotActivity(bot, activityText, targetWorld)
    local data = getOrInitBotData(bot)
    data.activity = activityText
    if targetWorld ~= nil then
        data.activeWorld = targetWorld
        setKeyValueInFile(Config.FileActiveWorld, bot.name, targetWorld)
    end
    pcall(function() bot.custom_status = activityText end)
end

local function devLog(bot, title, text)
    dataAppend(perBotFilePath("plant_dev_log.txt", bot and bot.name or "-"),
        localDate("%Y-%m-%d %H:%M:%S") .. "  " .. tostring(title) .. " | " .. tostring(text) .. "\n")
end

local function addHistory(msg)
    dataAppend(Config.FileLog, string.format("[%s] %s\n",
        localDate("%H:%M:%S"), tostring(msg)))
end

local function incWorldDone(bot)
    local data = getOrInitBotData(bot)
    data.worldsDone = (data.worldsDone or 0) + 1
end

local function incWorldFail(bot)
    local data = getOrInitBotData(bot)
    data.worldsFailed = (data.worldsFailed or 0) + 1
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 2 — CORE UTIL                                                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 6: WORLD QUEUE (MULTIBOT)                                    ║
-- ║   Sistem antrian world yang dipakai semua bot.                           ║
-- ║   File: plant_queue.txt (format: WORLD|DOOR|BOT|STAGE|TIME|ZONA)        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local WorldQueue = {}

-- ═══════════════════════════════════════════════════════
-- NAMA BOT UNIK
-- ═══════════════════════════════════════════════════════
function WorldQueue.me(bot)
    return removeColorSafe(bot.name):upper()
end

-- ═══════════════════════════════════════════════════════
-- LOCK FILE (biar tidak tabrakan saat tulis queue)
-- ═══════════════════════════════════════════════════════
function WorldQueue.lock(bot)
    local me = WorldQueue.me(bot)
    for _ = 1, 120 do
        local raw = dataRead(Config.FileQueueLock)
        local holder, t = raw:match("^([^|]*)|(%d+)")
        t = tonumber(t) or 0
        if holder == nil or holder == "" or holder == me or (os.time() - t) > 20 then
            dataWrite(Config.FileQueueLock, me .. "|" .. tostring(os.time()))
            sleep(250 + getNextBotRandom(bot, 0, 250))
            local check = dataRead(Config.FileQueueLock):match("^([^|]*)|")
            if check == me then return true end
        end
        sleep(400 + getNextBotRandom(bot, 0, 400))
    end
    return false
end

function WorldQueue.unlock(bot)
    if dataRead(Config.FileQueueLock):match("^([^|]*)|") == WorldQueue.me(bot) then
        dataWrite(Config.FileQueueLock, "")
    end
end

-- ═══════════════════════════════════════════════════════
-- CEK BOT DOWN (untuk ambil alih world)
-- ═══════════════════════════════════════════════════════
function WorldQueue.botDown(name)
    if name == nil or name == "" then return false end
    local ok, b = pcall(getBot, name)
    if not ok or b == nil then return true end
    local st = b.status
    return isBanned(st) or st == BotStatus.offline or st == BotStatus.stopped
end

-- ═══════════════════════════════════════════════════════
-- PARSE BARIS QUEUE
-- Format: WORLD|DOOR|BOT|STAGE|TIME|ZONA
-- ═══════════════════════════════════════════════════════
local function parseQueueLine(line)
    local p = {}
    for part in (line .. "|"):gmatch("([^|]*)|") do p[#p + 1] = part end
    if p[1] == nil or p[1] == "" then return nil end
    return {
        world = p[1]:upper(),
        door  = p[2] or "",
        bot   = (p[3] or ""):upper(),
        stage = p[4] or "",
        time  = tonumber(p[5]) or 0,
        zona  = p[6] or "top",   -- "top" = atas-kiri, "bottom" = bawah-kanan
    }
end

-- ═══════════════════════════════════════════════════════
-- BACA QUEUE (semua world yang sedang dikerjakan)
-- ═══════════════════════════════════════════════════════
function WorldQueue.readPending()
    local map = {}
    for line in dataRead(Config.WorldQueueFile):gmatch("[^\r\n]+") do
        local r = parseQueueLine(line)
        if r then map[r.world] = r end
    end
    return map
end

-- ═══════════════════════════════════════════════════════
-- TULIS QUEUE
-- ═══════════════════════════════════════════════════════
function WorldQueue.writePending(map)
    local lines = {}
    for _, r in pairs(map) do
        lines[#lines + 1] = table.concat({
            r.world, r.door or "", r.bot or "", r.stage or "",
            tostring(r.time or 0), r.zona or "top"
        }, "|")
    end
    dataWrite(Config.WorldQueueFile, table.concat(lines, "\n") .. ((#lines > 0) and "\n" or ""))
end

-- ═══════════════════════════════════════════════════════
-- BACA DAFTAR WORLD DONE (biar tidak di-claim ulang)
-- ═══════════════════════════════════════════════════════
local function readDoneSet()
    local done = {}
    for line in dataRead(Config.WorldDoneFile):gmatch("[^\r\n]+") do
        local name = line:match("^([^|]+)")
        if name then done[name:upper()] = true end
    end
    return done
end

-- ═══════════════════════════════════════════════════════
-- BACA DAFTAR WORLD FAILED
-- ═══════════════════════════════════════════════════════
local function readFailedSet()
    local failed = {}
    for line in dataRead(Config.WorldFailFile):gmatch("[^\r\n]+") do
        local name = line:match("^([^|]+)")
        if name then failed[name:upper()] = true end
    end
    return failed
end

-- ═══════════════════════════════════════════════════════
-- BACA DAFTAR WORLD NUKE (skip total)
-- ═══════════════════════════════════════════════════════
local function readNukeSet()
    local nuke = {}
    for line in dataRead(Config.WorldNukeFile):gmatch("[^\r\n]+") do
        local name = line:match("^([^|]+)")
        if name then nuke[name:upper()] = true end
    end
    return nuke
end

-- ═══════════════════════════════════════════════════════
-- BACA FILE WORLD LIST (user input)
-- Format: NAMA:DOOR atau NAMA|DOOR per baris
-- ═══════════════════════════════════════════════════════
function WorldQueue.readWorldFile()
    local list = {}
    for line in dataRead(Config.WorldFile):gmatch("[^\r\n]+") do
        local name, door = parseWorldEntry(line)
        if name then table.insert(list, { world = name, door = door or "" }) end
    end
    return list
end

-- ═══════════════════════════════════════════════════════
-- COUNT BOT AKTIF DI 1 WORLD (untuk BotsPerWorld)
-- ═══════════════════════════════════════════════════════
local function countBotInWorld(pending, worldName)
    local n = 0
    for _, r in pairs(pending) do
        if r.world == worldName and r.bot ~= "" and not WorldQueue.botDown(r.bot) then
            n = n + 1
        end
    end
    return n
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 3 — WORLD QUEUE PART 1                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 6 LANJUTAN: WORLD QUEUE — CLAIM & FINISH                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════
-- CLAIM WORLD (dipanggil saat bot mau mulai kerja)
-- Return: worldName, doorId, sourceInfo
-- Assign zona otomatis: bot pertama = top, bot kedua = bottom
-- ═══════════════════════════════════════════════════════
function WorldQueue.claim(bot)
    if not WorldQueue.lock(bot) then return nil end

    local me = WorldQueue.me(bot)
    local done = readDoneSet()
    local failed = readFailedSet()
    local nuke = readNukeSet()
    local pending = WorldQueue.readPending()

    -- Hapus entry yang sudah done/failed/nuke dari queue
    for world, r in pairs(pending) do
        if done[world] or failed[world] or nuke[world] then
            pending[world] = nil
        end
    end

    local chosen, source = nil, nil

    -- Prioritas 1: lanjutkan world milik bot ini (reconnect)
    for _, r in pairs(pending) do
        if r.bot == me then
            chosen, source = r, "lanjut"
            break
        end
    end

    -- Prioritas 2: ambil alih world yang bot-nya mati / timeout
    if chosen == nil then
        local timeoutSec = (Config.pendingTimeoutMin or 10) * 60
        for _, r in pairs(pending) do
            local stale = (os.time() - r.time) > timeoutSec
            if stale or WorldQueue.botDown(r.bot) then
                chosen = r
                source = "ambil alih dari " .. r.bot
                break
            end
        end
    end

    -- Prioritas 3: ambil world baru dari file (selama belum penuh)
    if chosen == nil then
        local worldList = WorldQueue.readWorldFile()
        for _, entry in ipairs(worldList) do
            local w = entry.world
            if not done[w] and not failed[w] and not nuke[w] and pending[w] == nil then
                if countBotInWorld(pending, w) < (Config.BotsPerWorld or 1) then
                    chosen = { world = w, door = entry.door, stage = "mulai", time = os.time() }
                    source = "baru"
                    break
                end
            end
        end
    end

    -- Tulis ke queue kalau ada yang dipilih
    if chosen ~= nil then
        -- Tentukan start direction: bot pertama = top, bot kedua = bottom
        local myZona = "top"
        for _, r in pairs(pending) do
            if r.world == chosen.world and r.bot ~= "" and r.bot ~= me then
                if r.zona == "top" then myZona = "bottom" end
                break
            end
        end

        pending[chosen.world] = {
            world = chosen.world,
            door  = chosen.door or "",
            bot   = me,
            stage = "dir_" .. myZona,
            time  = os.time(),
            zona  = myZona,
        }
        WorldQueue.writePending(pending)
    end

    WorldQueue.unlock(bot)

    if chosen == nil then return nil end
    return chosen.world, chosen.door, source
end

-- ═══════════════════════════════════════════════════════
-- HEARTBEAT (update timestamp biar tidak dianggap mati)
-- Return: true kalau masih milik bot ini
-- ═══════════════════════════════════════════════════════
function WorldQueue.heartbeat(bot, world, stage)
    if not WorldQueue.lock(bot) then return true end

    local me = WorldQueue.me(bot)
    local pending = WorldQueue.readPending()
    local r = pending[world:upper()]
    local still = (r ~= nil and r.bot == me)

    if still then
        r.time = os.time()
        if stage ~= nil then r.stage = stage end
        WorldQueue.writePending(pending)
    end

    WorldQueue.unlock(bot)
    return still
end

-- ═══════════════════════════════════════════════════════
-- FINISH (world selesai / gagal / nuke)
-- status: "done" | "failed" | "nuked"
-- Return: true kalau bot ini yang finish duluan
--         false kalau sudah di-finish bot lain (idempotent)
-- ═══════════════════════════════════════════════════════
function WorldQueue.finish(bot, world, doorId, status, note)
    WorldQueue.lock(bot)

    -- Kalau status done dan sudah ada di done set, skip
    -- (bot lain sudah finish duluan)
    if status == "done" then
        local doneSet = readDoneSet()
        if doneSet[world:upper()] then
            WorldQueue.unlock(bot)
            return false
        end
    end

    -- Hapus dari pending
    local pending = WorldQueue.readPending()
    pending[world:upper()] = nil
    WorldQueue.writePending(pending)

    -- Tulis ke file sesuai status
    local targetFile = Config.WorldDoneFile
    if status == "failed" then targetFile = Config.WorldFailFile
    elseif status == "nuked" then targetFile = Config.WorldNukeFile end

    dataAppend(targetFile, table.concat({
        world:upper(), tostring(doorId or ""), WorldQueue.me(bot),
        tostring(os.time()), tostring(note or "")
    }, "|") .. "\n")

    WorldQueue.unlock(bot)
    return true
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 4 — WORLD QUEUE PART 2                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 7: STORAGE LOCK                                              ║
-- ║   Lock global untuk storage (1 bot saja yang masuk storage).             ║
-- ║   Kalau bot mati, lock lepas otomatis setelah 15 detik.                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local StorageLock = {}

local STORAGE_LOCK_TTL_SEC       = 45
local STORAGE_LOCK_HEARTBEAT_SEC = 5
local STORAGE_LOCK_OFFLINE_SEC   = 15
local StorageLockState = {}

local function getStorageLockState(bot)
    local key = removeColorSafe(bot.name):upper()
    if StorageLockState[key] == nil then
        StorageLockState[key] = { held = false, lastBeat = 0, offlineSince = nil }
    end
    return StorageLockState[key], key
end

local function readStorageLock()
    local raw = dataRead(Config.FileQueueLock:gsub("%.lock$", ".storage.lock"))
    if raw == nil or raw == "" then return nil, 0 end
    local holder, stamp = raw:match("^%s*([^|\r\n]+)|?(%d*)")
    if holder == nil or holder == "" then return nil, 0 end
    return holder:upper(), tonumber(stamp) or 0
end

local function writeStorageLock(key)
    dataWrite(Config.FileQueueLock:gsub("%.lock$", ".storage.lock"), key .. "|" .. tostring(os.time()))
end

function StorageLock.release(bot)
    local state, key = getStorageLockState(bot)
    state.held = false
    state.offlineSince = nil
    local holder = readStorageLock()
    if holder == key then
        writeStorageLock("")
    end
end

-- Heartbeat dipanggil otomatis dari smartSleep
StorageLockHeartbeat = function(bot)
    local state, key = getStorageLockState(bot)
    if not state.held then return end

    local now = os.time()
    if (now - state.lastBeat) < STORAGE_LOCK_HEARTBEAT_SEC then return end
    state.lastBeat = now

    local st = bot.status
    if not isConnected(st) then
        if state.offlineSince == nil then state.offlineSince = now end
        if (now - state.offlineSince) >= STORAGE_LOCK_OFFLINE_SEC then
            StorageLock.release(bot)
            return
        end
    else
        state.offlineSince = nil
    end

    local holder = readStorageLock()
    if holder == nil then
        sleep(120)
        holder = readStorageLock()
    end
    if holder == key or holder == nil then
        writeStorageLock(key)
    else
        state.held = false
    end
end

function StorageLock.acquire(bot)
    local state, key = getStorageLockState(bot)

    -- Sudah punya lock, perpanjang
    if state.held then
        local holder, stamp = readStorageLock()
        if holder == key and (os.time() - stamp) <= STORAGE_LOCK_TTL_SEC then
            writeStorageLock(key)
            state.lastBeat = os.time()
            return true
        end
        state.held = false
    end

    local shownHolder = nil
    while true do
        local holder, stamp = readStorageLock()
        if holder == nil then
            sleep(120)
            holder, stamp = readStorageLock()
        end

        local now = os.time()
        local isFree = (holder == nil) or (holder == key) or ((now - stamp) > STORAGE_LOCK_TTL_SEC)

        if isFree then
            writeStorageLock(key)
            sleep(350 + getNextBotRandom(bot, 0, 250))
            if readStorageLock() == key then
                sleep(250)
                if readStorageLock() == key then
                    state.held = true
                    state.lastBeat = os.time()
                    state.offlineSince = nil
                    return true
                end
            end
        elseif shownHolder ~= holder then
            shownHolder = holder
            setBotActivity(bot, "Antre storage (giliran " .. tostring(holder) .. ")...")
        end

        sleep(900 + getNextBotRandom(bot, 100, 500))
    end
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 8: PROXY MANAGEMENT                                          ║
-- ║   Auto switch proxy kalau bot kena block/ban.                            ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Proxy = {}

local function getProxyManager()
    if ProxyManagerCache ~= nil then return ProxyManagerCache end
    local ok, mgr = pcall(function() return getProxyManager() end)
    if ok and mgr ~= nil then
        ProxyManagerCache = mgr
        return mgr
    end
    return nil
end

function Proxy.trySwitch(bot)
    if not Config.AutoSwitchProxy then return false end
    local mgr = getProxyManager()
    if mgr == nil then return false end

    local ok = pcall(function()
        if mgr.switch ~= nil then mgr:switch() end
    end)

    if ok then
        setBotActivity(bot, "Proxy switched, reconnect...")
        addHistory("Bot " .. removeColorSafe(bot.name) .. ": proxy switched")
        return true
    end
    return false
end

function Proxy.shouldSwitch(st)
    if not Config.AutoSwitchProxy then return false end
    return st == BotStatus.location_banned
        or st == BotStatus.http_block
        or st == BotStatus.network_restricted
        or st == BotStatus.advanced_account_protection
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 9: CONNECTION HANDLER                                        ║
-- ║   Handle disconnect, reconnect, wait backpack.                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Conn = {}

function Conn.onStop()
    for key, state in pairs(StorageLockState) do
        if state.held then
            state.held = false
            local holder = readStorageLock()
            if holder == key then
                writeStorageLock("")
            end
        end
    end
end

function Conn.waitOnline(bot, maxWaitSec)
    local start = os.time()
    local maxWait = maxWaitSec or 60

    while bot.status ~= BotStatus.online do
        if isBanned(bot.status) then
            return false, "banned"
        end
        if (os.time() - start) > maxWait then
            return false, "timeout"
        end
        if Proxy.shouldSwitch(bot.status) then
            Proxy.trySwitch(bot)
        end
        sleep(2000)
    end
    return true, "ok"
end

function Conn.waitBackpack(bot, maxWaitSec)
    local start = os.time()
    local maxWait = maxWaitSec or 30

    while (os.time() - start) <= maxWait do
        local inv = Try(function() return bot:getInventory() end)
        if inv ~= nil and inv.itemcount ~= nil and inv.itemcount > 0 then
            return true
        end
        sleep(500)
    end
    return false
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 5 — STORAGE LOCK + PROXY + CONN                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 10: SEED DETECTION                                           ║
-- ║   Deteksi seed otomatis dari inventory (kalau AutoDetectSeed = true).    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Seed = {}
local SeedCache = {}

-- Cek apakah item adalah seed (nama mengandung "seed")
local function isSeedItem(itemId)
    local info = Try(function() return getInfo(itemId) end)
    if info == nil or info.name == nil then return false end
    return tostring(info.name):lower():find("seed", 1, true) ~= nil
end

local function canBePlanted(itemId)
    return isSeedItem(itemId)
end

-- Deteksi seed pertama di inventory
-- Return: seedId, seedName, count
function Seed.detect(bot)
    local cacheKey = removeColorSafe(bot.name):upper()

    -- Pakai SeedId manual
    if not Config.AutoDetectSeed then
        if Config.SeedId == 0 then
            return nil, "SeedId = 0", 0
        end
        local info = Try(function() return getInfo(Config.SeedId) end)
        local name = info and info.name or ("ID " .. tostring(Config.SeedId))
        return Config.SeedId, name, Count(Config.SeedId)
    end

    -- Cek cache masih valid
    local cached = SeedCache[cacheKey]
    if cached ~= nil and cached.count > 0 then
        local currentCount = Count(cached.id)
        if currentCount > 0 then
            cached.count = currentCount
            return cached.id, cached.name, currentCount
        end
    end

    -- Scan inventory
    local inv = Try(function() return bot:getInventory() end)
    if inv == nil then return nil, "Inventory belum load", 0 end

    local bestId, bestName, bestCount = nil, nil, 0

    local ok = pcall(function()
        for _, item in ipairs(inv:getItems()) do
            if canBePlanted(item.id) and item.count > bestCount then
                bestId   = item.id
                bestName = (getInfo(item.id) or {}).name or ("ID " .. item.id)
                bestCount = item.count
            end
        end
    end)

    -- Fallback ke common seed ID kalau scan gagal
    if not ok then
        for _, id in ipairs({ 3, 5, 11, 15 }) do
            local c = Count(id)
            if c > bestCount then
                bestId   = id
                bestName = (getInfo(id) or {}).name or ("ID " .. id)
                bestCount = c
            end
        end
    end

    if bestId == nil then
        return nil, "Tidak ada seed", 0
    end

    SeedCache[cacheKey] = { id = bestId, name = bestName, count = bestCount }
    return bestId, bestName, bestCount
end

-- Reset cache (setelah refill atau reconnect)
function Seed.resetCache(bot)
    SeedCache[removeColorSafe(bot.name):upper()] = nil
end

-- Cek masih punya seed
function Seed.hasSeed(bot)
    local id, _, count = Seed.detect(bot)
    return id ~= nil and count > 0
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 11: INVENTORY CHECK                                          ║
-- ║   Cek isi inventory: backpack full, toxic waste, fire world, dll.        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Inv = {}

-- Cek apakah backpack hampir penuh (max 100 slot, anggap penuh kalau >90)
function Inv.isBackpackFull(bot)
    local inv = Try(function() return bot:getInventory() end)
    if inv == nil then return false end
    return inv.itemcount >= 90
end

-- Cek apakah ada toxic waste di sekitar bot
function Inv.hasToxicWasteNearby(bot, range)
    range = range or 3
    local bx, by = Pos()
    for dy = -range, range do
        for dx = -range, range do
            local x, y = bx + dx, by + dy
            if InBounds(x, y) then
                local fg = GetTile(x, y)
                for _, wasteId in ipairs(Config.ToxicWasteIds) do
                    if fg == wasteId then return true, x, y end
                end
            end
        end
    end
    return false
end

-- Cek world punya fire (untuk AvoidFireWorlds)
function Inv.hasFireWorld(bot)
    if not Config.AvoidFireWorlds then return false end

    local world = Try(function() return bot:getWorld() end)
    if world == nil then return false end

    local fireIds = { 1158, 1210, 1720 }
    local fireSet = {}
    for _, id in ipairs(fireIds) do fireSet[id] = true end

    local ok, tiles = pcall(function() return world:getTilesSafe() end)
    if not ok or tiles == nil then return false end

    for _, tile in ipairs(tiles) do
        if fireSet[tile.fg] then return true end
    end
    return false
end

-- Hitung slot kosong
function Inv.emptySlots(bot)
    local inv = Try(function() return bot:getInventory() end)
    if inv == nil then return 0 end
    return inv.emptyslots or 0
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 6 — SEED DETECTION + INVENTORY CHECK                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 12: STORAGE REFILL                                           ║
-- ║   Ambil seed dari SeedStorages (fallback ke storage berikutnya kalau     ║
-- ║   kosong). Return leftover kalau ReturnLeftover = true.                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Refill = {}

-- Parse storage entry "NAME|DOOR" jadi worldName, doorId
local function parseStorage(storageText)
    if storageText == nil or storageText == "" then return nil, nil end
    local name, door = storageText:match("^([^|:]+)[|:]?(.*)$")
    if name == nil then return nil, nil end
    return name:upper(), door or ""
end

-- Warp ke world (dengan door ID kalau ada)
local function warpToWorld(bot, worldName, doorId)
    if worldName == nil or worldName == "" then return false end
    worldName = worldName:upper()

    for _ = 1, 3 do
        local ok = Conn.waitOnline(bot, 30)
        if not ok then return false end

        pcall(function()
            if doorId ~= nil and doorId ~= "" then
                bot:warp(worldName, doorId)
            else
                bot:warp(worldName)
            end
        end)
        sleep(5000, 6000)

        if CurrentWorld() == worldName then return true end
    end
    return false
end

-- Ambil seed dari 1 storage world
-- Return: jumlah seed yang berhasil diambil
local function takeSeedFromStorage(bot, storageText, targetCount)
    local worldName, doorId = parseStorage(storageText)
    if worldName == nil then return 0 end

    setBotActivity(bot, "Ke storage " .. worldName .. " ambil seed...")

    if not warpToWorld(bot, worldName, doorId) then
        devLog(bot, "refill", "Gagal warp ke " .. worldName)
        return 0
    end

    sleep(1000, 2000)

    -- Deteksi seed di storage
    local seedId = nil
    if Config.AutoDetectSeed then
        local inv = Try(function() return bot:getInventory() end)
        if inv ~= nil then
            pcall(function()
                for _, item in ipairs(inv:getItems()) do
                    if canBePlanted(item.id) then
                        seedId = item.id
                        break
                    end
                end
            end)
        end
        if seedId == nil then seedId = Config.SeedId end
    else
        seedId = Config.SeedId
    end

    if seedId == nil or seedId == 0 then
        devLog(bot, "refill", "Tidak bisa deteksi seed di storage")
        return 0
    end

    -- Collect seed di sekitar (auto_collect mode)
    local beforeCount = Count(seedId)
    local target = beforeCount + (targetCount or Config.SeedTakeAmount)

    pcall(function() bot.auto_collect = true end)

    for _ = 1, 10 do
        if Count(seedId) >= target then break end
        sleep(1500, 2000)
    end

    pcall(function() bot.auto_collect = false end)

    local afterCount = Count(seedId)
    local taken = afterCount - beforeCount

    Seed.resetCache(bot)
    return taken
end

-- Refill seed: coba semua SeedStorages sampai dapat
-- Return: seedId, seedName, count, success
function Refill.fillSeed(bot, targetCount)
    targetCount = targetCount or Config.SeedTakeAmount

    if Config.SeedStorages == nil or #Config.SeedStorages == 0 then
        devLog(bot, "refill", "SeedStorages kosong di config!")
        return nil, nil, 0, false
    end

    StorageLock.acquire(bot)

    local totalTaken = 0

    for _, storageText in ipairs(Config.SeedStorages) do
        local taken = takeSeedFromStorage(bot, storageText, targetCount)
        totalTaken = totalTaken + taken

        if taken > 0 then
            local id, name, count = Seed.detect(bot)
            if count >= targetCount then break end
            targetCount = targetCount - count
        else
            setBotActivity(bot, "Storage kosong, lanjut ke storage berikutnya...")
        end
    end

    StorageLock.release(bot)

    local finalId, finalName, finalCount = Seed.detect(bot)

    if totalTaken == 0 then
        devLog(bot, "refill", "Semua storage kosong atau gagal warp")
        return finalId, finalName, finalCount, false
    end

    return finalId, finalName, finalCount, finalCount > 0
end

-- Kembalikan sisa seed ke storage
function Refill.returnLeftover(bot, worldNameToReturn)
    if not Config.ReturnLeftover then return true end

    local seedId, _, count = Seed.detect(bot)
    if seedId == nil or count <= 0 then return true end

    if Config.SeedStorages == nil or #Config.SeedStorages == 0 then
        return true
    end

    StorageLock.acquire(bot)

    local returned = false
    for _, storageText in ipairs(Config.SeedStorages) do
        local world, door = parseStorage(storageText)
        if world ~= nil then
            if warpToWorld(bot, world, door) then
                sleep(1000, 1500)
                pcall(function() bot.auto_collect = false end)
                pcall(function() bot:drop(seedId, count) end)
                sleep(800, 1200)
                if Count(seedId) < count then
                    returned = true
                    break
                end
            end
        end
    end

    StorageLock.release(bot)

    -- Balik ke world semula kalau ada
    if returned and worldNameToReturn ~= nil and worldNameToReturn ~= "" then
        warpToWorld(bot, worldNameToReturn, "")
    end

    return returned
end

-- Cek apakah sisa seed perlu dikembalikan
function Refill.shouldReturnLeftover(bot)
    if not Config.ReturnLeftover then return false end
    local seedId, _, count = Seed.detect(bot)
    return seedId ~= nil and count > 0
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 13: TOXIC WASTE CLEAN                                        ║
-- ║   Bersihkan toxic waste (gas) di sekitar bot.                            ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Toxic = {}

function Toxic.cleanNearby(bot, range)
    if not Config.CleanToxicWaste then return end
    range = range or 3

    local hasWaste, wx, wy = Inv.hasToxicWasteNearby(bot, range)
    if not hasWaste then return end

    setBotActivity(bot, "Bersihkan toxic waste di (" .. wx .. "," .. wy .. ")...")

    for _ = 1, 5 do
        local fg = GetTile(wx, wy)
        if fg == -1 then break end

        local isWaste = false
        for _, id in ipairs(Config.ToxicWasteIds) do
            if fg == id then isWaste = true; break end
        end
        if not isWaste then break end

        pcall(function() bot:hit(wx, wy) end)
        sleep(Config.HitDelayMs or 160)
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 7 — STORAGE REFILL + TOXIC CLEAN                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 14: NAVIGATION                                               ║
-- ║   Jalan, warp, respawn, stuck detection, re-enter.                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Nav = {}

-- Cari posisi White Door di world
function Nav.findWhiteDoor(world)
    if world == nil then return 48, 23 end

    local ok, tiles = pcall(function() return world:getTilesSafe() end)
    if not ok or tiles == nil then return 48, 23 end

    for _, tile in ipairs(tiles) do
        if tile.fg == ITEM_WHITE_DOOR then
            return tile.x, tile.y
        end
    end
    return 48, 23
end

-- Cek tile solid (tidak bisa dilewati)
local function isSolidForeground(fgId)
    if fgId <= 0 then return false end
    if fgId == ITEM_PLATFORM or fgId == ITEM_WHITE_DOOR or fgId == ITEM_ENTRANCE then
        return false
    end
    if PASSABLE[fgId] then return false end

    local info = Try(function() return getInfo(fgId) end)
    if info ~= nil then
        return info.collision_type == 1
    end
    return true
end

-- Jalan horizontal di 1 baris (per tile, cek obstacle)
function Nav.walkHorizontal(bot, targetX, rowY, expectedWorld)
    if bot:isInTile(targetX, rowY) then return true end

    local stepDelay = Config.PlantDelayMs or 120
    local guard = 0
    local maxGuard = 130

    while (bot.x ~= targetX or bot.y ~= rowY) and guard < maxGuard do
        if not isConnected(bot.status) then
            local ok = Conn.waitOnline(bot, 30)
            if not ok then return false end
        end

        if expectedWorld ~= nil and not bot:isInWorld(expectedWorld) then
            return false
        end

        if bot.y ~= rowY then
            pcall(function() bot:findPath(targetX, rowY) end)
            sleep(500)
            return bot:isInTile(targetX, rowY)
        end

        local nextX = (bot.x < targetX) and (bot.x + 1) or (bot.x - 1)
        local world = bot:getWorld()
        local nextTile = world and world:getTile(nextX, rowY)

        if nextTile ~= nil and isSolidForeground(nextTile.fg) then
            pcall(function() bot:findPath(targetX, rowY) end)
            sleep(500)
            return bot:isInTile(targetX, rowY)
        end

        pcall(function() bot:moveTile(nextX, rowY) end)
        sleep(stepDelay)
        guard = guard + 1
    end

    return bot:isInTile(targetX, rowY)
end

-- Jalan step by step pakai pathfinding (lebih lambat tapi aman)
function Nav.walkStepByStep(bot, targetX, targetY, expectedWorld)
    if bot:isInTile(targetX, targetY) then return true end

    pcall(function() bot:findPath(targetX, targetY) end)

    local waited = 0
    while waited < 3000 and not bot:isInTile(targetX, targetY) do
        sleep(100)
        waited = waited + 100
    end

    return bot:isInTile(targetX, targetY)
end

-- Warp ke world dengan door ID
function Nav.warpTo(bot, worldName, doorId)
    if worldName == nil or worldName == "" then return false end
    worldName = worldName:upper()

    for attempt = 1, 5 do
        local ok = Conn.waitOnline(bot, 30)
        if not ok then return false end

        if doorId ~= nil and doorId ~= "" then
            pcall(function() bot:warp(worldName, doorId) end)
        else
            pcall(function() bot:warp(worldName) end)
        end

        -- Tunggu masuk world
        local waited = 0
        while waited < 4500 and not bot:isInWorld(worldName) do
            sleep(250)
            waited = waited + 250
        end

        if bot:isInWorld(worldName) then
            sleep(300)
            return true
        end
    end

    return false
end

-- Respawn dan tunggu di White Door
function Nav.respawnAtDoor(bot, worldName)
    local world = bot:getWorld()
    if world == nil then return false end

    local doorX, doorY = Nav.findWhiteDoor(world)

    pcall(function() bot:respawn() end)

    local waited = 0
    while waited < 5000 and not bot:isInTile(doorX, doorY) do
        sleep(100)
        waited = waited + 100
    end

    sleep(800)
    return bot:isInTile(doorX, doorY)
end

-- Cek bot stuck (posisi tidak berubah dalam MaxStuckSec detik)
function Nav.detectStuck(bot)
    local data = getOrInitBotData(bot)
    local bx, by = Pos()

    if data.stuckCheckX == bx and data.stuckCheckY == by then
        if data.stuckSince == nil then
            data.stuckSince = os.time()
        elseif (os.time() - data.stuckSince) >= (Config.MaxStuckSec or 15) then
            data.stuckSince = nil
            return true
        end
    else
        data.stuckSince = nil
        data.stuckCheckX = bx
        data.stuckCheckY = by
    end

    return false
end

-- Re-enter world kalau stuck
function Nav.reEnterIfStuck(bot, worldName)
    if not Config.ReEnterIfStuck then return true end
    if not Nav.detectStuck(bot) then return true end

    setBotActivity(bot, "Stuck! Re-enter world...", worldName)
    addHistory("Bot " .. removeColorSafe(bot.name) .. ": stuck, re-enter")

    -- Coba respawn dulu
    if Nav.respawnAtDoor(bot, worldName) then
        return true
    end

    -- Kalau masih stuck, leave + warp ulang
    pcall(function() bot:leaveWorld() end)
    sleep(3000, 4000)

    return Nav.warpTo(bot, worldName, "")
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 8 — NAVIGATION                                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 15: TILE CHECK (SEBELUM PLANT)                               ║
-- ║   Cek setiap tile sebelum nanam: access, fire, ground, obstacle.         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local TileCheck = {}

-- Cek apakah tile punya akses
function TileCheck.hasAccess(bot, x, y)
    local world = bot:getWorld()
    if world == nil then return false end

    local ok, result = pcall(function() return world:hasAccess(x, y) end)
    if ok and type(result) == "boolean" then
        return result
    end
    return true
end

-- Cek apakah tile ada fire
local FIRE_IDS = { 1158, 1210, 1720 }
local FIRE_SET = {}
for _, id in ipairs(FIRE_IDS) do FIRE_SET[id] = true end

function TileCheck.hasFire(x, y)
    local fg = GetTile(x, y)
    return FIRE_SET[fg] == true
end

-- Cek apakah tile punya ground (block di bawah)
function TileCheck.hasGround(world, x, y)
    if world == nil then return false end
    if not world:isValidTile(x, y + 1) then return false end
    local below = world:getTile(x, y + 1)
    if below == nil then return false end
    return below.fg > 0
end

-- Cek apakah tile bisa ditanami
-- Return: ok, reason
function TileCheck.canPlant(bot, x, y)
    local world = bot:getWorld()
    if world == nil then return false, "no world" end
    if not world:isValidTile(x, y) then return false, "out of bounds" end

    local tile = world:getTile(x, y)
    if tile == nil then return false, "no tile data" end

    -- Harus kosong
    if tile.fg > 0 then return false, "occupied: " .. tostring(tile.fg) end

    -- Harus ada ground di bawah
    if not TileCheck.hasGround(world, x, y) then return false, "no ground" end

    -- Tidak boleh ada fire
    if TileCheck.hasFire(x, y) then return false, "fire" end

    -- Harus punya akses
    if not TileCheck.hasAccess(bot, x, y) then return false, "no access" end

    return true, "ok"
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 16: PLANTING LOGIC — PART 1                                  ║
-- ║   Fungsi place seed, auto collect, dan tanam 1 baris (zig-zag).          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Plant = {}

-- Place 1 seed di tile (x, y) dari posisi bot sekarang
-- Return: true kalau berhasil
local function placeSeedAt(bot, x, y, seedId)
    if Count(seedId) < 1 then return false end

    pcall(function() bot:place(x, y, seedId) end)
    sleep(Config.PlantDelayMs or 120)

    -- Cek berhasil: tile harus terisi dengan seedId
    local fg = GetTile(x, y)
    if fg == seedId then
        local data = getOrInitBotData(bot)
        data.seedsPlanted = (data.seedsPlanted or 0) + 1
        data.lastPlantTime = os.time()
        return true
    end

    return false
end

-- Auto collect drops di sekitar (kalau AutoCollect aktif)
local function autoCollectNearby(bot)
    if not Config.AutoCollect then return end

    local prevAuto = bot.auto_collect
    pcall(function() bot.auto_collect = true end)
    pcall(function() bot:collect(Config.CollectRange or 3, Config.CollectInterval or 60) end)
    sleep(Config.CollectInterval or 60)
    pcall(function() bot.auto_collect = prevAuto end)
end

-- Cari tile paling kiri & kanan yang punya ground di baris (y)
local function findRowBounds(world, y)
    if world == nil then return nil, nil end
    local minX, maxX = nil, nil
    for x = 1, 98 do
        local tile = world:getTile(x, y)
        if tile ~= nil and tile.fg == 0 then
            local below = world:getTile(x, y + 1)
            if below ~= nil and below.fg > 0 then
                if minX == nil then minX = x end
                maxX = x
            end
        end
    end
    return minX, maxX
end

-- Tanam 1 baris dengan zig-zag (arah tergantung rightToLeft)
-- Return: refusedList (tile yang gagal ditanami)
function Plant.doRow(bot, y, rightToLeft, seedId, seedName)
    local world = bot:getWorld()
    if world == nil then return {} end

    local minX, maxX = findRowBounds(world, y)
    if minX == nil then return {} end

    local first, last, step = minX, maxX, 1
    if rightToLeft then first, last, step = maxX, minX, -1 end

    setBotActivity(bot, "Tanam baris " .. y .. " (" .. first .. " -> " .. last .. ")...")

    local refused = {}

    for x = first, last, step do
        -- Cek seed masih ada
        if not Seed.hasSeed(bot) then break end

        -- Jalan ke tile
        local reached = Nav.walkHorizontal(bot, x, y, CurrentWorld())
        if not reached then
            table.insert(refused, { x = x, y = y, reason = "unreachable" })
        else
            -- Cek tile sebelum plant (kalau CheckTileBefore)
            local canPlace = true
            if Config.CheckTileBefore then
                local ok, reason = TileCheck.canPlant(bot, x, y)
                if not ok then
                    canPlace = false
                    if reason ~= "occupied" then
                        table.insert(refused, { x = x, y = y, reason = reason })
                    end
                end
            end

            if canPlace then
                local success = placeSeedAt(bot, x, y, seedId)
                if not success then
                    table.insert(refused, { x = x, y = y, reason = "place failed" })
                end

                -- Auto collect sambil tanam (tiap 5 tile)
                if Config.AutoCollect and (x - first) % 5 == 0 then
                    autoCollectNearby(bot)
                end
            end

            -- Cek stuck
            if Nav.detectStuck(bot) then
                Nav.reEnterIfStuck(bot, CurrentWorld())
            end
        end
    end

    return refused
end

-- Retry refused tiles (dipanggil setelah semua baris selesai)
function Plant.retryRefused(bot, refusedList, seedId)
    if not Config.RetryRefused or #refusedList == 0 then return 0 end

    setBotActivity(bot, "Retry " .. #refusedList .. " tile yang ditolak...")

    local retried = 0
    local maxRetry = Config.MaxRetryPerTile or 3

    for _, tile in ipairs(refusedList) do
        if not Seed.hasSeed(bot) then break end
        if retried >= maxRetry then break end

        local reached = Nav.walkStepByStep(bot, tile.x, tile.y, CurrentWorld())
        if reached then
            local ok = TileCheck.canPlant(bot, tile.x, tile.y)
            if ok then
                if placeSeedAt(bot, tile.x, tile.y, seedId) then
                    retried = retried + 1
                end
            end
        end
    end

    addHistory("Bot " .. removeColorSafe(bot.name) .. ": retry " .. retried .. " tile berhasil")
    return retried
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 9 — TILE CHECK + PLANT PART 1                                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 16: PLANTING LOGIC — PART 2                                  ║
-- ║   Sweep logic multi-bot: 2 bot dari arah berbeda, take over kalau DC.   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Tinggi world (default 60 untuk GT normal)
local function getWorldHeight(bot)
    local world = bot:getWorld()
    if world ~= nil and world.y ~= nil and world.y > 0 then
        return world.y
    end
    return 60
end

-- Ada tile kosong yang bisa ditanami di seluruh world?
-- Return: true kalau masih ada, false kalau semua terisi
local function worldHasEmptyPlantable(bot)
    local world = bot:getWorld()
    if world == nil then return false end

    local h = getWorldHeight(bot)
    for y = 0, h - 2 do
        for x = 1, 98 do
            local tile = world:getTile(x, y)
            if tile ~= nil and tile.fg == 0 then
                local below = world:getTile(x, y + 1)
                if below ~= nil and below.fg > 0 then
                    return true
                end
            end
        end
    end
    return false
end

-- Partner masih hidup? Cek heartbeat di queue
local function isPartnerAlive(bot, worldName)
    local me = WorldQueue.me(bot)
    local pending = WorldQueue.readPending()
    local now = os.time()
    local timeout = Config.PartnerTimeoutSec or 180

    for _, r in pairs(pending) do
        if r.world == worldName and r.bot ~= me and r.bot ~= "" then
            if not WorldQueue.botDown(r.bot) and (now - r.time) < timeout then
                return true, r.bot
            end
        end
    end
    return false, nil
end

-- Main planting untuk 1 world.
-- Bot A mulai atas-kiri, Bot B mulai bawah-kanan.
-- Kalau partner mati, bot lain sweep ulang sampai semua tile terisi.
function Plant.doWorld(bot, worldName, doorId)
    local data = getOrInitBotData(bot)
    data.worldStart = os.time()
    data.seedsPlanted = 0
    data.worldStartWorld = worldName

    addHistory("Bot " .. removeColorSafe(bot.name) .. ": mulai plant di " .. worldName)

    -- Warp ke world
    setBotActivity(bot, "Warp ke " .. worldName, worldName)
    if not Nav.warpTo(bot, worldName, doorId) then
        addHistory("Bot " .. removeColorSafe(bot.name) .. ": gagal warp ke " .. worldName)
        return { success = false, reason = "warp failed" }
    end

    -- Cek world punya fire
    if Inv.hasFireWorld(bot) then
        addHistory("Bot " .. removeColorSafe(bot.name) .. ": " .. worldName .. " ada fire, skip")
        return { success = false, reason = "fire world" }
    end

    -- Deteksi seed
    local seedId, seedName, seedCount = Seed.detect(bot)
    if seedId == nil or seedCount < 1 then
        setBotActivity(bot, "Tidak ada seed, refill...")
        seedId, seedName, seedCount = Refill.fillSeed(bot, Config.SeedTakeAmount)
        if seedId == nil or seedCount < 1 then
            addHistory("Bot " .. removeColorSafe(bot.name) .. ": tidak ada seed, skip world")
            return { success = false, reason = "no seed" }
        end
    end

    setBotActivity(bot, "Seed: " .. seedName .. " x" .. seedCount, worldName)

    -- Ambil start direction dari queue
    local pending = WorldQueue.readPending()
    local myRecord = pending[worldName]
    local myDir = (myRecord and myRecord.zona) or "top"
    local worldHeight = getWorldHeight(bot)

    addHistory("Bot " .. removeColorSafe(bot.name) .. ": start = " .. myDir)

    local maxSweeps = Config.MaxSweeps or 5
    local sweepCount = 0
    local refillCount = 0

    -- ═══════════════════════════════════════════════════════════
    -- LOOP SWEEP
    -- Sweep 1: dari arah start sendiri
    -- Kalau tidak selesai & partner mati → sweep ulang
    -- ═══════════════════════════════════════════════════════════
    while sweepCount < maxSweeps do
        sweepCount = sweepCount + 1

        local startY, endY, step
        if myDir == "top" then
            startY, endY, step = 0, worldHeight - 2, 1
        else
            startY, endY, step = worldHeight - 2, 0, -1
        end

        local rtl = (myDir == "bottom")

        setBotActivity(bot, "Sweep " .. sweepCount .. " (" .. myDir .. ")", worldName)

        for y = startY, endY, step do
            -- Heartbeat
            if not WorldQueue.heartbeat(bot, worldName, "sweep" .. sweepCount .. "_y" .. y) then
                addHistory("Bot " .. removeColorSafe(bot.name) .. ": world diambil bot lain")
                return { success = false, reason = "taken over" }
            end

            -- Cek seed, refill kalau habis
            if not Seed.hasSeed(bot) then
                refillCount = refillCount + 1
                if refillCount > (Config.MaxRefillCount or 5) then
                    addHistory("Bot " .. removeColorSafe(bot.name) .. ": terlalu banyak refill")
                    break
                end

                setBotActivity(bot, "Refill seed (" .. refillCount .. "/" .. Config.MaxRefillCount .. ")...")
                seedId, seedName, seedCount = Refill.fillSeed(bot, Config.SeedTakeAmount)
                if seedId == nil or seedCount < 1 then break end
                Nav.warpTo(bot, worldName, doorId)
            end

            -- Cek baris ada kerja
            local world = bot:getWorld()
            if world == nil then break end

            local hasWork = false
            for x = 1, 98 do
                local tile = world:getTile(x, y)
                if tile ~= nil and tile.fg == 0 then
                    local below = world:getTile(x, y + 1)
                    if below ~= nil and below.fg > 0 then
                        hasWork = true; break
                    end
                end
            end

            if hasWork then
                Plant.doRow(bot, y, rtl, seedId, seedName)
                rtl = not rtl   -- zig-zag
            end

            -- Cek stuck
            if Nav.detectStuck(bot) then
                Nav.reEnterIfStuck(bot, worldName)
            end
        end

        -- ═══════════════════════════════════════════════════════════
        -- CEK SELESAI: tidak ada tile kosong?
        -- ═══════════════════════════════════════════════════════════
        if not worldHasEmptyPlantable(bot) then
            addHistory("Bot " .. removeColorSafe(bot.name) .. ": world DONE setelah sweep " .. sweepCount)
            return {
                success = true,
                seedsPlanted = data.seedsPlanted or 0,
                trees = data.seedsPlanted or 0,
                duration = os.time() - (data.worldStart or os.time()),
            }
        end

        -- Belum selesai. Sweep pertama + partner masih hidup → tunggu partner
        if sweepCount == 1 then
            local partnerAlive, partnerName = isPartnerAlive(bot, worldName)
            if partnerAlive then
                setBotActivity(bot, "Menunggu partner " .. partnerName .. "...", worldName)
                addHistory("Bot " .. removeColorSafe(bot.name) .. ": tunggu partner " .. partnerName)

                local waited = 0
                local maxWait = Config.PartnerTimeoutSec or 180

                while waited < maxWait do
                    sleep(10000)
                    waited = waited + 10

                    WorldQueue.heartbeat(bot, worldName, "waiting_partner")

                    -- Cek world sudah selesai?
                    if not worldHasEmptyPlantable(bot) then
                        addHistory("Bot " .. removeColorSafe(bot.name) .. ": partner selesai, world DONE")
                        return {
                            success = true,
                            seedsPlanted = data.seedsPlanted or 0,
                            trees = data.seedsPlanted or 0,
                            duration = os.time() - (data.worldStart or os.time()),
                        }
                    end

                    -- Cek partner masih hidup?
                    if not isPartnerAlive(bot, worldName) then
                        addHistory("Bot " .. removeColorSafe(bot.name) .. ": partner mati, take over")
                        break
                    end
                end
            end
        end

        -- Jeda sebelum sweep berikutnya
        sleep(3000)
    end

    -- Max sweep tercapai tapi masih ada tile kosong
    addHistory("Bot " .. removeColorSafe(bot.name) .. ": max sweep, sisa tile tidak bisa ditanam")
    return {
        success = false,
        reason = "incomplete after " .. maxSweeps .. " sweeps",
        seedsPlanted = data.seedsPlanted or 0,
    }
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 10 — PLANT PART 2 (SWEEP LOGIC)                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 17: HTTP CLIENT                                              ║
-- ║   Wrapper HttpClient v2.86 + fallback Webhook class.                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Http = {}

local function isValidWebhook(url)
    if url == nil or url == "" then return false end
    if url:find("ISI_") then return false end
    if not url:find("^https://") then return false end
    if not url:find("discord") and not url:find("discordapp") then return false end
    return true
end

local function cleanWebhookBase(url)
    local base = url:match("^([^%?]+)") or url
    base = base:gsub("/+$", "")
    return base
end

local function censorStorage(text)
    if type(text) ~= "string" or text == "" then return text end
    for _, storage in ipairs(Config.SeedStorages or {}) do
        local name = storage:match("^([^|:]+)")
        if name and #name >= 3 then
            local pattern = name:gsub("%W", "%%%0"):gsub("%a", function(c)
                return "[" .. c:lower() .. c:upper() .. "]"
            end)
            text = text:gsub(pattern, "••••••")
        end
    end
    return text
end

function Http.send(url, method, payload, timeoutSec)
    if not isValidWebhook(url) then return nil, nil end

    local status, body = nil, nil
    pcall(function()
        local client = HttpClient.new()
        client.url = url
        client:setMethod(method)
        if client.headers == nil then client.headers = {} end
        client.headers["Content-Type"] = "application/json; charset=utf-8"
        client.content = censorStorage(payload)
        client.timeout = timeoutSec or 8

        local result = client:request()
        if result ~= nil and result.error == 0 then
            status = result.status
            body = result.body
        end
    end)
    return status, body
end

function Http.fallbackSend(url, username, avatarUrl, content, embed)
    if not isValidWebhook(url) then return false end
    local ok = pcall(function()
        local hook = Webhook.new(url)
        hook.username = username or "Raps Plant"
        if avatarUrl ~= nil and avatarUrl ~= "" then
            hook.avatar_url = avatarUrl
        end
        hook.content = content or ""

        if embed ~= nil then
            hook.embed1.use = true
            hook.embed1.title = embed.title or ""
            hook.embed1.description = embed.description or ""
            hook.embed1.color = embed.color or 3447003
            if embed.footer ~= nil then
                hook.embed1.footer = embed.footer
            end
        end
        hook:send()
    end)
    return ok
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 18: PAYLOAD BUILDER                                          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Payload = {}

local function profileName(kind, botName)
    local p = (Config.WebhookProfile or {})[kind] or {}
    local name = tostring(p.name or "Raps Plant")
    local cleanBot = (botName ~= nil and botName ~= "") and removeColorSafe(botName) or "Raps Plant"
    name = name:gsub("{bot}", function() return cleanBot end)
    if #name > 80 then name = name:sub(1, 80) end
    return name, p.avatar
end

function Payload.build(username, avatarUrl, content, opts)
    opts = opts or {}

    local parts = {}
    table.insert(parts, '"title":' .. jsonStr(clip(opts.title or "", 250)))
    table.insert(parts, '"description":' .. jsonStr(clip(opts.description or "", 4000)))
    table.insert(parts, '"color":' .. tostring(math.floor(tonumber(opts.color) or 3447003)))
    table.insert(parts, '"timestamp":' .. jsonStr(os.date("!%Y-%m-%dT%H:%M:%SZ")))

    if opts.thumbnail ~= nil and opts.thumbnail ~= "" then
        table.insert(parts, '"thumbnail":{"url":' .. jsonStr(opts.thumbnail) .. '}')
    end

    table.insert(parts, '"footer":{"text":' .. jsonStr(clip(opts.footer or "Raps Plant DF", 200)) .. '}')

    if opts.fields ~= nil and #opts.fields > 0 then
        local fieldJson = {}
        for i, f in ipairs(opts.fields) do
            if i > 25 then break end
            table.insert(fieldJson,
                '{"name":' .. jsonStr(clip(f[1] or "-", 250)) ..
                ',"value":' .. jsonStr(clip(f[2] or "-", 1000)) ..
                ',"inline":' .. ((f[3] == false) and "false" or "true") .. '}')
        end
        table.insert(parts, '"fields":[' .. table.concat(fieldJson, ",") .. ']')
    end

    local allowed = (content ~= nil and content:find("@everyone")) and '{"parse":["everyone"]}' or '{"parse":[]}'
    local avatarPart = ""
    if avatarUrl ~= nil and avatarUrl ~= "" then
        avatarPart = ',"avatar_url":' .. jsonStr(avatarUrl)
    end

    return '{"username":' .. jsonStr(username or "Raps Plant") .. avatarPart ..
        ',"content":' .. jsonStr(content or "") ..
        ',"allowed_mentions":' .. allowed ..
        ',"embeds":[{' .. table.concat(parts, ",") .. '}]}'
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 19: LIVE DASHBOARD                                           ║
-- ║   1 pesan per bot, di-edit tiap webhookRefreshSec detik.                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Dashboard = {}

function Dashboard.tick(bot, forceNow)
    if not isValidWebhook(Config.MainWebhook) then return end

    local data = getOrInitBotData(bot)
    local now = os.time()
    local interval = Config.webhookRefreshSec or 10

    if not forceNow and (now - data.lastHookTime) < interval then return end
    data.lastHookTime = now

    local cleanName = removeColorSafe(bot.name)
    local isOnline = (bot.status == BotStatus.online)

    local seedId, seedName, seedCount = Seed.detect(bot)
    local activeWorld = data.activeWorld or "-"
    local activity = data.activity or "..."
    local ping = bot:getPing() or 0

    local runtime = formatDuration(now - (data.startTime or now))
    local worldRuntime = data.worldStart and formatDuration(now - data.worldStart) or "-"

    local description =
        (isOnline and emo("online") or emo("offline")) .. " **" .. tostring(bot.status) .. "**\n" ..
        emo("ping") .. " Ping: `" .. tostring(ping) .. " ms`\n" ..
        emo("work") .. " **Aktivitas:** " .. activity .. "\n" ..
        emo("world") .. " **World:** `" .. activeWorld .. "`\n" ..
        emo("time") .. " Update <t:" .. tostring(now) .. ":R>"

    local fields = {
        { emo("bot") .. " Bot",
          "Level `" .. tostring(bot.level or 0) .. "`\n" ..
          "Runtime `" .. runtime .. "`" },
        { emo("seed") .. " Seed",
          "Jenis `" .. tostring(seedName or "-") .. "`\n" ..
          "Di tas `" .. tostring(seedCount) .. "`\n" ..
          "Ditanam `" .. tostring(data.seedsPlanted or 0) .. "`" },
        { emo("world") .. " Progress",
          "World ini `" .. worldRuntime .. "`\n" ..
          "World selesai `" .. tostring(data.worldsDone or 0) .. "`\n" ..
          "World gagal `" .. tostring(data.worldsFailed or 0) .. "`" },
    }

    local color = 3066993
    if not isOnline then color = 15158332 end
    if isBanned(bot.status) then color = 10038562 end

    local senderName, senderAvatar = profileName("monitor", bot.name)
    local payload = Payload.build(senderName, senderAvatar, "", {
        title = emo("bot") .. " " .. cleanName,
        description = description,
        color = color,
        fields = fields,
        thumbnail = Config.Thumbnail and Config.Thumbnail.monitor,
        footer = "Raps Plant | Live Monitor | " .. localDate("%H:%M:%S"),
    })

    local baseUrl = cleanWebhookBase(Config.MainWebhook)

    -- Coba edit pesan lama
    if data.msgId ~= nil and data.msgId ~= "" then
        local status = Http.send(baseUrl .. "/messages/" .. data.msgId, Method.patch, payload, 8)
        if status == 200 or status == 204 then
            data.hookFails = 0
            return
        end
        if status ~= 404 then
            data.hookFails = (data.hookFails or 0) + 1
            if data.hookFails < 5 then return end
        end
        data.msgId = nil
        data.hookFails = 0
        setKeyValueInFile(Config.FileWebhookMsg, bot.name, "")
    end

    -- Kirim pesan baru
    local status, body = Http.send(baseUrl .. "?wait=true", Method.post, payload, 8)
    if (status == 200 or status == 204) and body ~= nil then
        local id = body:match('"id"%s*:%s*"(%d+)"')
        if id ~= nil and id ~= "" then
            data.msgId = id
            setKeyValueInFile(Config.FileWebhookMsg, bot.name, id)
        end
    end
end

liveWebhookTick = function()
    local bot = CurrentWorkerBot
    if bot == nil then return end
    pcall(function() Dashboard.tick(bot, false) end)
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 11 — HTTP + PAYLOAD + DASHBOARD                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 20: ALERTS                                                   ║
-- ║   Kirim alert ke NotifWebhook untuk event penting.                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Alert = {}

function Alert.send(bot, title, description, level, fields, tagEveryone)
    if not isValidWebhook(Config.NotifWebhook) then return end

    local colors = {
        info  = 3447003,
        warn  = 15105570,
        error = 15158332,
    }

    local cleanName = bot and removeColorSafe(bot.name) or "-"
    local senderName, senderAvatar = profileName("notif", cleanName)

    local payload = Payload.build(senderName, senderAvatar, tagEveryone and "@everyone" or "", {
        title = title,
        description = description,
        color = colors[level or "info"] or 3447003,
        fields = fields,
        thumbnail = Config.Thumbnail and Config.Thumbnail.alert,
        footer = "Raps Plant | " .. localDate("%d/%m/%Y %H:%M:%S") .. " " .. tostring(Config.timezoneLabel or "WIB"),
    })

    local baseUrl = cleanWebhookBase(Config.NotifWebhook)
    local status = Http.send(baseUrl .. "?wait=true", Method.post, payload, 10)

    if status ~= 200 and status ~= 204 then
        Http.fallbackSend(Config.NotifWebhook, senderName, senderAvatar, "", {
            title = title,
            description = description,
            color = colors[level or "info"],
        })
    end
end

function Alert.disconnected(bot)
    if bot == nil then return end
    Alert.send(bot,
        emo("offline") .. " Bot Disconnected",
        "Bot terputus dari server.",
        "warn",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
            { emo("world") .. " World", "`" .. tostring(getOrInitBotData(bot).activeWorld) .. "`" },
        }
    )
end

function Alert.reconnected(bot)
    if bot == nil then return end
    Alert.send(bot,
        emo("online") .. " Bot Reconnected",
        "Bot berhasil connect kembali.",
        "info",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
        }
    )
end

function Alert.banned(bot, statusText)
    if bot == nil then return end
    Alert.send(bot,
        emo("alert") .. " BOT KENA BAN",
        "Bot terkena ban / suspend.\nStatus: `" .. tostring(statusText or "-") .. "`",
        "error",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
        },
        true
    )
end

function Alert.worldSkipped(bot, worldName, reason)
    if bot == nil then return end
    Alert.send(bot,
        emo("warn") .. " World Dilewati",
        "World di-skip karena alasan tertentu.",
        "warn",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
            { emo("world") .. " World", "`" .. tostring(worldName) .. "`" },
            { "Alasan", tostring(reason) },
        }
    )
end

function Alert.storageEmpty(bot)
    if bot == nil then return end
    Alert.send(bot,
        emo("storage") .. " STORAGE SEED KOSONG",
        "Semua storage tidak ada seed. Bot tidak bisa plant.\nSilakan isi ulang storage.",
        "error",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
            { "Storage dicek", "`" .. tostring(#(Config.SeedStorages or {})) .. " world`" },
        },
        true
    )
end

function Alert.backpackFull(bot)
    if bot == nil then return end
    Alert.send(bot,
        emo("warn") .. " Backpack Hampir Penuh",
        "Inventory bot hampir penuh. Perlu drop item.",
        "warn",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
            { "Slot kosong", "`" .. tostring(Inv.emptySlots(bot)) .. "`" },
        }
    )
end

function Alert.proxySwitched(bot)
    if bot == nil then return end
    Alert.send(bot,
        emo("warn") .. " Proxy Diganti",
        "Bot switch proxy karena kena block / ban.",
        "info",
        {
            { emo("bot") .. " Bot", "`" .. removeColorSafe(bot.name) .. "`" },
        }
    )
end

-- Cek mass disconnect (banyak bot offline bersamaan)
local MassDisconnectState = { lastCheck = 0, lastCount = 0 }

function Alert.checkMassDisconnect()
    local now = os.time()
    if (now - MassDisconnectState.lastCheck) < 60 then return end
    MassDisconnectState.lastCheck = now

    local offline = 0
    local total = 0
    for _, b in pairs(getBots() or {}) do
        total = total + 1
        if b.status ~= BotStatus.online then offline = offline + 1 end
    end

    if total >= 2 and offline >= math.floor(total / 2) and offline > MassDisconnectState.lastCount then
        MassDisconnectState.lastCount = offline
        Alert.send(nil,
            emo("alert") .. " MASS DISCONNECT",
            "Banyak bot offline bersamaan. Kemungkinan masalah server.",
            "error",
            {
                { "Offline", "`" .. tostring(offline) .. "/" .. tostring(total) .. "`" },
                { "Waktu", "<t:" .. tostring(now) .. ":R>" },
            },
            true
        )
    end
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 21: WORLD RESULT REPORT                                      ║
-- ║   Kirim report ke ResultWebhook setelah world selesai.                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Report = {}

function Report.worldDone(bot, worldName, doorId, stats)
    if not isValidWebhook(Config.ResultWebhook) then return end
    if bot == nil then return end

    local cleanName = removeColorSafe(bot.name)
    local senderName, senderAvatar = profileName("result", cleanName)

    local description =
        emo("done") .. " **World Selesai!**\n\n" ..
        emo("world") .. " World: `" .. tostring(worldName) .. "`\n" ..
        emo("door") .. " Door: `" .. tostring(doorId or "-") .. "`\n" ..
        emo("bot") .. " Bot: `" .. cleanName .. "`\n" ..
        emo("time") .. " Waktu: `" .. formatDuration(stats.duration or 0) .. "`"

    local fields = {
        { emo("seed") .. " Seed Ditanam", "`" .. tostring(stats.seedsPlanted or 0) .. "`" },
        { emo("tree") .. " Pohon", "`" .. tostring(stats.trees or 0) .. "`" },
        { "Tile Ditolak", "`" .. tostring(stats.refused or 0) .. "`" },
    }

    local payload = Payload.build(senderName, senderAvatar, "", {
        title = emo("done") .. " World Done",
        description = description,
        color = 3066993,
        fields = fields,
        thumbnail = Config.Thumbnail and Config.Thumbnail.result,
        footer = "Raps Plant | " .. localDate("%d/%m/%Y %H:%M:%S"),
    })

    local baseUrl = cleanWebhookBase(Config.ResultWebhook)
    local status = Http.send(baseUrl .. "?wait=true", Method.post, payload, 10)

    if status ~= 200 and status ~= 204 then
        Http.fallbackSend(Config.ResultWebhook, senderName, senderAvatar, "", {
            title = "World Done",
            description = description,
            color = 3066993,
        })
    end
end

function Report.worldFailed(bot, worldName, doorId, reason)
    if not isValidWebhook(Config.ResultWebhook) then return end
    if bot == nil then return end

    local cleanName = removeColorSafe(bot.name)
    local senderName, senderAvatar = profileName("result", cleanName)

    local description =
        emo("warn") .. " **World Gagal**\n\n" ..
        emo("world") .. " World: `" .. tostring(worldName) .. "`\n" ..
        emo("door") .. " Door: `" .. tostring(doorId or "-") .. "`\n" ..
        emo("bot") .. " Bot: `" .. cleanName .. "`\n" ..
        "Alasan: " .. tostring(reason or "-")

    local payload = Payload.build(senderName, senderAvatar, "", {
        title = emo("warn") .. " World Failed",
        description = description,
        color = 15105570,
        thumbnail = Config.Thumbnail and Config.Thumbnail.alert,
        footer = "Raps Plant | " .. localDate("%d/%m/%Y %H:%M:%S"),
    })

    local baseUrl = cleanWebhookBase(Config.ResultWebhook)
    local status = Http.send(baseUrl .. "?wait=true", Method.post, payload, 10)

    if status ~= 200 and status ~= 204 then
        Http.fallbackSend(Config.ResultWebhook, senderName, senderAvatar, "", {
            title = "World Failed",
            description = description,
            color = 15105570,
        })
    end
end

function Report.worldNuked(bot, worldName, doorId, reason)
    if not isValidWebhook(Config.ResultWebhook) then return end
    if bot == nil then return end

    local cleanName = removeColorSafe(bot.name)
    local senderName, senderAvatar = profileName("result", cleanName)

    local description =
        emo("alert") .. " **World Nuked (Skip Total)**\n\n" ..
        emo("world") .. " World: `" .. tostring(worldName) .. "`\n" ..
        emo("door") .. " Door: `" .. tostring(doorId or "-") .. "`\n" ..
        emo("bot") .. " Bot: `" .. cleanName .. "`\n" ..
        "Alasan: " .. tostring(reason or "-")

    local payload = Payload.build(senderName, senderAvatar, "", {
        title = emo("alert") .. " World Nuked",
        description = description,
        color = 10038562,
        thumbnail = Config.Thumbnail and Config.Thumbnail.alert,
        footer = "Raps Plant | " .. localDate("%d/%m/%Y %H:%M:%S"),
    })

    local baseUrl = cleanWebhookBase(Config.ResultWebhook)
    Http.send(baseUrl .. "?wait=true", Method.post, payload, 10)
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 12 — ALERTS + REPORT                                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 22: SAFETY CHECK                                             ║
-- ║   Cek status bot: banned, disconnect, reconnect.                         ║
-- ║   Return: "ok" | "reconnect" | "stop"                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Safety = {}

function Safety.check(bot)
    if bot == nil then return "stop" end

    local st = bot.status

    -- Bot banned / suspended / location banned → stop permanen
    if isBanned(st) then
        local wasReported = getOrInitBotData(bot).banReported
        if not wasReported then
            getOrInitBotData(bot).banReported = true
            setBotActivity(bot, "BOT KENA BAN: " .. tostring(st))
            Alert.banned(bot, st)

            local activeWorld = getOrInitBotData(bot).activeWorld or "-"
            if activeWorld ~= "-" then
                WorldQueue.finish(bot, activeWorld, "", "failed", "banned")
            end
        end
        return "stop"
    end

    -- Butuh switch proxy (location ban, http block, dll)
    if Proxy.shouldSwitch(st) then
        local switched = Proxy.trySwitch(bot)
        if switched then
            Alert.proxySwitched(bot)
            sleep(3000)
            return "reconnect"
        end
    end

    -- Bot disconnect → coba reconnect
    if not isConnected(st) then
        local wasReported = getOrInitBotData(bot).disconnectReported
        if not wasReported then
            getOrInitBotData(bot).disconnectReported = true
            Alert.disconnected(bot)
            addHistory("Bot " .. removeColorSafe(bot.name) .. ": disconnect (" .. tostring(st) .. ")")
        end

        pcall(function() bot.auto_reconnect = true end)
        if st == BotStatus.offline or st == BotStatus.stopped then
            pcall(function() bot:connect() end)
        end

        local ok = Conn.waitOnline(bot, Config.ReconnectWaitSec or 15)
        if ok then
            getOrInitBotData(bot).disconnectReported = false
            Alert.reconnected(bot)
            addHistory("Bot " .. removeColorSafe(bot.name) .. ": reconnect sukses")
            Conn.waitBackpack(bot, 30)
            return "reconnect"
        end
        return "stop"
    end

    getOrInitBotData(bot).disconnectReported = false
    getOrInitBotData(bot).banReported = false
    return "ok"
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 23: WORKER LOOP PER BOT                                      ║
-- ║   1 bot = 1 worker loop. Claim world → plant → finish → ulang.          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Worker = {}

function Worker.oneCycle(bot)
    -- 1. Safety check
    local safetyStatus = Safety.check(bot)
    if safetyStatus == "stop" then return false end
    if safetyStatus == "reconnect" then
        sleep(2000)
        return true
    end

    -- 2. Claim world dari queue
    local worldName, doorId, source = WorldQueue.claim(bot)
    if worldName == nil then
        setBotActivity(bot, "Idle — menunggu world baru...")
        return false
    end

    setBotActivity(bot, "Ambil world " .. worldName .. " (" .. tostring(source) .. ")", worldName)
    addHistory("Bot " .. removeColorSafe(bot.name) .. ": ambil " .. worldName .. " (" .. tostring(source) .. ")")

    -- 3. Plant di world
    local stats = Plant.doWorld(bot, worldName, doorId)

    -- 4. Handle hasil
    if stats.success then
        stats.trees = stats.seedsPlanted or 0

        local finished = WorldQueue.finish(bot, worldName, doorId, "done",
            "seeds=" .. tostring(stats.seedsPlanted))

        local data = getOrInitBotData(bot)
        data.worldStart = nil

        if finished then
            -- Bot ini yang finish duluan, report
            Report.worldDone(bot, worldName, doorId, stats)
            data.worldsDone = (data.worldsDone or 0) + 1
            setBotActivity(bot, "World selesai: " .. worldName ..
                " (" .. tostring(stats.seedsPlanted) .. " seed)")

            if Refill.shouldReturnLeftover(bot) then
                setBotActivity(bot, "Kembalikan sisa seed ke storage...")
                Refill.returnLeftover(bot, nil)
            end
            Dashboard.tick(bot, true)
        else
            addHistory("Bot " .. removeColorSafe(bot.name) ..
                ": " .. worldName .. " sudah di-finish bot lain")
            setBotActivity(bot, "World selesai (bot lain): " .. worldName)
        end
    else
        local reason = stats.reason or "unknown"

        if reason == "fire world" then
            WorldQueue.finish(bot, worldName, doorId, "nuked", reason)
            Report.worldNuked(bot, worldName, doorId, reason)
            Alert.worldSkipped(bot, worldName, reason)
        elseif reason == "no seed" then
            WorldQueue.finish(bot, worldName, doorId, "failed", reason)
            Report.worldFailed(bot, worldName, doorId, reason)
            Alert.storageEmpty(bot)
            sleep(30000)
        elseif reason == "warp failed" then
            WorldQueue.finish(bot, worldName, doorId, "failed", reason)
            Report.worldFailed(bot, worldName, doorId, reason)
        elseif reason == "taken over" then
            -- Jangan finish, world sudah diambil bot lain
            addHistory("Bot " .. removeColorSafe(bot.name) .. ": " .. worldName .. " taken over")
        else
            WorldQueue.finish(bot, worldName, doorId, "failed", reason)
            Report.worldFailed(bot, worldName, doorId, reason)
            Alert.worldSkipped(bot, worldName, reason)
        end

        local data = getOrInitBotData(bot)
        data.worldsFailed = (data.worldsFailed or 0) + 1
        data.worldStart = nil
        setBotActivity(bot, "World gagal: " .. worldName .. " (" .. reason .. ")")
        Dashboard.tick(bot, true)
    end

    return true
end

function Worker.loop(bot)
    CurrentWorkerBot = bot

    local data = getOrInitBotData(bot)
    data.startTime = os.time()

    setBotActivity(bot, "Inisialisasi bot...")
    pcall(function()
        bot.anti_fire = true
        bot.anti_toxic = true
        bot.auto_trash = false
    end)

    local ok = Conn.waitOnline(bot, 60)
    if not ok then
        setBotActivity(bot, "Gagal connect, coba lagi...")
        sleep(10000)
    end

    Conn.waitBackpack(bot, 30)
    sleep(1000 + getNextBotRandom(bot, 0, 3000))
    Dashboard.tick(bot, true)

    addHistory("Bot " .. removeColorSafe(bot.name) .. ": worker loop dimulai")

    local idleCount = 0
    local maxIdle = 30

    while true do
        local ok, err = pcall(function()
            local gotWork = Worker.oneCycle(bot)

            if gotWork then
                idleCount = 0
                sleep(500 + getNextBotRandom(bot, 0, 1000))
            else
                idleCount = idleCount + 1
                setBotActivity(bot, "Idle... (" .. tostring(idleCount) .. "/" .. tostring(maxIdle) .. ")")
                sleep(5000)

                if idleCount % 10 == 0 then
                    Alert.checkMassDisconnect()
                end

                if idleCount >= maxIdle then
                    idleCount = 0
                    addHistory("Bot " .. removeColorSafe(bot.name) .. ": idle terlalu lama, refresh...")
                    sleep(15000)
                end
            end
        end)

        if not ok then
            addHistory("Bot " .. removeColorSafe(bot.name) .. ": ERROR " .. tostring(err))
            devLog(bot, "worker_error", tostring(err))
            sleep(3000)
        end
    end
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 24: STARTUP & CLEANUP                                        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Startup = {}

function Startup.setupFiles()
    pcall(function() os.execute('mkdir "plant_data" 2>nul') end)
    pcall(function() os.execute('attrib +h "plant_data"') end)
end

function Startup.validateConfig()
    local errors = {}

    if Config.SeedStorages == nil or #Config.SeedStorages == 0 then
        table.insert(errors, "SeedStorages kosong — bot tidak bisa refill seed")
    end
    if Config.AutoDetectSeed == false and Config.SeedId == 0 then
        table.insert(errors, "AutoDetectSeed = false tapi SeedId = 0")
    end
    if Config.BotsPerWorld < 1 then
        table.insert(errors, "BotsPerWorld minimal 1")
    end
    if Config.MainWebhook == "" and Config.NotifWebhook == "" and Config.ResultWebhook == "" then
        table.insert(errors, "Semua webhook kosong — tidak ada notifikasi Discord")
    end

    if #errors > 0 then
        print("[WARN] Config issue:")
        for _, err in ipairs(errors) do print("  - " .. err) end
    end
    return #errors == 0
end

function Startup.cleanup()
    print("[CLEANUP] Releasing locks...")
    for _, b in pairs(getBots() or {}) do
        pcall(function() StorageLock.release(b) end)
    end
    for _, b in pairs(getBots() or {}) do
        pcall(function() WorldQueue.unlock(b) end)
    end
    print("[CLEANUP] Done")
end

function on_stop(error_message)
    if error_message ~= "" and error_message ~= nil then
        print("[STOP] Script stopped with error: " .. tostring(error_message))
    else
        print("[STOP] Script stopped cleanly")
    end
    pcall(Startup.cleanup)
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 25: SPAWN WORKER                                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Spawn = {}
local SpawnedBots = {}

function Spawn.one(bot)
    if bot == nil then return end
    local key = removeColorSafe(bot.name):upper()
    if SpawnedBots[key] then return end
    SpawnedBots[key] = true

    print("[SPAWN] Starting worker for bot: " .. removeColorSafe(bot.name))

    runThread(function()
        local ok, err = pcall(Worker.loop, bot)
        if not ok then
            print("[THREAD ERROR] Bot " .. removeColorSafe(bot.name) .. ": " .. tostring(err))
            SpawnedBots[key] = nil
        end
    end)
end

function Spawn.all()
    local count = 0
    for _, bot in pairs(getBots() or {}) do
        if bot.status == BotStatus.online or bot.status == BotStatus.offline then
            Spawn.one(bot)
            count = count + 1
        end
    end
    return count
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   ❌ BAGIAN 26: MAIN                                                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function Main()
    print("========================================")
    print("  RAPS AUTO PLANT - MULTIBOT")
    print("  Lucifer Lua v2.86")
    print("========================================")

    Startup.setupFiles()
    Startup.validateConfig()

    local botCount = Spawn.all()
    print("[INIT] " .. tostring(botCount) .. " bot terdeteksi, worker di-spawn")

    if botCount == 0 then
        print("[ERROR] Tidak ada bot. Pastikan bot sudah login di Lucifer.")
        return
    end

    local lastSpawnCheck = 0
    local lastMassCheck = 0

    while true do
        sleep(5000)

        if (os.time() - lastSpawnCheck) >= 30 then
            lastSpawnCheck = os.time()
            local newSpawn = Spawn.all()
            if newSpawn > 0 then
                print("[MONITOR] " .. tostring(newSpawn) .. " bot di-spawn (baru)")
            end
        end

        if (os.time() - lastMassCheck) >= 60 then
            lastMassCheck = os.time()
            pcall(Alert.checkMassDisconnect)
        end

        for _, bot in pairs(getBots() or {}) do
            pcall(function() Dashboard.tick(bot, false) end)
        end
    end
end


-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   STARTUP GUARD (retry kalau crash)                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

print("[BOOT] Raps Auto Plant starting...")

while true do
    local ok, err = pcall(Main)
    if not ok then
        print("[FATAL] Main crash: " .. tostring(err))
        addHistory("FATAL: " .. tostring(err))
        pcall(Startup.cleanup)
    else
        print("[INFO] Main exited normally, restarting in 15s...")
    end
    sleep(15000)
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║   END CHUNK 13 — FINAL                                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
