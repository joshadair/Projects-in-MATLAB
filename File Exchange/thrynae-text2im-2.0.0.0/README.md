# text2im documentation
[![View text2im on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/75021-text2im)
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=thrynae/text2im)

Table of contents

- Description section:
- - [Description](#description)
- - [Fonts](#fonts)
- Matlab/Octave section:
- - [Syntax](#syntax)
- - [Output arguments](#output-arguments)
- - [Input arguments](#input-arguments)
- - [Compatibility, version info, and licence](#compatibility-version-info-and-licence)

## Description

This function will convert a string or char array to an image. There are several fonts implemented, each with their own license and number of included characters. All fonts are free to use in some form, but if you plan to use it on a large scale or for commercial purposes you should check the license of the specific font you want to use.

The list of included characters is based on a relatively arbitrary selection from three Wikipedia pages: [general characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters), [newline characters](https://en.wikipedia.org/wiki/Newline#Unicode), [whitespace characters](https://en.wikipedia.org/wiki/Whitespace_character#Unicode).

The list of actually available characters depends on the chosen font.

### Fonts

The font images were generated using XeTeX and ghostscript.

|Font ID|Description and license|Character size|
|---|---|---|
|`'cmu_typewriter_text'`|This typeface contains 365 characters. This is a public domain typeface. [[link]](http://web.archive.org/web/20200418101117im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_CMU_Typewriter_Text.png)|`size=90x55`|
|`'cmu_concrete'`|This typeface contains 364 characters. This is a public domain typeface. [[link]](http://web.archive.org/web/20200418093550im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_CMU_Concrete.png)|`size=90x75`|
|`'ascii'`|This typeface contains only 94 characters (all printable `char`s below 127). This typeface was previously published in the `text2im()` (published on the [FileExchange](https://www.mathworks.com/matlabcentral/fileexchange/19896) by Tobias Kiessling). [[link]](http://web.archive.org/web/20200418093459im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_ASCII.png)|`size=20x18`|
|`'droid_sans_mono'`|This typeface contains 411 characters and has an Apache License (Version 2.0). [[link]](http://web.archive.org/web/20200418093741im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_Droid_Sans_Mono.png)|`size=95x51`|
|`'ibm_plex_mono'`|This typeface contains 376 characters and has an SIL Open Font License. [[link]](http://web.archive.org/web/20200418093815im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_IBM_Plex_Mono.png)|`size=95x51`|
|`'liberation_mono'`|This typeface contains 415 characters and has a GNU General Public License. [[link]](http://web.archive.org/web/20200418093840im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_Liberation_Mono.png)|`size=95x51`|
|`'monoid'`|This typeface contains 398 characters and has an MIT License. [[link]](http://web.archive.org/web/20200418093903im_/https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/text2im_glyphs_Monoid.png)|`size=95x51`|
 

## Matlab/Octave

### Syntax

    imtext = text2im(text)
    imtext = text2im(text,font)
    imtext = text2im(text,options)
    imtext = text2im(text,Name,Value)

### Output arguments

|Argument|Description|
|---|---|
|imtext|A logical array containing the text image. The size is dependent on the font.|

### Input arguments

|Argument|Description|
|---|---|
|text|The text to be converted can be supplied as `char`, `string`, or `cellstr`. Which characters are allowed is determined by the font. However, all fonts contain the printable and blank characters below 127. Any non-standard newline characters are ignored (i.e. LF/CR/CRLF are parsed as newline). Non-scalar inputs (or non-row vector inputs in the case of `char`) are allowed, but might not return the desired result.|
|font|This syntax option exists for backwards compatibility. It is equivalent to the Name,Value syntax.|
|Name,Value|The settings below can be entered with a `Name,Value` syntax.|
|options|Instead of the `Name,Value`, parameters can also be entered in a `struct`. Missing fields will be set to the default values.|

### Name,Value pairs

|Argument|Description|
|---|---|
|font|Font name as char array. The currently implemented options are `cmu_typewriter_text` (default), `cmu_concrete`, `ascii`, `droid_sans_mono`, `ibm_plex_mono`, `liberation_mono`, and `monoid`.|
|TranslateRichText|Attempt to convert rich text characters missing from the currently selected font to normal characters. As an example, this converts a superscript 4 to a normal 4, but leaves a superscript 3 as-is (except with the `'ascii'` font). <br>This is set to false automatically if there is not rich text. `[default=true;]`|

### Compatibility, version info, and licence
Compatibility considerations:
- Multi-line inputs may have more trailing blank elements than intended. This is especially true for characters encoded with multiple elements (>127 for Octave and >65535 for Matlab).

|Test suite result|Windows|Linux|MacOS|
|---|---|---|---|
|Matlab R2023a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2022b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2022a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2021b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2021a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2020b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2020a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2019b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2019a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2018a|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it></it>|
|Matlab R2017b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2016b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2015a|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it></it>|
|Matlab R2013b|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2007b|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab 6.5 (R13)|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 8.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 7.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 6.2.0|<it>W11 : Pass</it>|<it>raspbian_11 : Pass</it>|<it>Catalina : Pass</it>|
|Octave 5.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 4.4.1|<it>W11 : Pass</it>|<it></it>|<it>Catalina : Pass</it>|

    Version: 2.0.0
    Date:    2023-09-14
    Author:  H.J. Wisselink
    Licence: CC by-nc-sa 4.0 ( https://creativecommons.org/licenses/by-nc-sa/4.0 )
    Email = 'h_j_wisselink*alumnus_utwente_nl';
    Real_email = regexprep(Email,{'*','_'},{'@','.'})

### Test suite

The tester is included so you can test if your own modifications would introduce any bugs. These tests form the basis for the compatibility table above. Note that functions may be different between the tester version and the normal function. Make sure to apply any modifications to both.
