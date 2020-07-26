# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}

clion-macos-app-install-curl:
  file.directory:
    - name: {{ clion.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ clion.dir.tmp }}/clion-{{ clion.version }} "{{ clion.pkg.macapp.source }}"
    - unless: test -f {{ clion.dir.tmp }}/clion-{{ clion.version }}
    - require:
      - file: clion-macos-app-install-curl
      - pkg: clion-macos-app-install-curl
    - retry: {{ clion.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
clion-macos-app-install-checksum:
  module.run:
    - onlyif: {{ clion.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ clion.dir.tmp }}/clion-{{ clion.version }}
    - file_hash: {{ clion.pkg.macapp.source_hash }}
    - require:
      - cmd: clion-macos-app-install-curl
    - require_in:
      - macpackage: clion-macos-app-install-macpackage
  file.absent:
    - name: {{ clion.dir.tmp }}/clion-{{ clion.version }}
    - onfail:
      - module: clion-macos-app-install-checksum

clion-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ clion.dir.tmp }}/clion-{{ clion.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: clion-macos-app-install-curl
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://clion/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      appname: {{ clion.pkg.name }}
      edition: {{ '' if 'edition' not in clion else clion.edition }}
      user: {{ clion.identity.user }}
      homes: {{ clion.dir.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ clion.identity.user }}
    - require:
      - file: clion-macos-app-install-macpackage

    {%- else %}

clion-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The clion macpackage is only available on MacOS

    {%- endif %}
