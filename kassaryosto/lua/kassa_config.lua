KASSA_CONFIG = {} 
KASSA_CONFIG.MinPolice = 0 -- Minimum number of teams considered cops by the Bank needed to start a robbery. (0 to disable)
KASSA_CONFIG.BaseReward = 2000 -- Minimi rahamäärä kassakoneessa
KASSA_CONFIG.MaxReward = 7000 -- Maksimi rahamäärä kassakoneessa
KASSA_CONFIG.LoopSiren = true -- Should the siren sound loop?
KASSA_CONFIG.CooldownTime = 1800 -- Ryöstön jälkeinen cooldown. 1800 seconds = 30 minutes
KASSA_CONFIG.RobberyTime = 30 -- Röstöön menevä aika. 30 seconds normaalisti
KASSA_CONFIG.LockpickTime = 30 -- aika lukon avaamiseen. 30 seconds normaalisti
KASSA_CONFIG.Robbers = nil -- Kaikki voivat ryöstää jos tämä on nil
KASSA_CONFIG.RobberyDistance = 150 -- Max distance (units) kassarekisteristä
KASSA_CONFIG.Police = { -- The teams considered cops by the bank.
    ['Poliisi'] = true, -- uses the name displayed in the F4 menu. (Uses the name displayed in the F4 menu)
    ['Rikoskomisario'] = true,
}
KASSA_CONFIG.Robbers = { -- The teams that can rob the kassa fucking kone. (Uses the name displayed in the F4 menu)
    ['Kansalainen'] = true, 
    ['Ammattirikollinen'] = true,
    ['Katujengiläinen'] = true,
    ['Katujengin johtaja'] = true,
    ['Gangster'] = true,
    ['Citizen'] = true, 
}
