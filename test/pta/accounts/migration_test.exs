defmodule Pta.Accounts.MigrationTest do
  use Pta.DataCase

  alias Pta.Accounts
  alias Pta.Accounts.Migration

  describe "accounts" do
    test "account_prefixes/0 returns all account prefixes" do
      account = fixture(:seed_account)

      assert Migration.account_prefixes() == [Accounts.prefix(account)]
    end
  end
end
