## Authentication / Authorization Notes

Current decision: admin and candidate pages are exposed by route only for the MVP — no authentication is required. This simplifies initial development and testing, but it is insecure for production.

Recommendations:
- Add token-based authentication (JWT) or session-based auth for admin routes before production.
- Update sequence diagrams to include an `Auth Service` participant when implementing authentication.
