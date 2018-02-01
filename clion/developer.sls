{% from "clion/map.jinja" import clion with context %}

{% if clion.prefs.user %}

clion-desktop-shortcut-clean:
  file.absent:
    - name: '{{ clion.homes }}/{{ clion.prefs.user }}/Desktop/CLion'
    - require_in:
      - file: clion-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

clion-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://clion/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ clion.prefs.user }}
      homes: {{ clion.homes }}
      edition: {{ clion.jetbrains.edition }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ clion.jetbrains.edition }}
    - runas: {{ clion.prefs.user }}
    - require:
      - file: clion-desktop-shortcut-add
    - require_in:
      - file: clion-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

clion-desktop-shortcut-install
  file.managed:
    - source: salt://clion/files/clion.desktop
    - name: {{ clion.homes }}/{{ clion.prefs.user }}/Desktop/clion{{ clion.jetbrains.edition }}.desktop
    - makedirs: True
    - user: {{ clion.prefs.user }}
       {% if clion.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ clion.prefs.group }}
       {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ clion.jetbrains.realcmd }}
    - context:
      home: {{ clion.jetbrains.realhome }}
      command: {{ clion.command }}


  {% if clion.prefs.jarurl or clion.prefs.jardir %}

clion-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ clion.prefs.jardir }}/{{ clion.prefs.jarfile }}
    - name: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.jarfile }}
    - source: {{ clion.prefs.jardir }}/{{ clion.prefs.jarfile }}
    - makedirs: True
    - user: {{ clion.prefs.user }}
       {% if clion.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ clion.prefs.group }}
       {% endif %}
    - if_missing: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.jarfile }}
  cmd.run:
    - unless: test -f {{ clion.prefs.jardir }}/{{ clion.prefs.jarfile }}
    - name: curl -o {{clion.homes}}/{{clion.prefs.user}}/{{clion.prefs.jarfile}} {{clion.prefs.jarurl}}
    - runas: {{ clion.prefs.user }}
    - if_missing: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.jarfile }}
  {% endif %}


{% endif %}

