### Nomad Service Discovery

This will download and run Nomad in dev mode to get us a platform.
It then runs two instances of fake service, a frontend and a backend.

These are registered into Nomad's service discovery, the frontend uses this to find the backend.

