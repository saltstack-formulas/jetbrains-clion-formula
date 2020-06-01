# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}

clion-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ clion.pkg.archive.path }}
      - /usr/local/jetbrains/clion-{{ clion.edition }}-*
