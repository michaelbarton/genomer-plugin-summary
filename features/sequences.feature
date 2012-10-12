Feature: Producing a summary of the scaffold sequences
  In order to have an overview of the sequences in a scaffold
  A user can use the "sequence" command
  to generate the a tabular output of the scaffold sequences

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
      | Sequence         | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      +------------------+------------+------------+------------+----------+--------+
      | Scaffold         |         NA |         NA |         NA |       NA |     NA |
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
      | Sequence         | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig0001       |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      | Scaffold         |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      """
