{% from "clion/map.jinja" import clion with context %}

{% if clion.prefs.user not in (None, 'undefined_user') %}

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
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ clion.jetbrains.edition }}
    - runas: {{ clion.prefs.user }}
    - require:
      - file: clion-desktop-shortcut-add
   {% else %}
  file.managed:
    - source: salt://clion/files/clion.desktop
    - name: {{ clion.homes }}/{{ clion.prefs.user }}/Desktop/clion.desktop
    - user: {{ clion.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ clion.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ clion.symhome }}/{{ clion.command }}
    - context:
      home: {{ clion.symhome }}
      command: {{ clion.command }}
   {% endif %}


  {% if clion.prefs.importurl or clion.prefs.importdir %}

clion-prefs-importfile:
   {% if clion.prefs.importdir %}
  file.managed:
    - onlyif: test -f {{ clion.prefs.importdir }}/{{ clion.prefs.myfile }}
    - name: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.myfile }}
    - source: {{ clion.prefs.importdir }}/{{ clion.prefs.myfile }}
    - user: {{ clion.prefs.user }}
    - makedirs: True
        {% if salt['grains.get']('os_family') in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ clion.prefs.user }}
        {% endif %}
    - if_missing: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.myfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{clion.homes}}/{{clion.prefs.user}}/{{clion.prefs.myfile}} {{clion.prefs.importurl}}
    - runas: {{ clion.prefs.user }}
    - if_missing: {{ clion.homes }}/{{ clion.prefs.user }}/{{ clion.prefs.myfile }}
   {% endif %}

  {% endif %}

{% endif %}

