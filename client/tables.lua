ModTypes = {
    [0] = {name = "VMT_SPOILER", label = "Spoiler", num = 0},
    [1] = {name = "VMT_BUMPER_F", label = "Front Bumper", num = 1},
    [2] = {name = "VMT_BUMPER_R", label = "Rear Bumper", num = 2},
    [3] = {name = "VMT_SKIRT", label = "Side Skirt", num = 3},
    [4] = {name = "VMT_EXHAUST", label = "Exhaust", num = 4},
    [5] = {name = "VMT_CHASSIS", label = "Frame", num = 5},
    [6] = {name = "VMT_GRILL", label = "Grille", num = 6},
    [7] = {name = "VMT_BONNET", label = "Hood", num = 7},
    [8] = {name = "VMT_WING_L", label = "Fender L", num = 8},
    [9] = {name = "VMT_WING_R", label = "Fender R", num = 9},
    [10] = {name = "VMT_ROOF", label = "Roof", num = 10},
    [11] = {name = "VMT_ENGINE", label = "Engine", num = 11},
    [12] = {name = "VMT_BRAKES", label = "Brakes", num = 12},
    [13] = {name = "VMT_GEARBOX", label = "Gearbox", num = 13},
    [14] = {name = "VMT_HORN", label = "Horn", num = 14},
    [15] = {name = "VMT_SUSPENSION", label = "Suspension", num = 15},
    [16] = {name = "VMT_ARMOUR", label = "Armour", num = 16},
    [17] = {name = "VMT_NITROUS", label = "Nitrous", num = 17},
    [18] = {name = "VMT_TURBO", label = "Turbo", num = 18},
    [19] = {name = "VMT_SUBWOOFER", label = "Subwoofer", num = 19},
    [20] = {name = "VMT_TYRE_SMOKE", label = "Tyre Smoke", num = 20},
    [21] = {name = "VMT_HYDRAULICS", label = "Hydraulics", num = 21},
    [22] = {name = "VMT_XENON_LIGHTS", label = "Xenon Lights", num = 22},
    [23] = {name = "VMT_WHEELS", label = "Wheels", num = 23},
    [24] = {name = "VMT_WHEELS_REAR_OR_HYDRAULICS", label = "Wheels (Rear) or Hydraulics", num = 24},
    [25] = {name = "VMT_PLTHOLDER", label = "Plate Holder", num = 25},
    [26] = {name = "VMT_PLTVANITY", label = "Plate Vanity", num = 26},
    [27] = {name = "VMT_INTERIOR1", label = "Interior 1", num = 27},
    [28] = {name = "VMT_INTERIOR2", label = "Interior 2", num = 28},
    [29] = {name = "VMT_INTERIOR3", label = "Interior 3", num = 29},
    [30] = {name = "VMT_INTERIOR4", label = "Interior 4", num = 30},
    [31] = {name = "VMT_INTERIOR5", label = "Interior 5", num = 31},
    [32] = {name = "VMT_SEATS", label = "Seats", num = 32},
    [33] = {name = "VMT_STEERING", label = "Steering", num = 33},
    [34] = {name = "VMT_KNOB", label = "Knob", num = 34},
    [35] = {name = "VMT_PLAQUE", label = "Plaque", num = 35},
    [36] = {name = "VMT_ICE", label = "Ice", num = 36},
    [37] = {name = "VMT_TRUNK", label = "Trunk", num = 37},
    [38] = {name = "VMT_HYDRO", label = "Hydro", num = 38},
    [39] = {name = "VMT_ENGINEBAY1", label = "Engine Bay 1", num = 39},
    [40] = {name = "VMT_ENGINEBAY2", label = "Engine Bay 2", num = 40},
    [41] = {name = "VMT_ENGINEBAY3", label = "Engine Bay 3", num = 41},
    [42] = {name = "VMT_CHASSIS2", label = "Frame 2", num = 42},
    [43] = {name = "VMT_CHASSIS3", label = "Frame 3", num = 43},
    [44] = {name = "VMT_CHASSIS4", label = "Frame 4", num = 44},
    [45] = {name = "VMT_CHASSIS5", label = "Frame 5", num = 45},
    [46] = {name = "VMT_DOOR_L", label = "Door (L)", num = 46},
    [47] = {name = "VMT_DOOR_R", label = "Door (R)", num = 47},
    [48] = {name = "VMT_LIVERY_MOD", label = "Livery Mod", num = 48},
    [49] = {name = "VMT_LIGHTBAR", label = "Lightbar", num = 49},
}

CosmeticIndexes = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 14, 15, 19, 20, 21, 22, 25, 26, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 49
}

PerformanceIndexes = {
    11, 12, 13, 16, 17, 18, 
}

WheelIndexes = {
    23, 24
}

ColourIndexes = {
    27, 28, 29, 30, 48
}




