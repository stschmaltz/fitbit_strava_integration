ExUnit.start()

Mox.defmock(FitbitStravaIntegration.HTTPClient.MockApiHelper,
  for: FitbitStravaIntegration.HTTPClient.Behaviour
)
