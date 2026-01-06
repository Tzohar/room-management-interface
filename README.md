# 🧩 Room Management Interface

A modular backend & frontend UI framework for Roblox enabling players to create, customize, and manage game lobbies via a sleek step-by-step wizard. Optimal for server management.
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/Tzohar/room-management-interface/blob/main/media/Roblox1.gif?raw=true" width="100%" />
      <br>
    </td>
    <td align="center">
      <img src="https://github.com/Tzohar/room-management-interface/blob/main/media/Roblox2.gif?raw=true" width="100%" />
      <br>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/Tzohar/room-management-interface/blob/main/media/Roblox3.gif?raw=true" width="100%" />
      <br>
    </td>
    <td align="center">
      <img src="https://github.com/Tzohar/room-management-interface/blob/main/media/Roblox4.gif?raw=true" width="100%" />
      <br>
    </td>
  </tr>
</table>

## ✨ Key Features

* **Wizard Design Pattern:** Splits complex data entry into digestible steps (Details → Genres → Settings → Maps).
* **Reactive Animations:** Uses a custom `TweenService` implementation for smooth hover effects, window slides, and page transitions.
* **Strict Validation:** Real-time input sanitization (Regex) and server-side Asset ID verification for room icons.
* **State Management:** Temporarily caches user input in a local state table, only committing to the server upon final validation.
* **Dynamic Scrolling:** Custom-scripted scroll interactions for selecting maps and genres.

## 🏗️ Architecture

The system is built on a strictly modular architecture to separate logic (controllers) from visuals (view).

```lua
game/
├── ⚙️ ServerScriptService      -- [Backend Logic]
│   ├── 📜 ActiveRoomsHandle    -- Manages the lifecycle of active lobbies
│   ├── 📜 RoomStorage          -- Handles data serialization for room states
│   ├── 📜 SendUserToServer     -- TeleportService wrapper for moving players
│   ├── 📦 RoomClass            -- OOP Class structure for Room Objects
│   └── 📦 UserData             -- DataStoreService wrapper for player persistence
│
└── 🖥️ StarterGui               -- [Frontend UI]
    ├── 📂 Modules              -- (Reusable Logic & State Managers)
    │   ├── 📂 Genres           -- Configuration for room genre tags
    │   ├── 📦 AlertModule      -- Global error handling & notification system
    │   ├── 📦 WindowsManager   -- Handling Z-Index, focus, and window transitions
    │   ├── 📦 RoomInterface    -- Factory module for creating Room list items
    │   │   └── 🖼️ RoomTemplate -- Serialized UI template for room entries
    │   ├── 📦 RoomInfo         -- Logic for the "Details" popup window
    │   ├── 📦 CreateRoom       -- State Manager for creation wizard
    │   │   ├── 📦 Step1 (Details)
    │   │   ├── 📦 Step2 (Genres)
    │   │   ├── 📦 Step3 (Settings)
    │   │   └── 📦 Step4 (Maps)
    │   └── 📦 EditRoom         -- State Manager for editing wizard
    │       ├── 📦 Step1
    │       ├── 📦 Step2
    │       ├── 📦 Step3
    │       └── 📦 Step4
    │
    └── 📂 Scripts              -- (Local Entry Points)
        ├── 📜 Discover         -- Handles the main lobby browser feed
        ├── 📜 WindowsSwitchButtons -- Logic for sidebar navigation
        └── 📜 YoursRoomsMenuManager -- Logic for the "My Rooms" tab