local _defaultColours = {
    [0] = { label = "Black", num = 0 },
    [1] = { label = "Carbon Black", num = 147 },
    [2] = { label = "Graphite", num = 1 },
    [3] = { label = "Anhracite Black", num = 11 },
    [4] = { label = "Black Steel", num = 2 },
    [5] = { label = "Dark Steel", num = 3 },
    [6] = { label = "Silver", num = 4 },
    [7] = { label = "Bluish Silver", num = 5 },
    [8] = { label = "Rolled Steel", num = 6 },
    [9] = { label = "Shadow Silver", num = 7 },
    [10] = { label = "Stone Silver", num = 8 },
    [11] = { label = "Midnight Silver", num = 9 },
    [12] = { label = "Cast Iron Silver", num = 10 },
    [13] = { label = "Red", num = 27 },
    [14] = { label = "Torino Red", num = 28 },
    [15] = { label = "Formula Red", num = 29 },
    [16] = { label = "Lava Red", num = 150 },
    [17] = { label = "Blaze Red", num = 30 },
    [18] = { label = "Grace Red", num = 31 },
    [19] = { label = "Garnet Red", num = 32 },
    [20] = { label = "Sunset Red", num = 33 },
    [21] = { label = "Cabernet Red", num = 34 },
    [22] = { label = "Wine Red", num = 143 },
    [23] = { label = "Candy Red", num = 35 },
    [24] = { label = "Hot Pink", num = 135 },
    [25] = { label = "Pfsiter Pink", num = 137 },
    [26] = { label = "Salmon Pink", num = 136 },
    [27] = { label = "Sunrise Orange", num = 36 },
    [28] = { label = "Orange", num = 38 },
    [29] = { label = "Bright Orange", num = 138 },
    [30] = { label = "Gold", num = 99 },
    [31] = { label = "Bronze", num = 90 },
    [32] = { label = "Yellow", num = 88 },
    [33] = { label = "Race Yellow", num = 89 },
    [34] = { label = "Dew Yellow", num = 91 },
    [35] = { label = "Dark Green", num = 49 },
    [36] = { label = "Racing Green", num = 50 },
    [37] = { label = "Sea Green", num = 51 },
    [38] = { label = "Olive Green", num = 52 },
    [39] = { label = "Bright Green", num = 53 },
    [40] = { label = "Gasoline Green", num = 54 },
    [41] = { label = "Lime Green", num = 92 },
    [42] = { label = "Midnight Blue", num = 141 },
    [43] = { label = "Galaxy Blue", num = 61 },
    [44] = { label = "Dark Blue", num = 62 },
    [45] = { label = "Saxon Blue", num = 63 },
    [46] = { label = "Blue", num = 64 },
    [47] = { label = "Mariner Blue", num = 65 },
    [48] = { label = "Harbor Blue", num = 66 },
    [49] = { label = "Diamond Blue", num = 67 },
    [50] = { label = "Surf Blue", num = 68 },
    [51] = { label = "Nautical Blue", num = 69 },
    [52] = { label = "Racing Blue", num = 73 },
    [53] = { label = "Ultra Blue", num = 70 },
    [54] = { label = "Light Blue", num = 74 },
    [55] = { label = "Chocolate Brown", num = 96 },
    [56] = { label = "Bison Brown", num = 101 },
    [57] = { label = "Creeen Brown", num = 95 },
    [58] = { label = "Feltzer Brown", num = 94 },
    [59] = { label = "Maple Brown", num = 97 },
    [60] = { label = "Beechwood Brown", num = 103 },
    [61] = { label = "Sienna Brown", num = 104 },
    [62] = { label = "Saddle Brown", num = 98 },
    [63] = { label = "Moss Brown", num = 100 },
    [64] = { label = "Woodbeech Brown", num = 102 },
    [65] = { label = "Straw Brown", num = 99 },
    [66] = { label = "Sandy Brown", num = 105 },
    [67] = { label = "Bleached Brown", num = 106 },
    [68] = { label = "Schafter Purple", num = 71 },
    [69] = { label = "Spinnaker Purple", num = 72 },
    [70] = { label = "Midnight Purple", num = 142 },
    [71] = { label = "Bright Purple", num = 145 },
    [72] = { label = "Cream", num = 107 },
    [73] = { label = "Ice White", num = 111 },
    [74] = { label = "Frost White", num = 112 }
}

Colours = {
    [0] = {
        label = "Classic",
        values = _defaultColours,
    },

    [1] = {
        label = "Metallic",
        values = _defaultColours,
    },

    [2] = {
        label = "Pearlescent",
        values = _defaultColours,
    },

    [3] = {
        label = "Matte",
        values = {
            [0] = { label = "Black", num = 12 },
            [1] = { label = "Gray", num = 13 },
            [2] = { label = "Light Gray", num = 14 },
            [3] = { label = "Ice White", num = 131 },
            [4] = { label = "Blue", num = 83 },
            [5] = { label = "Dark Blue", num = 82 },
            [6] = { label = "Midnight Blue", num = 84 },
            [7] = { label = "Midnight Purple", num = 149 },
            [8] = { label = "Schafter Purple", num = 148 },
            [9] = { label = "Red", num = 39 },
            [10] = { label = "Dark Red", num = 40 },
            [11] = { label = "Orange", num = 41 },
            [12] = { label = "Yellow", num = 42 },
            [13] = { label = "Lime Green", num = 55 },
            [14] = { label = "Green", num = 128 },
            [15] = { label = "Frost Green", num = 151 },
            [16] = { label = "Foliage Green", num = 155 },
            [17] = { label = "Olive Darb", num = 152 },
            [18] = { label = "Dark Earth", num = 153 },
            [19] = { label = "Desert Tan", num = 154 }
        }
    },
    
    [4] = {
        label = "Metal",
        values = {
            [0] = { label = "Brushed Steel", num = 117 },
            [1] = { label = "Brushed Black Steel", num = 118 },
            [2] = { label = "Brushed Aluminum", num = 119 },
            [3] = { label = "Pure Gold", num = 158 },
            [4] = { label = "Brushed Gold", num = 159 }
        },
    },

    [5] = {
        label = "Chrome",
        values = {
            [0] = { label = "Chrome", num = 120 }
        },
    }

}

ColourTypes = {
    ["Classic"] = 0,
    ["Metallic"] = 1,
    ["Pearlescent"] = 2,
    ["Matte"] = 3,
    ["Metal"] = 4,
    ["Chrome"] = 5
}

