# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if clion.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

clion-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ clion.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='clion-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ clion.identity.rootuser }}
    - group: {{ clion.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      environ: {{ clion.environ|json }}
                      {%- if clion.pkg.use_upstream_macapp %}
      edition:  {{ '' if not clion.edition else ' %sE'|format(clion.edition) }}.app/Contents/MacOS
      appname: {{ clion.dir.path }}/{{ clion.pkg.name }}
                      {%- else %}
      edition: ''
      appname: {{ clion.dir.path }}/bin
                      {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
