Feature: Producing a summary of the scaffold sequences
  In order to have an overview of the sequences in a scaffold
  A user can use the "sequence" command
  to generate a tabular output of the scaffold sequences

  @disable-bundler
  Scenario: Getting the man page for the scaffold sequences summary
    Given I create a new genomer project
     When I run `genomer man summary sequences`
     Then the exit status should be 0
      And the output should contain a valid man page
      And the output should contain "GENOMER-SUMMARY-SEQUENCES(1)"

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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      +------------------+------------+------------+------------+----------+--------+
      | All              |          0 |          0 |          0 |     0.00 |   0.00 |
      +------------------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a single sequence
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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      | All              |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two different sequences
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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          1 |          6 |          6 |    50.00 |  66.67 |
      | contig0002       |          7 |         12 |          6 |    50.00 |  33.33 |
      +------------------+------------+------------+------------+----------+--------+
      | All              |          1 |         12 |         12 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two repeated sequences
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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          1 |          6 |          6 |    50.00 |  66.67 |
      | contig0001       |          7 |         12 |          6 |    50.00 |  66.67 |
      +------------------+------------+------------+------------+----------+--------+
      | All              |          1 |         12 |         12 |   100.00 |  66.67 |
      +------------------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two sequences separated by a gap
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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          1 |          6 |          6 |    30.00 |  66.67 |
      | contig0002       |         15 |         20 |          6 |    30.00 |  33.33 |
      +------------------+------------+------------+------------+----------+--------+
      | All              |          1 |         20 |         12 |    60.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      """

  Scenario: A scaffold with a two sequences and a gap at the start
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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          9 |         14 |          6 |    30.00 |  66.67 |
      | contig0002       |         15 |         20 |          6 |    30.00 |  33.33 |
      +------------------+------------+------------+------------+----------+--------+
      | All              |          9 |         20 |         12 |    60.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      """


  Scenario: A scaffold with a two sequences and a gap at the end
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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      |     Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          1 |          6 |          6 |    30.00 |  66.67 |
      | contig0002       |          7 |         12 |          6 |    30.00 |  33.33 |
      +------------------+------------+------------+------------+----------+--------+
      | All              |          1 |         12 |         12 |    60.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
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
     When I run `genomer summary sequences --output=csv`
     Then the exit status should be 0
      And the output should contain:
      """
      sequence,start_bp,end_bp,size_bp,size_%,gc_%
      contig0001,1,6,6,30.00,66.67
      contig0002,7,12,6,30.00,33.33
      all,1,12,12,60.00,50.00
      """
