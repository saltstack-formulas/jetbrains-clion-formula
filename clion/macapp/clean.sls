# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}

clion-macos-app-clean-files:
  file.absent:
    - names:
      - {{ clion.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ clion.dir.path }}/{{ clion.pkg.name }}*{{ clion.edition }}*.app
                  {%- else %}
      - {{ clion.dir.path }}
                  {%- endif %}

    {%- else %}

clion-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The clion macpackage is only available on MacOS

    {%- endif %}
