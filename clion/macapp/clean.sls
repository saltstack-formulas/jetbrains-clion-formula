# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}

clion-macos-app-clean-files:
  file.absent:
    - names:
      - {{ clion.dir.tmp }}
      - /Applications/{{ clion.pkg.name }}{{ '' if not edition else ' %sE'|format(edition) }}.app

    {%- else %}

clion-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The clion macpackage is only available on MacOS

    {%- endif %}
