@safetestset "get_market_by_slug" begin
    using ManifoldAPIs
    using Test

    api = ManifoldAPI()
    url = "https://manifold.markets/QuimLast/supreme-court-rules-trump-tariffs-u"
    market_slug = "supreme-court-rules-trump-tariffs-u"
    market = get_market_by_slug(api, market_slug)

    @test market.url == url
    @test market.slug == market_slug
    @test market.outcomeType == "BINARY"
end
