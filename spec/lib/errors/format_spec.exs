defmodule Gate.Errors.FormatSpec do
  use ESpec

  subject do: described_module().call(params())

  describe "call" do
    context "when value is a list" do
      let :params, do: [1, 2, 3]

      it do: is_expected() |> to(eq("[1, 2, 3]"))
    end

    context "when value is a string" do
      let :params, do: "str"

      it do: is_expected() |> to(eq "str")
    end
  end
end
