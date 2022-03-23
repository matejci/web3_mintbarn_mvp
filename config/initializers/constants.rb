# frozen_string_literal: true

EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i.freeze
PHONE_REGEX = /\A\+[0-9]{1,3}-[0-9]{4,14}\z/.freeze

KNOWN_USER_AGENTS = ['Googlebot',
                     'Bingbot',
                     'Slurp',
                     'Twitterbot',
                     'LinkedInBot',
                     'Slackbot-LinkExpanding 1.0 (+https://api.slack.com/robots)',
                     'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)',
                     'facebookexternalhit/1.1',
                     'PayPal'].freeze