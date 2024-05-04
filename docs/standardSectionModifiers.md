# Standard Section Modifiers

Section Modifiers are Task Scripts which run after a Dungeon Section is placed. These tasks can change anything about the section.

The below Tasks are generalized for use in different Dungeons.

* [dd_StandardSectionModifiers_ChangeBiome](#dd_StandardSectionModifiers_ChangeBiome)
* [dd_StandardSectionModifiers_SimplexNoise](#dd_StandardSectionModifiers_SimplexNoise)

---

### dd_StandardSectionModifiers_ChangeBiome

Changes the biome of all blocks within the section. A buffer area of 5 blocks is applied to handle Minecraft's vanilla biome blending behavior.

**Expected definitions to be passed:**

| Definition | Description | Value |
| --- | --- | --- |
| area | Area representing the section to be modified | *AreaTag* |
| biomeName | Name of the biome to apply to the section<br/>Note, if using a custom biome then include the namespace of the biome. | *ElementTag* |

---

### dd_StandardSectionModifiers_SimplexNoise

Uses Simplex Noise to determine specific blocks to be updated. This can be used to create small patches of updated blocks that appear random.

This will only update blocks within the section if the block meets the below criteria:
* Material matches what was passed to `findMaterial`.
* Value from `util.random_simplex` is greater than or equal to value passed to `threshold`.

**Expected definitions to be passed:**

| Definition | Required | Description | Value |
| --- | --- | --- | --- |
| area | REQUIRED | Area representing the section to be modified | *AreaTag* |
| findMaterial | REQUIRED | Block Matcher to identify what materials to update.<br/>May use `!*air` to allow changing any block that isn't a type of air | *ElementTag* |
| replacementMaterial | REQUIRED | Material or a list of Materials passed to `modifyblock` command. | *ElementTag*<br/>*ListTag\<ElementTag\>* |
| replacementMaterialRates | OPTIONAL | Rate or a list of rates of chance a block will be modified, passed to `modifyblock` command.<br/>If this is not supplied, `modifyblock` is executed without this argument. | *Decimal*<br/>*ListTag\<Decimal\>* |
| wValue | OPTIONAL | `w` value passed into the `util.random_simplex` tag.<br/>Will default to `1` if not provided. | *Decimal* |
| threshold | OPTIONAL | Value that `util.random_simplex` must reach before a block will be modified.<br/>Increasing will make patches of blocks smaller, lowering will make patches of blocks bigger.<br/>Defaults to 0.375 if not provided. | *Decimal* |
| scale | OPTIONAL | Value to multiply block coordinates by before being passed to `util.random_simplex`.<br/>Decreasing will make patches appear closer together, Increasing will make patches appear farther apart (To a limit)<br/>Defaults to 0.25 if not provided. | *Decimal* |