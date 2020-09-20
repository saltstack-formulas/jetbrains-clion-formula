
Changelog
=========

`1.2.0 <https://github.com/saltstack-formulas/jetbrains-clion-formula/compare/v1.1.0...v1.2.0>`_ (2020-09-20)
-----------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **clean:** add windows support (\ `5163f94 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/5163f9462767b112b4e39598846f7843d40bcff6>`_\ )

`1.1.0 <https://github.com/saltstack-formulas/jetbrains-clion-formula/compare/v1.0.2...v1.1.0>`_ (2020-09-20)
-----------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **windows:** basic windows support (\ `97bf061 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/97bf061463b16937a8a8e932967cbd05cd0a2f72>`_\ )

`1.0.2 <https://github.com/saltstack-formulas/jetbrains-clion-formula/compare/v1.0.1...v1.0.2>`_ (2020-07-28)
-----------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **cmd.run:** wrap url in quotes (zsh) (\ `54953f5 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/54953f5e0ac36b34d3c106c2b744bb375c60275b>`_\ )
* **macos:** do not create shortcut file (\ `3e0aed7 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/3e0aed7e02e2930761bd2249543e460dad3f3721>`_\ )
* **macos:** do not create shortcut file (\ `76a89e3 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/76a89e37fcd1c59387d6444aa39ec5caa080be86>`_\ )
* **macos:** do not create shortcut file (\ `167b8a5 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/167b8a5dcb11e70ad2cfce17cd591cefa28a935a>`_\ )

Code Refactoring
^^^^^^^^^^^^^^^^


* **jetbrains:** align all jetbrains formulas (\ `2cf6cef <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/2cf6cef50cbe9168413fb743317f7d99527241ff>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** use ``saltimages`` Docker Hub where available [skip ci] (\ `f3b7cee <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/f3b7cee600d39ca26a0506fc57497aefea553acd>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** minor update (\ `2e21e98 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/2e21e9831e2e702fb6f03e7abf86801e431fd299>`_\ )

Styles
^^^^^^


* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] (\ `d39c298 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/d39c298f9cc72cea686f60e2cf6ad42ab639e37e>`_\ )

`1.0.1 <https://github.com/saltstack-formulas/jetbrains-clion-formula/compare/v1.0.0...v1.0.1>`_ (2020-06-15)
-----------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **edition:** better edition jinja code (\ `3a6f3ba <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/3a6f3bac8f0027eea350a1fc04776aedad242674>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** updated formatting (\ `a352da9 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/a352da9407d9f2971f1b0417fd4f909201e7254f>`_\ )

`1.0.0 <https://github.com/saltstack-formulas/jetbrains-clion-formula/compare/v0.1.0...v1.0.0>`_ (2020-06-01)
-----------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **id:** rename conflicting id (\ `ac29163 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/ac29163a9bba804679ea82ebaa6bbe74180a1b18>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** use latest pre-salted images (\ `400ad2b <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/400ad2b84c7d6222791954312dd164a573e94c41>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** add depth one (\ `2e1cec2 <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/2e1cec257f99791c5e8242c42c2767b247325c53>`_\ )
* **readme:** fix Travis hyperlinks (\ `9c8acce <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/9c8acce8d52861bbd699821c2dbb35c25873180e>`_\ )

Features
^^^^^^^^


* **formula:** align to template-formula; add ci (\ `6bed46d <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/6bed46d3061d7f82ee870d22edc169afe675be3e>`_\ )
* **formula:** align to template-formula; add ci (\ `d16bd3a <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/d16bd3a9925c1a87ad5b760bef62ed013c90d1c8>`_\ )
* **semantic-release:** standardise for this formula (\ `81c583f <https://github.com/saltstack-formulas/jetbrains-clion-formula/commit/81c583fcd179d575b694746b5743c5f0a9991dd8>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **formula:** Major refactor of formula to bring it in alignment with the
  template-formula. As with all substantial changes, please ensure your
  existing configurations work in the ways you expect from this formula.
