defmodule ParamValidator.Errors.SubstitutionSpec do
  use ESpec

  describe "substitute" do
    subject do: described_module().substitute(text(), args())

    let :text, do: "this {} proves that substitutions {}"
    let :args, do: ["test", "work"]

    it do: is_expected() |> to(eq "this test proves that substitutions work")
  end
end
