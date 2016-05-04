## How To Run

Create your `.env` file and set the following variables:

```
PORT=3005
WEB_CONCURRENCY=4
```

Then run the following:

`foreman start -f Procfile`

### Sidekiq

If you want to view the UI for Sidekiq, visit `http://localhost:$PORT/sidekiq` and set the `SIDEKIQ_USERNAME` and `SIDEKIQ_PASSWORD` in your `.env`
