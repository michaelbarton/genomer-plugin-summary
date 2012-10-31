Feature: Producing a summary of the scaffold contigs
  In order to have an overview of the contigs in a scaffold
  A user can use the "contigs" command
  to generate the a tabular output of the scaffold contigs

  @disable-bundler
  Scenario: An empty scaffold
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          unresolved:
            length: 50
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      +--------+------------+------------+------------+----------+--------+
      |    All |          0 |          0 |          0 |     0.00 |   0.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a single contig
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |          4 |          4 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |          4 |          4 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two different contigs
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGCGC
      >contig0002
      ATATGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |         12 |         12 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |         12 |         12 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two repeated contigs
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          sequence:
            source: contig0001
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGCGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |         12 |         12 |   100.00 |  66.67 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |         12 |         12 |   100.00 |  66.67 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two contigs separated by a gap
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          unresolved:
            length: 8
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGCGC
      >contig0002
      ATATGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |          6 |          6 |    30.00 |  66.67 |
      |      2 |         15 |         20 |          6 |    30.00 |  33.33 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |         20 |         12 |    60.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two contigs and a gap at the start
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          unresolved:
            length: 8
        -
          sequence:
            source: contig0001
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGCGC
      >contig0002
      ATATGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          9 |         20 |         12 |    60.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          9 |         20 |         12 |    60.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two contigs and a gap at the end
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          sequence:
            source: contig0002
        -
          unresolved:
            length: 8
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGCGC
      >contig0002
      ATATGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |         12 |         12 |    60.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |         12 |         12 |    60.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with two contigs containing internal gaps
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATATNNNNGCGC
      >contig0002
      ATATNNNNGCGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |          4 |          4 |    16.67 |   0.00 |
      |      2 |          9 |         16 |          8 |    33.33 |  50.00 |
      |      3 |         21 |         24 |          4 |    16.67 | 100.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |         24 |         16 |    66.67 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with two contigs containing internal gaps separated by a gap
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          unresolved:
            length: 6
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATATNNNNGCGC
      >contig0002
      ATATNNNNGCGC
      """
     When I run `genomer summary contigs`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |          4 |          4 |    13.33 |   0.00 |
      |      2 |          9 |         12 |          4 |    13.33 | 100.00 |
      |      3 |         19 |         22 |          4 |    13.33 |   0.00 |
      |      4 |         27 |         30 |          4 |    13.33 | 100.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |         30 |         16 |    53.33 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      """

  Scenario: Generating CSV output
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          sequence:
            source: contig0002
        -
          unresolved:
            length: 8
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGCGC
      >contig0002
      ATATGC
      """
     When I run `genomer summary contigs --output=csv`
     Then the exit status should be 0
      And the output should contain:
      """
      contig,start_bp,end_bp,size_bp,size_%,gc_%
      1,1,12,12,60.00,50.00
      all,1,12,12,60.00,50.00
      """
