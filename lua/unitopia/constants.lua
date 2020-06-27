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
  }
}

return Constants