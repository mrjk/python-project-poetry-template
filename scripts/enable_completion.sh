

main ()
{
  comp_dir="${DIRENV_DIR#-}/.direnv/comp"

  if [[ -z "$comp_dir/*" ]]; then
    >&2 echo "ERROR: No completions are available"
    >&2 echo "INFO: please run 'task dev:install_comp' first"
    return 1
  fi

  for comp in $comp_dir/*; do
    >&2 echo "INFO: Load completion: $comp"
    source $comp
  done

  >&2 echo "INFO: All completion loaded"
}

main $@
