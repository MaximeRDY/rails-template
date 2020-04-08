# Rails Templates

Quickly generate a rails app configuration
using [Rails Templates](http://guides.rubyonrails.org/rails_application_templates.html).

## Grape

Get a minimal rails 4.1 app ready to be deployed on Heroku with Grape Api and debugging gems.

```bash
rails new \
  --database postgresql \
  -m https://raw.githubusercontent.com/MaximeRDY/rails-template/master/grape.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

## For Local TEST

```
rails new \
  --database postgresql \
  -m ./rails-templates/grape.rb \
  test-grape
```
