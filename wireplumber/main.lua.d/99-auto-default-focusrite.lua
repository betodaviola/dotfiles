-- This function is called for each new audio sink node
function set_focusrite_default(object)
  local name = object.properties["node.name"]
  local media_class = object.properties["media.class"]

  if media_class == "Audio/Sink" and name == "alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.pro-output-0" then
    object.properties["node.description"] = "Focusrite Output"
    object.properties["node.default"] = true
    print("🔊 Focusrite set as default audio output.")
  end
end

-- Add rule to run this on each new ALSA node
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "media.class", "equals", "Audio/Sink" },
    },
  },
  apply_properties = {},
  run = set_focusrite_default
})
