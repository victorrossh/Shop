# AMX Mod X Shop API Plugin

## Overview

This AMX Mod X plugin provides a flexible Shop API that allows server administrators to create and manage in-game shops. Server administrators can easily extend the functionality by adding new items to the shop using the provided API.

**Note:** This plugin depends on the [Inventory plugin](https://github.com/human416c6578/Inventory) to manage player inventories.

## Features

- **Dynamic Shop Items:** Easily add new items to the shop through plugin natives.
- **Credit System:** Utilizes a credit system for purchasing items, allowing customization of in-game currency.
- **Item Availability:** Checks for user credits and previous purchases before allowing the purchase of an item.
- **Logging:** Logs all purchases to a dedicated shop log file for server administrators to track transactions.


## Plugin Natives

### `register_item(item_name[], callback_function[], plugin[], cost, itemID)`

Registers a new item in the shop with the specified details.

- `item_name`: The name of the item displayed in the shop.
- `callback_function`: The callback function to be executed upon purchasing the item.
- `plugin`: The plugin name associated with the item.
- `cost`: The cost of the item in credits.
- `itemID`: The unique identifier for the item.

### `open_shop_menu(id)`

Opens the shop menu for the specified player.

- `id`: The player's ID.

## Usage

1. Add new items to the shop using the `register_item` native.
2. Players can open the shop menu by typing `/shop` in the game.
3. Players can navigate through the shop menu, view item details, and purchase items using their in-game credits.
