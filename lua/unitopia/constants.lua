Constants = {
  Plugins = {
    AUDIO_PLUGIN_ID = "aedf0cb0be5bf045860d54b7"
  },
  -- The following table defines constants that are required to successfully send and receive GMCP packets
  -- See https://www.gammon.com.au/gmcp for more info
  GmcpProtocolNegotiation = {
    SB   = 0xFA, -- Start of subnegotiation
    SE = 0xF0, -- End of subnegotiation
    IAC  = 0xFF, -- Interpret As Command
    GMCP = 0xC9 -- GMCP sequence (decimal 201)
  }
}

return Constants