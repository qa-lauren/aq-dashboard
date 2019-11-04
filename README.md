## Restart
```bash
pwr qa.powerreviews.io
cd /var/www/aq-dashboard/code
[rvmsudo bundle exec rake assets:precompile db:migrate RAILS_ENV=production]
rvmsudo bundle exec passenger stop
rvmsudo bundle exec passenger start --spawn-method direct
```
