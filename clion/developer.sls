{% from "clion/map.jinja" import clion with context %}

{% if clion.prefs.user not in (None, 'undefined_user', 'undefined', '',) %}

  {% if grains.os == 'MacOS' %}
clion-desktop-shortcut-clean:
  file.absent:
    - name: '{{ clion.homes }}/{{ clion.prefs.user }}/Desktop/CLion'
    - require_in:
      - file: clion-desktop-shortcut-add
  {% endif %}

clion-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://clion/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ clion.prefs.user }}
      homes: {{ clion.homes }}
      edition: {{ clion.jetbrains.edition }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ clion.jetbrains.edition }}
    - runas: {{ clion.prefs.user }}
    - require:
      - file: clion-desktop-shortcut-add
   {% else %}
   #Linux
  file.managed:
    - source: salt://clion/files/clion.desktop
    - name: {{ clion.homes }}/{{ clion.prefs.user }}/Desktop/clion{{ clion.jetbrains.edition }}.desktop
    - user: {{ clion.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse',) %} 
    - group: users
      {% elif grains.os not in ('MacOS',) %}
        #inherit Darwin group ownership
    - group: {{ clion.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ clion.jetbrains.realcmd }}
    - context:
      home: {{ clion.jetbrains.realhome }}
      command: {{ clion.command }}
   {% endif %}


  {% if clion.prefs.jarurl or clion.prefs.jardir %}

clion-prefs-importfile:
   {% if clion.prefs.jardir %}
  file.managed:
    - onlyif: test -f {{ clion.prefs.jardir }}/{{ clion.prefs.jarfile }}
    - name: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.jarfile }}
    - source: {{ clion.prefs.jardir }}/{{ clion.prefs.jarfile }}
    - user: {{ clion.prefs.user }}
    - makedirs: True
        {% if grains.os_family in ('Suse',) %}
    - group: users
        {% elif grains.os not in ('MacOS',) %}
        #inherit Darwin ownership
    - group: {{ clion.prefs.user }}
        {% endif %}
    - if_missing: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.jarfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{clion.homes}}/{{clion.prefs.user}}/{{clion.prefs.jarfile}} {{clion.prefs.jarurl}}
    - runas: {{ clion.prefs.user }}
    - if_missing: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.jarfile }}
   {% endif %}

  {% endif %}

{% endif %}

