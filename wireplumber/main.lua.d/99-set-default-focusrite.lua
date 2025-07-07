rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.pro-output-0" }
    }
  },
  apply_properties = {
    ["node.description"] = "Focusrite Output",
    ["node.default"] = true
  }
}

table.insert(alsa_monitor.rules, rule)
