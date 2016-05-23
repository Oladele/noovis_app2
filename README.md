## How To Run

Create your `.env` file and set the following variables:

```
PORT=3005
WEB_CONCURRENCY=4
```

Then run the following:

`foreman start -f Procfile`

### CRL Uploads

For CRL Uploads to work, you need the following things:

1) Redis

```
$ gem install redis
$ redis-server
```

2) AWS ENVs

You can get these from the Heroku config by runnning `heroku config -a noovis2-staging`:

* `AWS_ACCESS_KEY_ID`
* `AWS_REGION`
* `AWS_SECRET_ACCESS_KEY`
* `S3_BUCKET_NAME`

3) Sidekiq

Sidekiq will start if you run the foreman command above, otherwise `bundle exec sidekiq`.

### Sidekiq

If you want to view the UI for Sidekiq, visit `http://localhost:$PORT/sidekiq` and set the `SIDEKIQ_USERNAME` and `SIDEKIQ_PASSWORD` in your `.env`
