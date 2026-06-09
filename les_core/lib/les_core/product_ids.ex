defmodule LesCore.ProductIds do
  @moduledoc """
  Canonical product id helpers used by the lightweight core contract.

  Keep this list aligned with `docs/PRODUCT_IDS.md`. The registry validator is
  the cross-repo guard; this module is the runtime guard for contract calls.
  """

  @canonical_ids ~w(
    lestupid-roof
    les-core
    les-certification
    les-go
    les-wait
    les-poke
    les-match
    les-care
    les-harmonica
    les-contacts
    les-travel
    les-commerce
    lescommerce-core
    lescommerce-quick-commerce
    lescommerce-diydiy
    lescommerce-marketplace
    lescommerce-books
    lescommerce-storefronts
    les-itemotel
    les-affiliate
    les-ai
    agentandbot-governance-core
    ai-senaryo
    e-any
    e-any-com
    eny-com-tr
    e-any-info
    ipcioglu-com
    ilkerkaan-ipcioglu-com
    lestupid-lan
  )

  def all, do: @canonical_ids

  def canonical?(product_id) when is_binary(product_id), do: product_id in @canonical_ids
  def canonical?(_), do: false
end
