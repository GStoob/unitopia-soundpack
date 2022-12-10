Constants = {
  Plugins = {
    AUDIO_PLUGIN_ID = "aedf0cb0be5bf045860d54b7",
    GMCP_PLUGIN_ID = "c074220f28dcae21baaf08e6"
  },
  -- The following table defines constants that are required to successfully send and receive GMCP packets
  -- See https://www.gammon.com.au/gmcp for more info
  GmcpProtocolNegotiation = {
    SB   = 0xFA, -- Start of subnegotiation
    SE = 0xF0, -- End of subnegotiation
    IAC  = 0xFF, -- Interpret As Command
    GMCP = 201 -- GMCP sequence, required to identify incoming and outgoing GMCP packets successfully
  },
  -- Maps Char.Stats received via GMCP to German names
  StatNames = {
    int = "Intelligenz",
    str = "Staerke",
    dex = "Geschicklichkeit",
    con = "Ausdauer"
  },
  -- Sound folder (points to the MUSHclient/sounds directory)
  SoundFolder = world.GetInfo(74),
  -- Maps German item categories to sound folder names
  ItemCategories = {
    Behaelter = "Container",
    Geld = "Money",
    Kleidung = "Clothes",
    Lebendiges = "Living",
    Nahrung = "Food",
    Ruestungen = "Armor",
    Sonstiges = "Other",
    Waffen = "Weapons",
    Wertvolles = "Valuable"
  }
}

return Constants