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
     When I run `genomer summary sequences`
     Then the exit status should be 0
      And the output should contain:
      """
      +--------------+-----------+
      |        Scaffold          |
      +--------------+-----------+
      | Contigs (#)  |         1 |
      | Gaps (#)     |         0 |
      +--------------+-----------+
      | Size (bp)    |         4 |
      | Contigs (bp) |         1 |
      | Gaps (bp)    |         0 |
      +--------------+-----------+
      | G+C (%)      |     50.00 |
      | Contigs (%)  |    100.00 |
      | Gaps (%)     |      0.00 |
      +--------------+-----------+

      """
