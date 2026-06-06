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
                node.description = "DeepFilter Noise Canceling Sink"
                media.name       = "DeepFilter Noise Canceling Sink"
                filter.graph = {
                    nodes = [
                        {
                            type   = ladspa
                            name   = "DeepFilter Stereo"
                            plugin = /home/aditya/.ladspa/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so
                            label  = deep_filter_stereo
                            control = {
                                "Attenuation Limit (dB)" 50
                            }
                        }
                    ]
                }
                audio.rate = 48000
                audio.channels = 2
                audio.position = [FL FR]
                capture.props = {
                    node.name = "deep_filter_stereo_input"
                    node.passive = true
                    node.target = "alsa_input.usb-Audio_Technica_Crop_ATR2100x-USB_Microphone_12345678ABCD-00.analog-stereo"
                }
                playback.props = {
                    node.name = "deep_filter_stereo_output"
                    media.class = Audio/Source
                }
            }
        }
    ]
    '')
  ];
}
