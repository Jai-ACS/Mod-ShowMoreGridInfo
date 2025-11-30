[[阅读中文版信息](README-zh.md)]
<hr>

# Show More Grid Info
Mobile port of MoreGridInfo mod.

This mod has been changed in the following ways after porting:
1. Has multi-language support
	* Support English and Chinese languages at initial release (the English variant and Chinese variant of the mod have been merged)
	* More languages could be added in the future; you could submit your translation by:
		1. Forking this repository
		2. Adding in new translation file (see [this](Language/Mods/ShowGridMoreInfo/OfficialEnglish.txt) for example) for the language
		3. Submitting it through a [pull request here](https://github.com/Jai-ACS/Mod-ShowMoreGridInfo/pulls)
	* You could also submit translation to me via discord (one of the mod related channels), tagging me (Jai, username: jai.san) in the post
	* Credits will be provided upon successful submission (please provide due credit if you are not the actual translator)
2. The original MoreGridInfo mod updates the Grid Info panel when the mouse cursor moves - this ported version of the mod updates Grid Info panel when a tile is selected (as per how Grid Info panel works on mobile version without mods)
3. Increased Grid Info panel size, that would allow more information to be shown
4. Some information are now colored according to the value being displayed, which may or may not help to make reading easier
5. Sect trading price feature has been removed - it will be added as a separate mod later

## Main Features
The Grid Info panel is enhanced, showing the following information of the selected tile:
1. Qi value
2. Current and maximum Gather Qi values (see below)
3. Terrain & Flooring
4. Fertility (description & numeric value)
5. Attractiveness (description & numeric value)
6. Light (description & numeric value)
7. Temperature (description & numeric value)

* Maximum Gather Qi value is determined by adding the Gather Qi value of all Gather Qi objects that are capable of reaching the selected tile. Qi will gradually gather (up to the maximum) onto the tile over 5 days, increasing the tile's Qi value. The gathered Qi will reset to 0 whenever any Gather Qi item is placed or removed, causing a change in the maximum Gather Qi value on the tile. The Gather Qi value will reach maximum again after 5 days.

In addition, when the Feng Shui Vision is activated, the Grid Info panel would change to display Qi value, Gather Qi values and the Elemental Composition of the tile. There are 2 values displayed for each element:
1. The numeric amount of the element's emission on the tile
2. The percentage of the particular element over all the elements
* Elemental strength can be roughly calculated using the percentages with the following formula:
  * (Feeding element - suppressing element) * 2 + (cultivator's element)

Lastly, information of unexplored grids/tiles can also be shown with this mod.

## Known Issues
1. The Grid Info panel may not be able to display all information when there are too many information to display

## Planned Enhancements
I do have some ideas what I could enhance, but I shall not list them because they are not very important at this point in time.

## Credits
* Original Author: **Akira**
* Original Translator: **Dalois**
