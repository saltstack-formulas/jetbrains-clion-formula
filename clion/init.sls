{% from "clion/map.jinja" import clion with context %}

# Cleanup first
clion-remove-prev-archive:
  file.absent:
    - name: '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
    - require_in:
      - clion-extract-dirs

clion-extract-dirs:
  file.directory:
    - names:
      - '{{ clion.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows',) %}
      - '{{ clion.jetbrains.realhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - clean: True
    - require_in:
      - clion-download-archive

clion-download-archive:
  cmd.run:
    - name: curl {{ clion.dl.opts }} -o '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}' {{ clion.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ clion.dl.retries }}
        interval: {{ clion.dl.interval }}
      {% endif %}

{%- if clion.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',) %}
clion-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
     - file_hash: {{ clion.dl.src_hashsum }}
     - onchanges:
       - cmd: clion-download-archive
     - require_in:
       - archive: clion-package-install
  {%- endif %}
{%- endif %}

clion-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  # Linux
  archive.extracted:
    - source: 'file://{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
    - name: '{{ clion.jetbrains.realhome }}'
    - archive_format: {{ clion.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ clion.dl.unpack_opts }}
    - if_missing: '{{ clion.jetbrains.realcmd }}'
       {% else %}
    - options: {{ clion.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if clion.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ clion.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: clion-download-archive
    - require_in:
      - clion-remove-archive

clion-remove-archive:
  file.absent:
    - name: '{{ clion.tmpdir }}'
    - onchanges:
{%- if grains.os in ('Windows',) %}
      - pkg: clion-package-install
{%- elif grains.os in ('MacOS',) %}
      - macpackage: clion-package-install
{% else %}
      #Unix
      - archive: clion-package-install

{% endif %}
