Config = {}

Config.Options = {
    ["repair"] = {
        name = "Repair",
        icon = "fas fa-wrench",
    },
    ["perfomance"] = {
        name = "Performance",
        icon = "fa-solid fa-gears",
    },
    ["cosmetics"] = {
        name = "Cosmetics",
        icon = "fa-solid fa-wand-magic-sparkles",
    },
    ["colours"] = {
        name = "Colours",
        icon = "fas fa-palette",
    },
    ["wheels"] = {
        name = "Wheels",
        --Icon is defined in icons.ts
    },
}

Config.Prices = {
    -- Engine = {0, 3250, 5500, 10450, 15250, 20500}, you can override specific prices like this
    ["repair"] = 1000,
    ["performance"] = {0, 3250, 5500, 10450, 15250, 20500},
    ["cosmetics"] = 500,
    ["colours"] = 100,
    ["wheels"] = 1000,
}

Config.Spots = {
    ["Benny's"] = {
        name = "Benny's",
        coords = vec3(-211.85, -1324.0, 30.0),
        size = vec3(6.0, 8.25, 15.0),
        rotation = 0.0,
        allowed = {
            repair = true,
            perfomance = true,
            colours = true,
            cosmetics = true,
            wheels = true,
        }
    }
}

