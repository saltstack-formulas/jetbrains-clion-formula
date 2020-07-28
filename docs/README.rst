.. _readme:

clion-formula
=============

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/jetbrains-clion-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/jetbrains-clion-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Formula to install Clion on GNU/Linux and MacOS.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.


Available states
----------------

.. contents::
   :local:

``clion``
^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs Clion package,
manages Clion configuration file and then
configures the development environment.

``clion.archive``
^^^^^^^^^^^^^^^^^

This state will install Clion from archive only.

``clion.macapp``
^^^^^^^^^^^^^^^^

This state will install Clion from source only.

``clion.config``
^^^^^^^^^^^^^^^^

This state will configure npmrc and/or environment and has a dependency on ``clion.install``
via include list.

``clion.linuxenv``
^^^^^^^^^^^^^^^^^^

This state will install some Clion linux-alternatives on GNU/Linux.

``clion.clean``
^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``clion`` meta-state in reverse order, i.e.
removes the configuration file and
then uninstalls the package.

``clion.config.clean``
^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of Clion and has a
dependency on ``clion.package.clean`` via include list.

``clion.archive.clean``
^^^^^^^^^^^^^^^^^^^^^^^

This state will remove Clion package and has a dependency on
``clion.config.clean`` via include list.

``clion.macapp.clean``
^^^^^^^^^^^^^^^^^^^^^^

This state will remove Clion package and has a dependency on
``clion.config.clean`` via include list.

``clion.linuxenv.clean``
^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove Clion linux-alternatives on GNU/Linux.


Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``clion`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

