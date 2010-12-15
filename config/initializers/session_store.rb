# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_race_session',
  :secret      => 'c2713f58ed4bee47d65977fd15e8141bdf75a451326256c8fbbfb19a25f4995ad939a7ed625ebacdcb3bf9de5c84ecc884d658822566cfb9caa6ab79d3e7eecc',
  :expire_after => 2.years.from_now
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
