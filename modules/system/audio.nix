{ pkgs, ... }:

{
  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
      		bluez_monitor.properties = {
        		["bluez5.enable-sbc-xq"] = true,
      			["bluez5.enable-msbc"] = true,
            ["bluez5.enable-hw-volume"] = true,
            ["bluez5.roles"] = "[ a2dp_sink a2dp_source hsp_hs hsp_ag hfp_hf hfp_ag ]"
      		}
      	'')
      ];
    };
  };

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 32;
    };
  };

  services.pipewire.configPackages = [
    (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/filter-chain.conf" ''
      context.modules = [
        { name = libpipewire-module-filter-chain
            args = {
                node.description = "DeepFilter Noise Canceling Source"
                media.name       = "DeepFilter Noise Canceling Source"
                filter.graph = {
                    nodes = [
                        {
                            type   = ladspa
                            name   = "DeepFilter Mono"
                            plugin = /home/aditya/.ladspa/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so
                            label  = deep_filter_mono
                            control = {
                                "Attenuation Limit (dB)" 50
                            }
                        }
                    ]
                }
                audio.rate = 48000
                audio.position = [FL]
                capture.props = {
                    node.passive = true
                }
                playback.props = {
                    media.class = Audio/Source
                }
            }
        }
    ]
    '')
  ];

#    "context.modules" = [
#        {   name = "libpipewire-module-filter-chain";
#            args = {
#                node.description = "DeepFilter Noise Canceling Source";
#                media.name       = "DeepFilter Noise Canceling Source";
#                filter.graph = {
#                    nodes = [
#                        {
#                            type   = ladspa;
#                            name   = "DeepFilter Mono";
#                            plugin = /home/aditya/.ladspa/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so;
#                            label  = deep_filter_mono;
#                            control = {
#                                "Attenuation Limit (dB)" = 100;
#                            };
#                        }
#                    ];
#                };
#                audio.rate = 48000;
#                audio.position = [FL];
#                capture.props = {
#                    node.passive = true;
#                };
#                playback.props = {
#                    media.class = Audio/Source;
#                };
#            };
#      }
#    ];
 # };

  
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;
}
