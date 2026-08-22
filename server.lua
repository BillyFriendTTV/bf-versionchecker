local RESOURCE_NAME = GetCurrentResourceName()

local GITHUB_USER = "BillyFriendTTV"
local GITHUB_REPO = "bf-versionchecker"
local GITHUB_BRANCH = "main"

local VERSION_FILE = "version.json"
local CHECK_DELAY = 5000

local VERSION_URL = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/%s",
    GITHUB_USER,
    GITHUB_REPO,
    GITHUB_BRANCH,
    VERSION_FILE
)

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

local function ParseVersion(version)
    version = tostring(version or "")
    version = version:gsub("^v", "")

    local major, minor, patch = version:match(
        "^(%d+)%.(%d+)%.(%d+)"
    )

    if not major then
        return nil
    end

    return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch)
    }
end

local function IsUpdateAvailable(current, latest)
    local currentVersion = ParseVersion(current)
    local latestVersion = ParseVersion(latest)

    if not currentVersion or not latestVersion then
        return false
    end

    if latestVersion.major ~= currentVersion.major then
        return latestVersion.major > currentVersion.major
    end

    if latestVersion.minor ~= currentVersion.minor then
        return latestVersion.minor > currentVersion.minor
    end

    return latestVersion.patch > currentVersion.patch
end

local function PrintHeader()

    print("")
    print("^5============================================================^7")
    print("^5              BILLYFRIEND RESOURCES^7")
    print("^6                 VERSION CHECKER^7")
    print("^5============================================================^7")

end

local function PrintFooter()

    print("^5------------------------------------------------------------^7")
    print("")

end

local function CheckForUpdates()

    local currentVersion = GetInstalledVersion()

    PerformHttpRequest(
        VERSION_URL,
        function(statusCode, response)

            PrintHeader()

            print(
                "^7 Resource     : " ..
                Colors.cyan ..
                RESOURCE_NAME ..
                Colors.reset
            )

            print(
                "^7 Installed    : " ..
                Colors.white ..
                "v" ..
                currentVersion ..
                Colors.reset
            )

            if statusCode ~= 200 then

                print(
                    "^7 Latest       : " ..
                    Colors.red ..
                    "Unable to check" ..
                    Colors.reset
                )

                print("")

                print(
                    "^7 Status       : " ..
                    Colors.red ..
                    "CHECK FAILED" ..
                    Colors.reset
                )

                print(
                    "^7 HTTP Code    : " ..
                    Colors.red ..
                    tostring(statusCode) ..
                    Colors.reset
                )

                PrintFooter()

                return

            end

            local success, data = pcall(
                json.decode,
                response
            )

            if not success or not data then

                print(
                    "^7 Latest       : " ..
                    Colors.red ..
                    "Invalid version.json" ..
                    Colors.reset
                )

                print("")

                print(
                    "^7 Status       : " ..
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
                    "^7 Latest       : " ..
                    Colors.red ..
                    "Unknown" ..
                    Colors.reset
                )

                print("")

                print(
                    "^7 Status       : " ..
                    Colors.red ..
                    "CHECK FAILED" ..
                    Colors.reset
                )

                PrintFooter()

                return

            end

            print(
                "^7 Latest       : " ..
                Colors.white ..
                "v" ..
                latestVersion ..
                Colors.reset
            )

            print("")

            if IsUpdateAvailable(
                currentVersion,
                latestVersion
            ) then

                print(
                    "^7 Status       : " ..
                    Colors.yellow ..
                    "UPDATE AVAILABLE" ..
                    Colors.reset
                )

                if data.download then

                    print("")

                    print(
                        "^7 Download     : " ..
                        Colors.cyan ..
                        data.download ..
                        Colors.reset
                    )

                end

            else

                print(
                    "^7 Status       : " ..
                    Colors.green ..
                    "UP TO DATE" ..
                    Colors.reset
                )

            end

            print("")

            print(
                "^7 GitHub       : " ..
                Colors.cyan ..
                GITHUB_USER ..
                "/" ..
                GITHUB_REPO ..
                Colors.reset
            )

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

CreateThread(function()

    Wait(CHECK_DELAY)

    print(
        Colors.purple ..
        "[" ..
        RESOURCE_NAME ..
        "]" ..
        Colors.reset ..
        " Checking for updates..."
    )

    CheckForUpdates()

end)