local class = require("pl.class")

class.UmlautNormalizer()

Conversions = {}
Conversions["Ã¤"] = "ae"
Conversions["Ã¼"] = "ue"
Conversions["Ã¶"] = "oe"
Conversions["Ã„"] = "Ae"
Conversions["Ã–"] = "Oe"
Conversions["Ãœ"] = "Ue"
Conversions["ÃŸ"] = "ss"
Conversions["ä"] = "ae"
Conversions["ö"] = "oe"
Conversions["ü"] = "ue"
Conversions["Ä"] = "Ae"
Conversions["Ö"] = "Oe"
Conversions["Ü"] = "Ue"
Conversions["ß"] = "ss"

function UmlautNormalizer:Normalize(text)
  for char in pairs(Conversions) do
    text = string.gsub(text, char, Conversions[char])
  end
  return text
end

return UmlautNormalizer