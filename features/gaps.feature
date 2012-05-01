Feature: Producing a summary of the scaffold gaps
  In order to have an overview of the gaps in a scaffold
  A user can use the "gaps" command
  to generate the a tabular output of the scaffold gaps

  @disable-bundler
  Scenario: A single contig scaffold
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGGC
      """
     When I run `genomer summary gaps`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------------------------------------------------+
      |  Scaffold Gaps                                           |
      +----------+----------+----------+----------+--------------+
      |  Number  |  Length  |   Start  |    End   |     Type     |
      +----------+----------+----------+----------+--------------+
      +----------+----------+----------+----------+--------------+
      """

  @disable-bundler
  Scenario: A single contig with an internal gap
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGNNNATG
      """
     When I run `genomer summary gaps`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------------------------------------------------+
      |  Scaffold Gaps                                           |
      +----------+----------+----------+----------+--------------+
      |  Number  |  Length  |   Start  |    End   |     Type     |
      +----------+----------+----------+----------+--------------+
      |        1 |        3 |        4 |        6 |    contig    |
      +----------+----------+----------+----------+--------------+
      """

  @disable-bundler
  Scenario: Two contigs separated by an unresolved region
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      -
        unresolved:
          length: 10
      -
        sequence:
          source: "contig00001"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGCC
      """
     When I run `genomer summary gaps`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------------------------------------------------+
      |  Scaffold Gaps                                           |
      +----------+----------+----------+----------+--------------+
      |  Number  |  Length  |   Start  |    End   |     Type     |
      +----------+----------+----------+----------+--------------+
      |        1 |       10 |        6 |       16 |  unresolved  |
      +----------+----------+----------+----------+--------------+
      """

  @disable-bundler
  Scenario: A mixture of contig gaps and unresolved regions
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      -
        unresolved:
          length: 10
      -
        sequence:
          source: "contig00002"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGNNNATG
      >contig00002
      ANG
      """
     When I run `genomer summary gaps`
     Then the exit status should be 0
      And the output should contain:
      """
      +----------------------------------------------------------+
      |  Scaffold Gaps                                           |
      +----------+----------+----------+----------+--------------+
      |  Number  |  Length  |   Start  |    End   |     Type     |
      +----------+----------+----------+----------+--------------+
      |        1 |        3 |        4 |        6 |    contig    |
      |        2 |       10 |       10 |       20 |  unresolved  |
      |        3 |        1 |       22 |       22 |    contig    |
      +----------+----------+----------+----------+--------------+
      """
