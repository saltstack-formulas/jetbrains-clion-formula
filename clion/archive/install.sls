# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

clion-package-archive-install:
              {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
              {%- else %}
  pkg.installed:
              {%- endif %}
    - names: {{ clion.pkg.deps|json }}
    - require_in:
      - file: clion-package-archive-install

              {%- if clion.flavour|lower == 'windows' %}

  file.managed:
    - name: {{ clion.dir.tmp }}/clion.exe
    - source: {{ clion.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ clion.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ clion.dir.tmp }}/clion.exe
    - require:
      - file: clion-package-archive-install

              {%- else %}

  file.directory:
    - name: {{ clion.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: clion-package-archive-install
                 {%- if grains.os != 'Windows' %}
    - user: {{ clion.identity.rootuser }}
    - group: {{ clion.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
                 {%- endif %}
  archive.extracted:
    {{- format_kwargs(clion.pkg.archive) }}
    - retry: {{ clion.retry_option|json }}
                 {%- if grains.os != 'Windows' %}
    - user: {{ clion.identity.rootuser }}
    - group: {{ clion.identity.rootgroup }}
    - recurse:
        - user
        - group
                 {%- endif %}
    - require:
      - file: clion-package-archive-install

              {%- endif %}
              {%- if grains.kernel|lower == 'linux' and clion.linux.altpriority|int == 0 %}

clion-archive-install-file-symlink-clion:
  file.symlink:
    - name: /usr/local/bin/{{ clion.command }}
    - target: {{ clion.dir.path }}/{{ clion.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: clion-package-archive-install

              {%- elif clion.flavour|lower == 'windowszip' %}

clion-archive-install-file-shortcut-clion:
  file.shortcut:
    - name: C:\Users\{{ clion.identity.rootuser }}\Desktop\{{ clion.dirname }}.lnk
    - target: {{ clion.dir.archive }}\{{ clion.dirname }}\{{ clion.command }}
    - working_dir: {{ clion.dir.archive }}\{{ clion.dirname }}\bin
    - icon_location: {{ clion.dir.archive }}\{{ clion.dirname }}\bin\clion.ico
    - makedirs: True
    - force: True
    - user: {{ clion.identity.rootuser }}
    - require:
      - archive: clion-package-archive-install

              {%- endif %}
