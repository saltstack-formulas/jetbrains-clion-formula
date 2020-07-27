# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}

clion-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ clion.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ clion.dir.path }}/{{ clion.pkg.name }}*{{ clion.edition }}*.app
                  {%- else %}
      - {{ clion.dir.path }}
                  {%- endif %}
