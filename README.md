# OmniAuth Square

This gem contains the Square strategy for OmniAuth.

Square uses the OAuth2 flow, you can read about it here: http://connect.squareup.com

## How To Use It

So let's say you're using Rails, you need to add the strategy to your `Gemfile`:

    gem 'omniauth-square-oauth2', '~> 0.2.1'

You can pull it in directly from github (if you really want to) e.g.:

    gem 'omniauth-square-oauth2', :git => 'https://github.com/nickrobinson/omniauth-square-oauth2.git'

Once these are in, you need to add the following to your `config/initializers/devise.rb` (NOTE: A full enumeration of Square Permissions can be found [here](https://developer.squareup.com/docs/oauth-api/square-permissions).):

    config.omniauth :square, "your_app_id", "your_app_oauth_secret", {:scope => "ITEMS_READ,ITEMS_WRITE,MERCHANT_PROFILE_READ"}

Sandbox Example:

     config.omniauth :square, "your_app_id", "your_app_oauth_secret", {:scope => "ITEMS_READ,ITEMS_WRITE,MERCHANT_PROFILE_READ", :client_options => {:site => 'https://connect.squareupsandbox.com'}}

You will obviously have to put in your key and secret, which you get when you register your app with Square (they call them Application Key and Secret Key).

Now just follow the README at: https://github.com/intridea/omniauth
