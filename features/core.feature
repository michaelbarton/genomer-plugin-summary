Feature: Producing different summaries of a genomes scaffold
  In order to have an overview of a genome scaffold
  A user can use the "summary" plugin
  to generate different tabular output of the scaffold

  @disable-bundler
  Scenario: Getting the man page for the scaffold summary plugin
    Given I create a new genomer project
     When I run `genomer man summary`
     Then the exit status should be 0
      And the output should contain a valid man page
      And the output should contain "GENOMER-SUMMARY(1)"
      And the output should contain "gaps"
