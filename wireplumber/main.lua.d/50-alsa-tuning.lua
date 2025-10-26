-- Force low-latency settings for the Scarlett
rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.*USB.*" },
    },
    {
      { "node.name", "matches", "alsa_input.*USB.*" },
    },
  },
  apply_properties = {
    ["api.alsa.period-size"] = 64,
    ["api.alsa.period-num"] = 3,
    ["api.alsa.disable-batch"] = true,
    ["node.latency"] = "128/48000",
    ["priority.session"] = 2000,
  },
}

table.insert(alsa_monitor.rules, rule)
