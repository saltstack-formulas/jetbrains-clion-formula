# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

clion-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/clion
      - {{ clion.pkg.archive.path }}

        {% if clion.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

clion-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: clionhome
    - path: {{ clion.pkg.archive.path }}
    - onlyif: update-alternatives --get-selections |grep ^clionhome


clion-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: clion
    - path: {{ clion.pkg.archive.path }}/clion
    - onlyif: update-alternatives --get-selections |grep ^clion

        {%- else %}

clion-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (clion.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
