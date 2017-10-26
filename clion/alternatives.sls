{% from "clion/map.jinja" import clion with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add pyCharmhome to alternatives system
clion-home-alt-install:
  alternatives.install:
    - name: clionhome
    - link: {{ clion.symhome }}
    - path: {{ clion.alt.realhome }}
    - priority: {{ clion.alt.priority }}

clion-home-alt-set:
  alternatives.set:
    - name: clionhome
    - path: {{ clion.alt.realhome }}
    - onchanges:
      - alternatives: clion-home-alt-install

# Add to alternatives system
clion-alt-install:
  alternatives.install:
    - name: clion
    - link: {{ clion.symlink }}
    - path: {{ clion.alt.realcmd }}
    - priority: {{ clion.alt.priority }}
    - require:
      - alternatives: clion-home-alt-install
      - alternatives: clion-home-alt-set

clion-alt-set:
  alternatives.set:
    - name: clion
    - path: {{ clion.alt.realcmd }}
    - onchanges:
      - alternatives: clion-alt-install

  {% endif %}

{% endif %}
