# KEM Scenarios
KEM has two type of scenarios, integration and pricing rule scenarios. All the scenario flags are location in [decisionFlags.gms].

## Integration Scenarios
Integration scenarios represent whether a sector(s,c) from a particular country participate in the final model or not. If a sector from a country is integrated, the final model minimizes the sector's objective function for each country. On the other hand, if a sector from a country is excluded from the final model, the consumption of commodities by the excluded sector is set to a predefined constant. An example of excluding the Power sector from Bahrain from the model would need the following steps:

* Set the flag "Integrate('sector_prv', c)" to all the sectors except _Power_ to **_yes_**.
* set the flag "Integrate('EL', 'bah')" to **_no_** which indicates to the model to exclude the _Power_ sector for Bahrain.
* Start the model.


## Pricing Rule Scenarios
The pricing rule scenarios in the model allow the user to set the price of commodity to a particular sector to either:
1. Marginal Value.
2. Administered Price.

For example, the prices of upstream commodities could be sold to the water desalination sector in Saudi Arabia using an administered price by setting the flag "WAfuelpflag(WAfup, 'ksa')" to **_2_**. Meanwhile, the same commodities could be sold to the cement sector in Saudi Arabia using the marginal value by setting the flag "CMfuelpflag(CMfup, 'ksa')" to **_1_**.



[//]: # (These are reference links used in the body)
[decisionFlags.gms]: ../decisionFlags.gms