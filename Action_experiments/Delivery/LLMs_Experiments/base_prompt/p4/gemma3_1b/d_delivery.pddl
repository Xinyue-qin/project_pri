action pick-up
  extend forall m     // Extend forall to handle the 'agent' identifier
   precondition action pick-up
  when
    agent has-package
    agent at-location
    package requested
  then
    agent pick-up package-l
  else
    agent pick-up package-d