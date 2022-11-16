#!/usr/bin/env bats

# See how to install BATS
# https://bats-core.readthedocs.io/en/stable/tutorial.html#quick-installation


@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}


@test "test myprj call" {
  myprj
}

@test "test task CLI" {
  task --list-all
  #[ "$result" -eq 4 ]
}
