# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in clion and clion.config and clion.config_file %}
    {%- if clion.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

clion-config-file-managed-config_file:
  file.managed:
    - name: {{ clion.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='clion-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ clion.identity.rootuser }}
    - group: {{ clion.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ clion.config|json }}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
{%- endif %}
