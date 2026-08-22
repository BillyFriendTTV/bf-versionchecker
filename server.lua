local RESOURCE_NAME = GetCurrentResourceName()

-- =========================================================
-- CONFIGURATION
-- =========================================================

local GITHUB_USER = "BillyFriendTTV"
local GITHUB_REPO = "bf-versionchecker"
local GITHUB_BRANCH = "main"

local VERSION_FILE = "version.json"

-- How long to wait after the resource starts before checking
local CHECK_DELAY = 5000

-- =========================================================
-- COLORS
-- =========================================================

local Colors = {
    reset = "^0",
    red = "^1",
    green = "^2",
    yellow = "^3",
    blue = "^4",
    purple = "^5",
    cyan = "^6",
    white = "^7"
}

-- =========================================================
-- GITHUB URL
-- =========================================================

local VERSION_URL = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/%s",
    GITHUB_USER,
    GITHUB_REPO,
    GITHUB_BRANCH,
    VERSION_FILE
)

-- =========================================================
-- GET INSTALLED VERSION
-- =========================================================

local function GetInstalledVersion()
    local version = GetResourceMetadata(
        RESOURCE_NAME,
        "version",
        0
    )

    if not version or version == "" then
        return "unknown"
    end

    return version
end

-- =========================================================
-- VERSION PARSER
-- =========================================================

local function ParseVersion(version)
    version = tostring(version or "")
    version = version:gsub("^v", "")

    local major, minor, patch = version:match("^(%d+)%.(%d+)%.(%d+)")

    if not major then
        return nil
    end

    return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch)
    }
end

-- =========================================================
-- VERSION COMPARISON
-- =========================================================

local function IsUpdateAvailable(current, latest)
    local currentVersion = ParseVersion(current)
    local latestVersion = ParseVersion(latest)

    if not currentVersion or not latestVersion then
        return false
    end

    if latestVersion.major > currentVersion.major then
        return true
    end

    if latestVersion.major < currentVersion.major then
        return false
    end

    if latestVersion.minor > currentVersion.minor then
        return true
    end

    if latestVersion.minor < currentVersion.minor then
        return false
    end

    if latestVersion.patch > currentVersion.patch then
        return true
    end

    return false
end

-- =========================================================
-- PRINT HEADER
-- =========================================================

local function PrintHeader()
    print("")
    print("^5╔══════════════════════════════════════════════════════════╗^7")
    print("^5║                 BILLYFRIEND RESOURCES                    ║^7")
    print("^5╠══════════════════════════════════════════════════════════╣^7")
end

-- =========================================================
-- PRINT FOOTER
-- =========================================================

local function PrintFooter()
    print("^5╚══════════════════════════════════════════════════════════╝^7")
    print("")
end

-- =========================================================
-- VERSION CHECK
-- =========================================================

local function CheckForUpdates()

    local currentVersion = GetInstalledVersion()

    PerformHttpRequest(
        VERSION_URL,
        function(statusCode, response)

            PrintHeader()

            print(
                "^5║^7 Resource:  " ..
                Colors.cyan ..
                RESOURCE_NAME ..
                Colors.reset
            )

            print(
                "^5║^7 Installed: " ..
                Colors.white ..
                "v" .. currentVersion ..
                Colors.reset
            )

            -- Request failed
            if statusCode ~= 200 then

                print(
                    "^5║^7 Latest:    " ..
                    Colors.red ..
                    "Unable to check" ..
                    Colors.reset
                )

                print(
                    "^5║^7 Status:    " ..
                    Colors.red ..
                    "CHECK FAILED" ..
                    Colors.reset
                )

                print(
                    "^5║^7 HTTP Code: " ..
                    Colors.red ..
                    tostring(statusCode) ..
                    Colors.reset
                )

                PrintFooter()

                return
            end

            -- Decode JSON
            local success, data = pcall(json.decode, response)

            if not success or not data then

                print(
                    "^5║^7 Latest:    " ..
                    Colors.red ..
                    "Invalid version.json" ..
                    Colors.reset
                )

                print(
                    "^5║^7 Status:    " ..
                    Colors.red ..
                    "CHECK FAILED" ..
                    Colors.reset
                )

                PrintFooter()

                return
            end

            local latestVersion = data.version

            if not latestVersion then

                print(
                    "^5║^7 Latest:    " ..
                    Colors.red ..
                    "Unknown" ..
                    Colors.reset
                )

                print(
                    "^5║^7 Status:    " ..
                    Colors.red ..
                    "CHECK FAILED" ..
                    Colors.reset
                )

                PrintFooter()

                return
            end

            print(
                "^5║^7 Latest:    " ..
                Colors.white ..
                "v" .. latestVersion ..
                Colors.reset
            )

            -- Check version
            if IsUpdateAvailable(currentVersion, latestVersion) then

                print(
                    "^5║^7 Status:    " ..
                    Colors.yellow ..
                    "UPDATE AVAILABLE" ..
                    Colors.reset
                )

                if data.download then
                    print("^5╠══════════════════════════════════════════════════════════╣^7")
                    print(
                        "^5║^7 Download:  " ..
                        Colors.cyan ..
                        data.download ..
                        Colors.reset
                    )
                end

            else

                print(
                    "^5║^7 Status:    " ..
                    Colors.green ..
                    "UP TO DATE ✓" ..
                    Colors.reset
                )

            end

            PrintFooter()

        end,
        "GET",
        "",
        {
            ["Content-Type"] = "application/json",
            ["User-Agent"] = "FiveM-Version-Checker"
        }
    )
end

-- =========================================================
-- RESOURCE START
-- =========================================================

CreateThread(function()

    Wait(CHECK_DELAY)

    print(
        "^5[" ..
        RESOURCE_NAME ..
        "]^7 Checking for updates..."
    )

    CheckForUpdates()

end)