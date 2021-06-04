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
# Encoding Text with UTF

## Unicode Transformation Format

**Unicode Transformation Formats, UTF** are the mostly used strategy to encode Unicode documents.

### UTF-32

**UTF-32** encodes Unicode code points with fixed 32 bits (four bytes) code units, although actually only 21 bits is needed to represent a code point. It's the simplest way to encode Unicode text, but space-inefficient.

![2-1: UTF-32](2-1-utf-32.png)

### UTF-16

**UTF-16** encodes Unicode code points into either one or two 16 bit (two bytes) code units. Code points in plane 0 (`U+0000` to `U+FFFF`) are encoded directly, Code points in supplementary planes are encoded using a method illustrated below:

![2-2: UTF-16](2-2-utf-16.png)

UTF-16 a bit more complex, but more space-efficient, since characters in the plane 0 only need 2 bytes to encode. However, UTF-16 are not able to represent code points from `U+D800` to `U+DBFF` and `U+DC00` to `U+DFFF`, which are called **high and low surrogates**.

### UTF-8

UTF-8 encodes Unicode code points into either one or two or three 8 bit (single byte) code units.

![2-3: UTF-16](2-3-utf-8.png)

As of 2021, more than 97% of web pages in the Internet are encoded using UTF-8. UTF-8 is the mostly used encoding method, due to following advantages:

* It is backwards compatible with ASCII encoding.

* It is read and written by bytes, thus has no byte-ordering issue.

* It can encode all code points in a relatively space-efficient way, especially for low code points.

However, it also has some drawbacks:

* It's relatively harder for text rendering systems parse and validate.

* For CJK (Chinese, Japanese and Korean) characters, it consumes more space compared with UTF-16.

- Experiment:
 Tap "Run My Code" to bring the playground full screen. Tap or enter some text, and explore how characters are encoded in different formats.
*/
