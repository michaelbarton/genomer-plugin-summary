Feature: Producing a summary of the scaffold
  In order to have an overview of the scaffold
  A user can use the "scaffod" command
  to generate the a tabular output of the scaffold

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
     When I run `genomer summary scaffold`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------------+-----------+
      |         Scaffold         |
      +--------------+-----------+
      | Contigs (#)  |         1 |
      | Gaps (#)     |         0 |
      +--------------+-----------+
      | Size (bp)    |         4 |
      | Contigs (bp) |         4 |
      | Gaps (bp)    |         0 |
      +--------------+-----------+
      | G+C (%)      |     50.00 |
      | Contigs (%)  |    100.00 |
      | Gaps (%)     |      0.00 |
      +--------------+-----------+

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
     When I run `genomer summary scaffold`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------------+-----------+
      |         Scaffold         |
      +--------------+-----------+
      | Contigs (#)  |         2 |
      | Gaps (#)     |         0 |
      +--------------+-----------+
      | Size (bp)    |         8 |
      | Contigs (bp) |         8 |
      | Gaps (bp)    |         0 |
      +--------------+-----------+
      | G+C (%)      |     75.00 |
      | Contigs (%)  |    100.00 |
      | Gaps (%)     |      0.00 |
      +--------------+-----------+

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
     When I run `genomer summary scaffold`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------------+-----------+
      |         Scaffold         |
      +--------------+-----------+
      | Contigs (#)  |         2 |
      | Gaps (#)     |         1 |
      +--------------+-----------+
      | Size (bp)    |        13 |
      | Contigs (bp) |         8 |
      | Gaps (bp)    |         5 |
      +--------------+-----------+
      | G+C (%)      |     75.00 |
      | Contigs (%)  |     61.54 |
      | Gaps (%)     |     38.46 |
      +--------------+-----------+

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
     When I run `genomer summary scaffold --format=csv`
     Then the exit status should be 0
      And the output should contain:
      """
      contigs_#,2
      gaps_#,1
      size_bp,13
      contigs_bp,8
      gaps_bp,5
      gc_%,75.00
      contigs_%,61.54
      gaps_%,38.46
      """
