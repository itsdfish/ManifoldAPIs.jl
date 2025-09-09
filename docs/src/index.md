```@meta
CurrentModule = ManifoldAPIs
```

# ManifoldAPIs

This package allows users to interface with manifold.markets with the Julia programming language. 

# Quick Example

```@example quick_example
using ManifoldAPIs
using DataFrames 
using StatsPlots 

api = ManifoldAPI()

market_slug = "supreme-court-rules-trump-tariffs-u"
market = get_market_by_slug(api, market_slug)
bets = get_bets(api; market_slug)

df = create_dataframe(market, bets)
plot_prices(df; size = (800, 400))
```
