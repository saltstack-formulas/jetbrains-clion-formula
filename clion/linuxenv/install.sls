# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

clion-linuxenv-home-file-symlink:
  file.symlink:
    - name: /opt/clion
    - target: {{ clion.pkg.archive.path }}
    - onlyif: test -d '{{ clion.pkg.archive.path }}'
    - force: True

        {% if clion.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

clion-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: clionhome
    - link: /opt/clion
    - path: {{ clion.pkg.archive.path }}
    - priority: {{ clion.linux.altpriority }}
    - retry: {{ clion.retry_option|json }}

clion-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: clionhome
    - path: {{ clion.pkg.archive.path }}
    - onchanges:
      - alternatives: clion-linuxenv-home-alternatives-install
    - retry: {{ clion.retry_option|json }}

clion-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: clion
    - link: {{ clion.linux.symlink }}
    - path: {{ clion.pkg.archive.path }}/{{ clion.command }}
    - priority: {{ clion.linux.altpriority }}
    - require:
      - alternatives: clion-linuxenv-home-alternatives-install
      - alternatives: clion-linuxenv-home-alternatives-set
    - retry: {{ clion.retry_option|json }}

clion-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: clion
    - path: {{ clion.pkg.archive.path }}/{{ clion.command }}
    - onchanges:
      - alternatives: clion-linuxenv-executable-alternatives-install
    - retry: {{ clion.retry_option|json }}

        {%- else %}

clion-linuxenv-alternatives-install-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (clion.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
