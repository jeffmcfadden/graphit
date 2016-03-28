# Graph It!

A very basic graphing library that writes data to bmp images.

It's probably too basic to work for you.

I use my `mrtg2xy` gem to process data from `mrtg` which I pipe into this utility.

## Installation

Install it yourself:

    $ gem install graphit

## Usage

    $ cat mydata | graphit -o graph.bmp

## Example Output

<img src="https://raw.githubusercontent.com/jeffmcfadden/graphit/master/test-01.png" />