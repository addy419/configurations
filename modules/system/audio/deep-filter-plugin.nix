{ pkgs }:

pkgs.runCommand "deep-filter-ladspa-plugin" { } ''
  mkdir -p $out/lib/ladspa
  cp ${./plugin-shared-objects/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so} $out/lib/ladspa/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so
''

