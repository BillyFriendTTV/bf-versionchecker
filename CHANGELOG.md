# 🚀 BillyFriend Version Checker

> A lightweight FiveM resource that automatically checks GitHub for updates and reports the status directly in the server console.

---

## 📦 Version `1.0.0`

**Released:** `August 22, 2026`

### 🟢 Added

* ✅ GitHub version checking
* ✅ Automatic version detection from `fxmanifest.lua`
* ✅ Current version display
* ✅ Latest version display
* ✅ Automatic update detection
* ✅ GitHub download link support
* ✅ Colored FiveM console messages
* ✅ `UP TO DATE` status
* ✅ `UPDATE AVAILABLE` status
* ✅ `CHECK FAILED` status
* ✅ HTTP error reporting
* ✅ Invalid `version.json` detection
* ✅ Semantic version comparison
* ✅ Configurable GitHub repository
* ✅ Configurable version check delay

---

## 🎨 Console Improvements

The version checker includes a formatted console display:

```text
============================================================
              BILLYFRIEND RESOURCES
                 VERSION CHECKER
============================================================
 Resource     : bf-versionchecker
 Installed    : v1.0.0
 Latest       : v1.0.0

 Status       : UP TO DATE

 GitHub       : BillyFriendTTV/bf-versionchecker
------------------------------------------------------------
```

### Status Colors

| Status                | Color  | Meaning                                |
| --------------------- | ------ | -------------------------------------- |
| 🟢 `UP TO DATE`       | Green  | Resource is running the latest version |
| 🟡 `UPDATE AVAILABLE` | Yellow | A newer version is available           |
| 🔴 `CHECK FAILED`     | Red    | Version check could not be completed   |

---

## 🔄 Version Comparison

The version checker supports semantic versioning.

```text
MAJOR.MINOR.PATCH
```

Example:

```text
1.2.3
```

### 🔵 MAJOR

Breaking changes or major rewrites.

```text
1.0.0 → 2.0.0
```

### 🟣 MINOR

New features and improvements.

```text
1.0.0 → 1.1.0
```

### 🟢 PATCH

Bug fixes and small changes.

```text
1.0.0 → 1.0.1
```

---

## 🛠️ Configuration

GitHub repository settings can be configured inside `server.lua`:

```lua
local GITHUB_USER = "BillyFriendTTV"
local GITHUB_REPO = "bf-versionchecker"
local GITHUB_BRANCH = "main"

local VERSION_FILE = "version.json"

local CHECK_DELAY = 5000
```

---

## 🌐 GitHub

**Repository**

`BillyFriendTTV/bf-versionchecker`

**Version File**

`version.json`

Example:

```json
{
    "version": "1.0.0",
    "download": "https://github.com/BillyFriendTTV/bf-versionchecker/releases"
}
```

---

# 📋 Unreleased

> 🚧 Changes currently being developed.

### 🟢 Added

* Future features will be listed here.

### 🟡 Changed

* Future improvements will be listed here.

### 🔴 Fixed

* Future bug fixes will be listed here.

### ⚫ Removed

* Future removals will be listed here.

---

# 📜 Release History

|   Version  | Release Date |      Status     |
| :--------: | :----------: | :-------------: |
| 🟢 `1.0.0` | `2026-08-22` | Initial Release |

---

## 💡 Development

Developed by **BillyFriendTTV**

> Built for FiveM developers and server owners.

---

### ⭐ Support

If you find this resource useful, consider giving the repository a ⭐ on GitHub.

**Thank you for using BillyFriend Resources!**
