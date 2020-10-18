# Bundle install has a habit of dying under certain adverse network conditions
# that we seem to be experiencing at the moment.  Retry it until it works.
bundle_install() {
  N=0
  STATUS=1
  until [ ${N} -ge 5 ]
  do
    echo "Trying bundle (with retry)"
    bundle install $@ && STATUS=0 && break
    echo 'Try bundle again ...'
    N=$[${N}+1]
    sleep 1
  done
  return ${STATUS}
}

# Set up environment variables for staging and production builds
set -a && . /app/.aptible.env

if [[ $RACK_ENV = "staging" ]] || [[ $RACK_ENV = "production" ]]; then
  echo "bundle install without development or testing groups"

  bundle_install --retry=5 --without development test
else
  echo "bundle installing all gems"
  bundle_install --retry=5
fi
exit "$?"
