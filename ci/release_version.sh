#!/bin/bash

set -eu
#set -x

# LAST_TAG=$(git describe --tags --abbrev=0)
# CURRENT_TAG=$(git describe --tags --abbrev=0 --exact-match 2>/dev/null || true)


# Release functions
# ======================

gen_changelog()
{

  echo "INFO: Generate diff CHANGELOG"

  # Generate small diff
  rm -rf dist/
  mkdir dist
  cat <<EOF > dist/RELEASE.md
# What's new ?

## List of changes

EOF
  echo "RUN: semantic-release changelog --unreleased >> dist/RELEASE.md"
  semantic-release changelog --unreleased >> dist/RELEASE.md
  #semantic-release changelog --unreleased ${CLI_ARGS[@]} >> dist/RELEASE.md

}

make_new_release ()
{
  local args=${@-}

  echo "INFO: Running command: semantic-release publish -D remove_dist=false $args"
  semantic-release -D remove_dist=false $args publish
  #semantic-release -v DEBUG -D remove_dist=false $args publish
}


# Environment management
# ======================

env_defaults ()
{

  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  INCREMENT=''
  PRERELEASE=false
  NOOP=false
  NO_CONFIRM=false

  case "$BRANCH" in
    develop)
      PRERELEASE=true
      TARGET_BRANCH=develop
      ;;
    main)
      TARGET_BRANCH=main
      ;;
    *)
      echo "ERROR: Branch is not supported for release: $BRANCH"
      exit 1
      ;;
  esac

  # Parse args
  while getopts i:nf option
  do
  	case "${option}" in
  		i) INCREMENT="$OPTARG";;
  		n) NOOP=true ;;
  		f) NO_CONFIRM=true ;;
  	esac
  done
}

env_prepare ()
{
  # Create CLI Args
  CLI_ARGS=()

  # Check mode
  if [[ "${NOOP-}" != 'false' ]]; then
    echo "INFO: Dry mode enabled !"
    CLI_ARGS+=( "--noop" )
  fi

  # Pre release mode
  if [[ "${PRERELEASE}" == 'true' ]]; then
    echo "INFO: This release is a development release"
    CLI_ARGS+=( "--prerelease" )
  else
    echo "INFO: This release is a stable release"
  fi

  # Version bump
  if [[ -z "${INCREMENT-}" ]]; then
    echo "INFO: Auto-increment enabled"
  else
    echo "INFO: Requested increment: $INCREMENT"
    CLI_ARGS+=( "--$INCREMENT" )
  fi


  # Target branch merge
  echo "INFO: Release version on '$TARGET_BRANCH' branch"
  CLI_ARGS+=( "-D branch=$TARGET_BRANCH" )

  # Recap
  CURR_VERS=$(semantic-release  print-version --current)
  NEXT_VERS=$(semantic-release  print-version --next ${CLI_ARGS[@]} )
  echo "INFO: Version bump from '$CURR_VERS' to '$NEXT_VERS'"

}

print_confirm ()
{
  # Return false if timeout is 0
  if [[ "$NO_CONFIRM" == 'true' ]] || [[ "$NOOP" == 'true' ]] ; then
    echo "INFO: Creating new realses"
    return 0
  fi

  # Allow user to input into stdin
  exec < /dev/tty

  # Wait timeout before user can cancel ...
  read ${GIT_IDENT_TMOUT:+-t $GIT_IDENT_TMOUT} -p " ASK: Press enter or 'Y' continue, 'n' to abort: " r
  if [[ "$?" -ne 0 ]]; then
    echo
    echo "WARN: Timeout expired (${GIT_IDENT_TMOUT}s), continuing ..."
  fi

  # Analyse answer
  r=${r,,}
  case "${r:-y}" in
    q|n)
      echo " ERR: User cancelled"
      exit 1
      ;;
  esac

}


main ()
{
  env_defaults ${@-}
  env_prepare

  echo "Question: Do you want to continue release? $CURR_VERS -> $NEXT_VERS"
  print_confirm

  gen_changelog
  make_new_release ${CLI_ARGS[@]}
}

main ${@-}
