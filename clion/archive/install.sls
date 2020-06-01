# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

clion-package-archive-install:
  pkg.installed:
    - names: {{ clion.pkg.deps|json }}
    - require_in:
      - file: clion-package-archive-install
  file.directory:
    - name: {{ clion.pkg.archive.path }}
    - user: {{ clion.identity.rootuser }}
    - group: {{ clion.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: clion-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(clion.pkg.archive) }}
    - retry: {{ clion.retry_option|json }}
    - user: {{ clion.identity.rootuser }}
    - group: {{ clion.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: clion-package-archive-install

    {%- if clion.linux.altpriority|int == 0 %}

clion-archive-install-file-symlink-clion:
  file.symlink:
    - name: /usr/local/bin/clion
    - target: {{ clion.pkg.archive.path }}/{{ clion.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: clion-package-archive-install

    {%- endif %}
