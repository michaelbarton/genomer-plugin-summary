Feature: Producing a summary of the genome
  In order to have an overview of the genome
  A user can use the "genome" command
  to generate the a tabular output of the genome

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
     When I run `genomer summary genome`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------+-----------+
      |          Scaffold          |
      +----------------+-----------+
      | Sequences (#)  |         1 |
      | Contigs (#)    |         1 |
      | Gaps (#)       |         0 |
      +----------------+-----------+
      | Size (bp)      |         4 |
      | Sequences (bp) |         4 |
      | Contigs (bp)   |         4 |
      | Gaps (bp)      |         0 |
      +----------------+-----------+
      | G+C (%)        |     50.00 |
      | Sequences (%)  |    100.00 |
      | Contigs (%)    |    100.00 |
      | Gaps (%)       |      0.00 |
      +----------------+-----------+

      """

  Scenario: A scaffold with a two sequences
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
      ATGC
      >contig0002
      GGGC
      """
     When I run `genomer summary genome`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------+-----------+
      |          Scaffold          |
      +----------------+-----------+
      | Sequences (#)  |         2 |
      | Contigs (#)    |         1 |
      | Gaps (#)       |         0 |
      +----------------+-----------+
      | Size (bp)      |         8 |
      | Sequences (bp) |         8 |
      | Contigs (bp)   |         8 |
      | Gaps (bp)      |         0 |
      +----------------+-----------+
      | G+C (%)        |     75.00 |
      | Sequences (%)  |    100.00 |
      | Contigs (%)    |    100.00 |
      | Gaps (%)       |      0.00 |
      +----------------+-----------+

      """

  Scenario: A scaffold with a two sequences and a gap
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
        -
          sequence:
            source: contig0001
        -
          unresolved:
            length: 5
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGC
      >contig0002
      GGGC
      """
     When I run `genomer summary genome`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------+-----------+
      |          Scaffold          |
      +----------------+-----------+
      | Sequences (#)  |         2 |
      | Contigs (#)    |         2 |
      | Gaps (#)       |         1 |
      +----------------+-----------+
      | Size (bp)      |        13 |
      | Sequences (bp) |         8 |
      | Contigs (bp)   |         8 |
      | Gaps (bp)      |         5 |
      +----------------+-----------+
      | G+C (%)        |     75.00 |
      | Sequences (%)  |     61.54 |
      | Contigs (%)    |     61.54 |
      | Gaps (%)       |     38.46 |
      +----------------+-----------+

      """

  Scenario: A scaffold with a two sequences containing gaps
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
      AAANNNGGG
      >contig0002
      AAANNNGGG
      """
     When I run `genomer summary genome`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------+-----------+
      |          Scaffold          |
      +----------------+-----------+
      | Sequences (#)  |         2 |
      | Contigs (#)    |         3 |
      | Gaps (#)       |         0 |
      +----------------+-----------+
      | Size (bp)      |        18 |
      | Sequences (bp) |        18 |
      | Contigs (bp)   |        12 |
      | Gaps (bp)      |         0 |
      +----------------+-----------+
      | G+C (%)        |     50.00 |
      | Sequences (%)  |    100.00 |
      | Contigs (%)    |     66.67 |
      | Gaps (%)       |      0.00 |
      +----------------+-----------+

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
          unresolved:
            length: 5
        -
          sequence:
            source: contig0002
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig0001
      ATGC
      >contig0002
      GGGC
      """
     When I run `genomer summary genome --output=csv`
     Then the exit status should be 0
      And the output should contain:
      """
      sequences_#,2
      contigs_#,2
      gaps_#,1
      size_bp,13
      sequences_bp,8
      contigs_bp,8
      gaps_bp,5
      g+c_%,75.00
      sequences_%,61.54
      contigs_%,61.54
      gaps_%,38.46
      """
