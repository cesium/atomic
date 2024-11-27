defmodule Atomic.Sasum do
  use Atomic.Context

  alias Atomic.Accounts

  @sasum_api_url "https://sasum.scl.pt/app.php"
  @sasum_dashboard_url "https://um.sincelo.pt/portal/index.php"

  def user_has_sasum_linked?(user_id) do
    Accounts.get_user!(user_id).sasum_hash != nil
  end

  def link_sasum(user_id, sasum_auth_params) do
    user = Accounts.get_user!(user_id)

    case Req.get(@sasum_api_url, params: [auth: sasum_auth_params["email"], pin: sasum_auth_params["password"]]) do
      {_req, resp} ->
        if resp.status == 200 do
          data = resp.body |> IO.inspect()
          if data["status"] == "OK" do
            Accounts.update_user(user, %{sasum_hash: data["hash"]})
          else
            {:error, "invalid credentials"}
          end
        else
          {:error, "couldn't connect to sasum"}
        end
      _ ->
        {:error, "couldn't connect to sasum"}
    end
  end

  def fetch_user_sasum_qr_code(user_id) do
    user = Accounts.get_user!(user_id)

    case Req.get(@sasum_dashboard_url, params: [hash: user.sasum_hash, sb: 1]) do
      {_req, resp} ->
        if resp.status == 200 do
          data = resp.body
          case Regex.run(~r/src='(data:image\/png;base64,[^']*)'/, data) do
            [_, qr_code] ->
              {:ok, qr_code}
            _ ->
              {:error, "couldn't find qr code"}
          end
        else
          {:error, "couldn't connect to sasum"}
        end
    end
  end
end
