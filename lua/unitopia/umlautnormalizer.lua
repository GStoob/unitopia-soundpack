local class = require("pl.class")

class.UmlautNormalizer()

Conversions = {}
Conversions["ä"] = "ae"
Conversions["ü"] = "ue"
Conversions["ö"] = "oe"
Conversions["Ä"] = "Ae"
Conversions["Ö"] = "Oe"
Conversions["Ü"] = "Ue"
Conversions["ß"] = "ss"
Conversions["�"] = "ae"
Conversions["�"] = "oe"
Conversions["�"] = "ue"
Conversions["�"] = "Ae"
Conversions["�"] = "Oe"
Conversions["�"] = "Ue"
Conversions["�"] = "ss"

function UmlautNormalizer:Normalize(text)
  for char in pairs(Conversions) do
    text = string.gsub(text, char, Conversions[char])
  end
  return text
end

return UmlautNormalizer