When /^I create a new genomer project$/ do
  step 'I successfully run `genomer init project`'
  step 'I cd to "project"'
  step 'I append to "Gemfile" with "gem \'genomer-plugin-summary\', :path =>\'../../../\'"'
end
