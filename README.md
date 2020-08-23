![KAPSARC]

# KAPSARC Energy Model for Gulf Cooperation Council v3.1.0
The KAPSARC Energy Model for Gulf Cooperation Council (GCC) ([KEM]) is a partial economic equilibrium model that characterizes some of the energy and most energy-intensive sectors in the GCC economy; these are electric power, petrochemicals, refining, water desalination, upstream oil and gas and cement. KEM is a tool to help estimate the consequences of alternative energy policies that affect energy production and use within GCC.

If you require more information about KEM, please refer to the model documentation, or contact us at [kem@kapsarc.org].

## Getting Started

KEM is developed using General Algebraic Modeling System ([GAMS]) which is a high-level modeling system for mathematical programming and optimization. KAPSARC aims to provide a virtual environment to run the model so that it is accessible to all
users. Everything else, including the data, is contained within the model files.


### Prerequisites

* Windows environment
* GAMS 24.1.3 or higher
* GAMS license for PATH solver

### Installing &  Executing

```bash
$ git clone https://github.com/KAPSARC/KEM.git
$ cd KEM
$ KEM.bat
```

### Scenarios
KEM dynamically integrates all the sectors which allow the user to create any scenario. The integration uses boolean flags to indicate whether to include a sector or not. Also, the model has multiple options for the pricing rules among the sectors. To learn more, visit the [scenarios] page.

### Calibration
The calibration in this version has been done based on data from 2015. Upstream, Power, Water Desalination sectors are calibrated for all the GCC countries; meanwhile, Refinery, Petrochemical, Cement sectors have been only calibrated for Saudi Arabia.


## Built With

* [GAMS] - Modeling system used
* [Sublime Text] - Text editor used

## Contributing

Please read [CONTRIBUTING]

## License

This software is available under MIT License. See the [LICENSE] file for details

-----

Copyright KAPSARC. Open source MIT License.

------


[//]: # (These are reference links used in the body)
[//]: # (Reference for websites)
[KEM]: <https://www.kapsarc.org/openkapsarc/the-kapsarc-energy-model-for-saudi-arabia>
[GAMS]: https://www.gams.com/
[Sublime Text]: https://www.sublimetext.com/



[//]: # (Reference within the project)
[KAPSARC]: docs/images/KAPSARC_Logo.png
[CONTRIBUTING]: docs/CONTRIBUTING.md
[scenarios]: docs/Scenarios.md
[LICENSE]: LICENSE.md


[//]: # (Reference for profiles)
[kem@kapsarc.org]: mailto:kem@kapsarc.org
