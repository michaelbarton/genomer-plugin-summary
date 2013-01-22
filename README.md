![Summary: metrics for genome projects](http://genomer.s3.amazonaws.com/icon/summary/summary.jpg)

## About

Summary is a plugin for the [genomer][] tool for genome finishing. This summary
plugin provides metrics that useful are to understanding that state of your
genome scaffold. Plugins are added to a genomer project by specifying them in
the project Gemfile. Each summary function is documented with a [manual
page][man].

[genomer]: https://github.com/michaelbarton/genomer
[man]: https://github.com/michaelbarton/genomer-plugin-summary/tree/master/man

## Usage

The following command will provide a list of all the gaps in your genome
scaffold:

    $ genomer summary gaps

Producing output similiar to as follows:

    +----------+----------+----------+----------+--------------+
    |                      Scaffold Gaps                       |
    +----------+----------+----------+----------+--------------+
    |  Number  |  Length  |  Start   |   End    |     Type     |
    +----------+----------+----------+----------+--------------+
    |        1 |      400 |   121250 |   121649 |  unresolved  |
    |        2 |      659 |   123354 |   124012 |    contig    |
    |        3 |       10 |   126781 |   126790 |  unresolved  |
    |        4 |       10 |   127393 |   127402 |  unresolved  |
    |        5 |      500 |   778936 |   779435 |  unresolved  |
    |        6 |      659 |   781140 |   781798 |    contig    |
    |        7 |       10 |   784567 |   784576 |  unresolved  |
    |        8 |      300 |   785179 |   785478 |  unresolved  |
    |        9 |      556 |   803968 |   804523 |    contig    |
    |       10 |      242 |  1032294 |  1032535 |    contig    |
    |       11 |     1751 |  1057108 |  1058858 |    contig    |
    |       12 |      575 |  1137194 |  1137768 |    contig    |
    <remainder omitted>

Other commands are available for showing contigs, sequences, and the complete
scaffolded genome. These are listed in the [manual page][man] directory.

## Installation

Add this line to your genomer projects's Gemfile:

    gem 'genomer-plugin-summary'

And then execute in the project directory:

    $ bundle

Run the `help` command and the summary plugin should be available:

    $ genomer help
    $ genomer man summary

## Copyright

Genomer copyright (c) 2010 by Michael Barton. Genomer is licensed under the MIT
license. See LICENSE.txt for further details. The tape measure image is used
under a Creative Commons Generic 2.0 Licence. The original can be [found on
flickr.][flickr]

[flickr]: http://www.flickr.com/photos/aussiegall/286709039/
