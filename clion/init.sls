{% from "clion/map.jinja" import clion with context %}

# Cleanup first
clion-remove-prev-archive:
  file.absent:
    - name: '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
    - require_in:
      - clion-install-dir

clion-install-dir:
  file.directory:
    - names:
      - '{{ clion.alt.realhome }}'
      - '{{ clion.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows') %}
      - '{{ clion.prefix }}'
      - '{{ clion.symhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
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

{% if grains.os not in ('MacOS') %}
clion-unpacked-dir:
  file.directory:
    - name: '{{ clion.alt.realhome }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: clion-download-archive
{% endif %}

{%- if clion.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS') %}
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
  archive.extracted:
    - source: 'file://{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
    - name: '{{ clion.alt.realhome }}'
    - archive_format: {{ clion.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ clion.dl.unpack_opts }}
    - if_missing: '{{ clion.alt.realcmd }}'
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
    - names:
      # todo: maybe just delete the tmpdir itself
      - '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}'
      - '{{ clion.tmpdir }}/{{ clion.dl.archive_name }}.sha256'
    - onchanges:
{%- if grains.os in ('Windows') %}
      - pkg: clion-package-install
{%- elif grains.os in ('MacOS') %}
      - macpackage: clion-package-install
{% else %}
      - archive: clion-package-install

clion-home-symlink:
  file.symlink:
    - name: '{{ clion.symhome }}'
    - target: '{{ clion.alt.realhome }}'
    - force: True
    - onchanges:
      - archive: clion-package-install

# Update system profile with PATH
clion-config:
  file.managed:
    - name: /etc/profile.d/clion.sh
    - source: salt://clion/files/clion.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      clion_home: '{{ clion.symhome }}'

{% endif %}
