# Business Intelligence Report: Booking Platform Performance & Pricing Anomalies

## Executive Summary
This report analyzes transactional data across distribution channels (Mobile App, Website, and Agency Portal) to evaluate revenue generation, calculate pricing standard deviations, and isolate operational anomalies. By evaluating these metrics, we identify high-yield consumer funnels and uncover systemic booking inconsistencies.

---

## 1. Distribution Channel Revenue & Margin Analysis
Based on aggregate transaction data, consumer purchasing behaviors vary significantly depending on the platform used:

* **Agency Portal:** Generates the highest single-ticket yield with a premium average ticket price (**$510.00**). This channel represents low-volume but high-margin corporate or bundled bookings.
* **Website:** Functions as the primary volume driver. While it handles a high number of transactions, it exhibits a wide variance in pricing due to split customer profiles (standard travelers vs. premium selections).
* **Mobile App:** Demonstrates steady retail booking volumes with a baseline average ticket price of **$350.00**, indicating a highly predictable retail user base.

---

## 2. Isolating Pricing Anomalies & Outliers
To protect bottom-line margins, the system monitors the **Price Spread** (`MAX(price) - MIN(price)`) across all platforms. 

### Metric Breakdown:
Using custom subqueries that isolate platforms exceeding the global average ticket price, we discovered a vital pricing anomaly within the **Website** channel:
* **The Anomaly:** A standard ticket was processed through the website engine at a valuation of **$0.00** during a transaction update.
* **Root-Cause Analysis:** Cross-referencing this anomaly with the `booking` status ledger revealed that the $0.00 entry was tied directly to an immediate ticket **Cancellation**. 
* **Data Engineering Solution:** Instead of injecting a `NULL` or missing marker into financial records—which risks skewing statistical math—the system updates the baseline transaction balance to exactly `0.00` to maintain calculation safety while signaling a canceled seat.

---

## 3. Strategic Business Recommendations
1. **Capitalize on Agency Volume:** Since Agency Portals yield the highest ticket averages, marketing efforts should incentivize third-party platforms to expand corporate booking volumes.
2. **Implement Pricing Guardrails:** Add database constraints or application-layer validation to ensure that an active status booking cannot drop below a standard minimum cost floor, preventing accidental $0.00 active tickets.
