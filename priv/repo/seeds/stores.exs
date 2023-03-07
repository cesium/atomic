defmodule Atomic.Repo.Seeds.Stores do
  alias Atomic.Repo
  alias Atomic.Inventory.Store
  alias Atomic.Organizations.Organization

  def run do
    seed_stores()
  end

  def seed_stores() do
    case Repo.all(Store) do
      [] ->
        [
          %{
            name: "CeSIUM Store",
            organization_id: Repo.get_by(Organization, name: "CeSIUM") |> Map.get(:id)
          },
          %{
            name: "AEDUM Store",
            organization_id: Repo.get_by(Organization, name: "AEDUM") |> Map.get(:id)
          },
          %{
            name: "ELSA Store",
            organization_id: Repo.get_by(Organization, name: "ELSA") |> Map.get(:id)
          },
        ]
        |> Enum.each(&insert_store/1)

      _ ->
        Mix.shell().error("Found stores, aborting seeding stores.")
    end
  end

  defp insert_store(data) do
    %Store{}
    |> Store.changeset(data)
    |> Repo.insert!()
  end
end

Atomic.Repo.Seeds.Stores.run()
