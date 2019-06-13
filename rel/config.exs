~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

cookie =
  :crypto.hash(:sha256, "QqyfQIBT7j6HXkyxbnwmZixU79T83be0ApUyiAfo8T8")
  |> Base.encode16()
  |> String.to_atom()

use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :"Z.g*x:=M=[4`XA;<3{LSnnHVSH^liRIeel(oEkVjlPeHY`KsCCHHgZSeNC3`hgj5")
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)

  set(cookie: cookie)

  set(
    config_providers: [
      {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
    ]
  )

  set(
    overlays: [
      {:copy, "rel/config/prod.exs", "etc/config.exs"}
    ]
  )

  set(vm_args: "rel/vm.args")
end

release :barcodes do
  set(version: current_version(:barcodes))

  set(
    applications: [
      :runtime_tools
    ]
  )
end
