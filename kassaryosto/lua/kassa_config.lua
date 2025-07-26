KASSA_CONFIG = {} 
KASSA_CONFIG.language = "EN" -- Current options: "FI" "EN" "ES"
KASSA_CONFIG.MinPolice = 0 -- Minimum number of teams considered cops by the register needed to start a robbery. (0 to disable)
KASSA_CONFIG.BaseReward = 2000 -- Minimum amount of money in the register when it is created.
KASSA_CONFIG.MaxReward = 7000 -- Maximum amount of money in the register when it is created.
KASSA_CONFIG.LoopSiren = true -- Should the siren sound loop?
KASSA_CONFIG.CooldownTime = 1800 -- Cooldown after a robbery. 1800 seconds = 30 minutes
KASSA_CONFIG.RobberyTime = 30 -- Time it takes to rob. 30 seconds normally
KASSA_CONFIG.LockpickTime = 30 -- Time it takes to lockpick open. 30 seconds normally
KASSA_CONFIG.RobberyDistance = 150 -- Max distance (units) from the register during robbery
KASSA_CONFIG.Police = { -- The teams considered cops by the register.
    ['Poliisi'] = true, -- Uses the name displayed in the F4 menu.
    ['Rikoskomisario'] = true,
}
KASSA_CONFIG.Robbers = { -- The teams that can rob the register. (Uses the name displayed in the F4 menu)
    ['Kansalainen'] = true, 
    ['Ammattirikollinen'] = true,
    ['Katujengiläinen'] = true,
    ['Katujengin johtaja'] = true,
    ['Gangster'] = true,
    ['Citizen'] = true, 
}
