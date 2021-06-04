//#-hidden-code
//
// Copyright © 2021 Ethan Wong. Licensed under MIT.
//
//#-end-hidden-code
//#-hidden-code
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
//#-code-completion(everything, hide)
/*:
# Code Points, Blocks and Planes

## How Unicode Organizes Characters

Unicode organizes characters into 17 planes numbered 0 to 16. A **plane** is a continuous group of 65536 code points.

Plane 0 (Basic Multilingual Plane, BMP), contains most commonly used characters. Planes 1 through 16 are called "supplementary planes". As of Unicode version 13.0, seven of these planes have assigned code points, and five are named.

Planes are further subdivided into **blocks**, which, unlike planes, do not have a fixed size. Unicode 13.0 defines 308 blocks, covering 26% of the possible code point space.

**Code points** are numbers that make up the codespace, usually represented with hexadecimal starting with "U+". Unicode can address ranges from `U+000000` to `U+10FFFF`, *with highest two digits identical to plane number*. Every assigned code point has various properties as well as an uppercased permanent name. For example, 😂 (U+1F602, FACE WITH TEARS OF JOY EMOJI) lies in `Plane 1`, block `Emoticons (Emoji)`.

**Characters** may be composed _one or more_ code points, for example, the letter é (U+00E9, LATIN SMALL LETTER E WITH ACUTE), can also be represented as a pair of e (U+0065, LATIN SMALL LETTER E), followed by ́ (U+0301, COMBINING ACUTE ACCENT). Unicode defines several related properties and rules for text-rendering systems to render properly.

![1-1: Character Combining](1-1-character-combining.png)

- Experiment:
  Tap "Run My Code" to bring the Unicode table full screen. And explore how Unicode or organizes characters.

![1-2: User Interface](1-2-user-interface.png)

![1-3: Plane View](1-3-plane-view.png)

- Note:
  The "Last Resort" font is used when a character is not being capable to rendered by available fonts.

![1-4: Last Resort Font](1-4-last-resort.png)
*/
